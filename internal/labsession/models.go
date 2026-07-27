package labsession

import (
	"time"

	"github.com/google/uuid"
)

type Status string

const (
	StatusProvisioning Status = "provisioning"
	StatusRunning      Status = "running"
	StatusIdleStopped  Status = "idle_stopped"
	StatusEnded        Status = "ended"
	StatusFailed       Status = "failed"
)

type NodeInfo struct {
	GNS3NodeID  string `json:"gns3_node_id"`
	ConsolePort int    `json:"console_port"`
	ConsoleType string `json:"console_type,omitempty"` // "telnet", "vnc", "none"
	NodeType    string `json:"node_type,omitempty"`    // "iou", "dynamips", "qemu", "docker", "vpcs"
	MAC         string `json:"mac,omitempty"`          // host MAC resolved once at provisioning via PopulateNodeMACs; empty for switches/routers.
	// IMPORTANT: MACs are captured exactly once (provision → PopulateNodeMACs → node_map JSONB)
	// and are valid for the session's entire lifetime because NO code path recreates
	// containers or nodes within an existing session (see service.go Launch/resume,
	// reaper.go suspend/teardown/DeleteProject — restart reuses, delete destroys).
	// If a node-recreate path is ever added (e.g. per-node restart, error-recovery
	// that re-provisions), MACs MUST be re-resolved before the verify engine reads
	// them, or verify results will be silently stale.
}

// NodeMap keys are the same node names used in the lab's topology template,
// e.g. "SW1", "SW2", "R1", "Kali".
type NodeMap map[string]NodeInfo

type Session struct {
	ID            uuid.UUID  `json:"id"`
	UserID        uuid.UUID  `json:"user_id"`
	LabID         int        `json:"lab_id"`
	ComputeID     string     `json:"compute_id"`
	GNS3ProjectID *string    `json:"gns3_project_id,omitempty"`
	Status        Status     `json:"status"`
	NodeMap       NodeMap    `json:"node_map"`
	StartedAt     time.Time  `json:"started_at"`
	LastActiveAt  time.Time  `json:"last_active_at"`
	EndedAt       *time.Time `json:"ended_at,omitempty"`
}
