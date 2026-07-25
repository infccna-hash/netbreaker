package types

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// Plan constants
const (
	PlanFree     = "free"
	PlanPro      = "pro"
	PlanBootcamp = "bootcamp"
)

// Phase constants
const (
	PhaseBuild  = "build"
	PhaseAttack = "attack"
	PhaseHarden = "harden"
)

var AllPhases = []string{PhaseBuild, PhaseAttack, PhaseHarden}

// User is the public user model (no password hash).
type User struct {
	ID               uuid.UUID  `json:"id"`
	Email            string     `json:"email"`
	Name             string     `json:"name"`
	Plan             string     `json:"plan"`
	PlanExpiresAt    *time.Time `json:"plan_expires_at,omitempty"`
	StripeCustomerID *string    `json:"-"`
	IsAdmin          bool       `json:"is_admin"`
	CreatedAt        time.Time  `json:"created_at"`
	UpdatedAt        time.Time  `json:"updated_at"`
}

func (u *User) HasPlan(plans ...string) bool {
	for _, p := range plans {
		if u.Plan == p {
			return true
		}
	}
	return false
}

// UserFull includes the password hash for internal auth use only.
type UserFull struct {
	User
	PasswordHash string `json:"-"`
}

type Lab struct {
	ID         int        `json:"id"`
	Slug       string     `json:"slug"`
	Title      string     `json:"title"`
	Topic      string     `json:"topic"`
	Difficulty string     `json:"difficulty"`
	IsFree     bool       `json:"is_free"`
	SortOrder  int        `json:"sort_order"`
	ShortDesc  string     `json:"short_desc"`
	BookRef    string     `json:"book_ref,omitempty"`
	HasLiveSession bool      `json:"has_live_session"`
	Phases     []LabPhase `json:"phases,omitempty"`
}

type LabPhase struct {
	ID        uuid.UUID `json:"id"`
	LabID     int       `json:"lab_id"`
	Phase     string    `json:"phase"`
	Title     string    `json:"title"`
	Content   string    `json:"content"`
	IsProOnly bool      `json:"is_pro_only"`
}

type LabTopology struct {
	LabID    int             `json:"lab_id"`
	SVGSmall string          `json:"svg_small"`
	SVGLarge string          `json:"svg_large"`
	Legend   json.RawMessage `json:"legend"`
}

type UserProgress struct {
	ID          uuid.UUID `json:"id"`
	UserID      uuid.UUID `json:"user_id"`
	LabID       int       `json:"lab_id"`
	Phase       string    `json:"phase"`
	CompletedAt time.Time `json:"completed_at"`
}

// ProgressSummary is returned from GET /api/v1/progress
type ProgressSummary struct {
	TotalPhases     int                   `json:"total_phases"` // always 42 (14 labs * 3 phases)
	CompletedPhases int                   `json:"completed_phases"`
	ReadinessPct    int                   `json:"readiness_pct"`
	ByTopic         map[string]TopicStats `json:"by_topic"`
	Items           []UserProgress        `json:"items"`
}

type TopicStats struct {
	Total     int `json:"total"`
	Completed int `json:"completed"`
}

type Certificate struct {
	ID         uuid.UUID `json:"id"`
	UserID     uuid.UUID `json:"user_id"`
	IssuedAt   time.Time `json:"issued_at"`
	VerifyCode string    `json:"verify_code"`
}

type TeamMemberProgress struct {
	UserID          uuid.UUID `json:"user_id"`
	Email           string    `json:"email"`
	Name            string    `json:"name"`
	CompletedPhases int       `json:"completed_phases"`
	TotalPhases     int       `json:"total_phases"`
}

type Team struct {
	ID        uuid.UUID    `json:"id"`
	Name      string       `json:"name"`
	OwnerID   uuid.UUID    `json:"owner_id"`
	SeatCount int          `json:"seat_count"`
	CreatedAt time.Time    `json:"created_at"`
	Members   []TeamMember `json:"members,omitempty"`
}

type TeamMember struct {
	TeamID   uuid.UUID `json:"team_id"`
	UserID   uuid.UUID `json:"user_id"`
	Role     string    `json:"role"`
	JoinedAt time.Time `json:"joined_at"`
	User     *User     `json:"user,omitempty"`
}
