package team

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/internal/users"
	"netbreaker.io/api/pkg/email"
	"netbreaker.io/api/pkg/response"
)

type Handler struct {
	repo     *Repository
	userRepo *users.Repository
	email    *email.Client
}

func NewHandler(repo *Repository, userRepo *users.Repository, emailClient *email.Client) *Handler {
	return &Handler{repo: repo, userRepo: userRepo, email: emailClient}
}

// team resolves (or creates) the caller's team. Callers are bootcamp users
// (enforced by RequirePlan middleware), so they own exactly one team.
func (h *Handler) team(r *http.Request) (ownerID uuid.UUID, teamID uuid.UUID, name string, err error) {
	ownerID = mustUserID(r)
	owner, uerr := h.userRepo.GetByID(r.Context(), ownerID)
	teamName := "My Team"
	if uerr == nil && owner.Name != "" {
		teamName = owner.Name + "'s Team"
	}
	t, terr := h.repo.GetOrCreateForOwner(r.Context(), ownerID, teamName)
	if terr != nil {
		return ownerID, uuid.Nil, "", terr
	}
	return ownerID, t.ID, t.Name, nil
}

// GET /api/v1/team
func (h *Handler) Get(w http.ResponseWriter, r *http.Request) {
	ownerID, _, _, err := h.team(r)
	if err != nil {
		response.InternalError(w)
		return
	}
	t, err := h.repo.GetByOwnerID(r.Context(), ownerID)
	if err != nil {
		response.InternalError(w)
		return
	}
	members, err := h.repo.GetMembersByTeamID(r.Context(), t.ID)
	if err != nil {
		response.InternalError(w)
		return
	}
	t.Members = members
	response.JSON(w, http.StatusOK, t)
}

type inviteRequest struct {
	Email string `json:"email"`
}

// POST /api/v1/team/invite
//
// v1 model: the invited person must already have a NetBreaker account. We look
// them up by email, add them to the team (enforcing the seat limit), and email
// them a heads-up. Inviting someone with no account returns 404 with guidance.
func (h *Handler) Invite(w http.ResponseWriter, r *http.Request) {
	_, teamID, teamName, err := h.team(r)
	if err != nil {
		response.InternalError(w)
		return
	}

	var req inviteRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.Email == "" {
		response.Error(w, http.StatusBadRequest, "email is required")
		return
	}

	invitee, err := h.userRepo.GetByEmail(r.Context(), req.Email)
	if err != nil {
		if errors.Is(err, users.ErrNotFound) {
			response.Error(w, http.StatusNotFound, "no NetBreaker account for that email — ask them to sign up first")
			return
		}
		response.InternalError(w)
		return
	}

	if err := h.repo.AddMember(r.Context(), teamID, invitee.ID, "member"); err != nil {
		if errors.Is(err, ErrSeatLimit) {
			response.ErrorCode(w, http.StatusConflict, "seat limit reached — remove a member or add seats", "SEAT_LIMIT")
			return
		}
		response.InternalError(w)
		return
	}

	if h.email != nil {
		go func() {
			_ = h.email.SendTeamInvite(invitee.Email, teamName, "https://netbreaker.io/dashboard")
		}()
	}

	response.JSON(w, http.StatusOK, map[string]string{"status": "member added"})
}

// DELETE /api/v1/team/members/:userID
func (h *Handler) RemoveMember(w http.ResponseWriter, r *http.Request) {
	_, teamID, _, err := h.team(r)
	if err != nil {
		response.InternalError(w)
		return
	}

	memberID, err := uuid.Parse(chi.URLParam(r, "userID"))
	if err != nil {
		response.Error(w, http.StatusBadRequest, "invalid user id")
		return
	}

	if err := h.repo.RemoveMember(r.Context(), teamID, memberID); err != nil {
		response.InternalError(w)
		return
	}
	response.NoContent(w)
}

// GET /api/v1/team/progress
func (h *Handler) Progress(w http.ResponseWriter, r *http.Request) {
	_, teamID, _, err := h.team(r)
	if err != nil {
		response.InternalError(w)
		return
	}

	rows, err := h.repo.MemberProgress(r.Context(), teamID)
	if err != nil {
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, map[string]any{
		"team_id": teamID,
		"members": rows,
	})
}

func mustUserID(r *http.Request) uuid.UUID {
	claims := auth.ClaimsFromCtx(r.Context())
	id, _ := uuid.Parse(claims.Subject)
	return id
}
