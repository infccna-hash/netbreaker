package admin

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"netbreaker.io/api/internal/users"
	"netbreaker.io/api/pkg/response"
	"netbreaker.io/api/pkg/types"
)

type Handler struct {
	pool     *pgxpool.Pool
	userRepo *users.Repository
}

func NewHandler(pool *pgxpool.Pool, userRepo *users.Repository) *Handler {
	return &Handler{pool: pool, userRepo: userRepo}
}

// GET /api/v1/admin/stats
func (h *Handler) Stats(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	var totalUsers, freeUsers, proUsers, bootcampUsers int
	_ = h.pool.QueryRow(ctx, `SELECT COUNT(*) FROM users`).Scan(&totalUsers)
	_ = h.pool.QueryRow(ctx, `SELECT COUNT(*) FROM users WHERE plan = 'free'`).Scan(&freeUsers)
	_ = h.pool.QueryRow(ctx, `SELECT COUNT(*) FROM users WHERE plan = 'pro'`).Scan(&proUsers)
	_ = h.pool.QueryRow(ctx, `SELECT COUNT(*) FROM users WHERE plan = 'bootcamp'`).Scan(&bootcampUsers)

	var totalProgress, totalCerts int
	_ = h.pool.QueryRow(ctx, `SELECT COUNT(*) FROM user_progress`).Scan(&totalProgress)
	_ = h.pool.QueryRow(ctx, `SELECT COUNT(*) FROM certificates`).Scan(&totalCerts)

	response.JSON(w, http.StatusOK, map[string]any{
		"users": map[string]int{
			"total": totalUsers, "free": freeUsers, "pro": proUsers, "bootcamp": bootcampUsers,
		},
		"total_progress_entries": totalProgress,
		"certificates_issued":    totalCerts,
		"estimated_mrr_usd":      proUsers*9 + bootcampUsers*49,
	})
}

// GET /api/v1/admin/users?page=1&limit=50&plan=pro
func (h *Handler) Users(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	page, _ := strconv.Atoi(r.URL.Query().Get("page"))
	if page < 1 {
		page = 1
	}
	limit, _ := strconv.Atoi(r.URL.Query().Get("limit"))
	if limit < 1 || limit > 100 {
		limit = 50
	}
	planFilter := r.URL.Query().Get("plan")

	rows, err := h.pool.Query(ctx,
		`SELECT id, email, name, plan, plan_expires_at, is_admin, created_at, updated_at
		 FROM users WHERE ($1 = '' OR plan = $1) ORDER BY created_at DESC LIMIT $2 OFFSET $3`,
		planFilter, limit, (page-1)*limit)
	if err != nil {
		response.InternalError(w)
		return
	}
	defer rows.Close()

	var list []types.User
	for rows.Next() {
		var u types.User
		if err := rows.Scan(&u.ID, &u.Email, &u.Name, &u.Plan, &u.PlanExpiresAt,
			&u.IsAdmin, &u.CreatedAt, &u.UpdatedAt); err != nil {
			continue
		}
		list = append(list, u)
	}
	response.JSON(w, http.StatusOK, map[string]any{"users": list, "page": page, "limit": limit})
}

// PATCH /api/v1/admin/users/:id/plan
func (h *Handler) SetPlan(w http.ResponseWriter, r *http.Request) {
	userID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		response.Error(w, http.StatusBadRequest, "invalid user id")
		return
	}

	var req struct {
		Plan string `json:"plan"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.Plan == "" {
		response.Error(w, http.StatusBadRequest, "plan required")
		return
	}
	if req.Plan != types.PlanFree && req.Plan != types.PlanPro && req.Plan != types.PlanBootcamp {
		response.Error(w, http.StatusBadRequest, "plan must be free, pro, or bootcamp")
		return
	}

	_, err = h.pool.Exec(r.Context(),
		`UPDATE users SET plan = $1, updated_at = NOW() WHERE id = $2`, req.Plan, userID)
	if err != nil {
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, map[string]string{"plan": req.Plan})
}
