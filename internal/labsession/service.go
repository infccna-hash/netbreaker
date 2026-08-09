package labsession

import (
	"context"
	"errors"
	"log"

	"github.com/google/uuid"
)

var (
	ErrPlanGate      = errors.New("lab sessions require a Pro or Bootcamp plan")
	ErrSlotConflict  = errors.New("max concurrent sessions reached")
	ErrConceptualLab = errors.New("this lab is content-only and has no live session")
)

type Service struct {
	repo        *Repository
	gns3        GNS3Client
	maxSessions int
	computeID   string // which compute box new sessions land on; single-compute for now
	computeHost string // hostname/IP for raw telnet console (may differ from GNS3 API host)
	ConsoleLock *ConsoleLock
}

func NewService(repo *Repository, gns3 GNS3Client, maxSessions int, computeID, computeHost string) *Service {
	return &Service{repo: repo, gns3: gns3, maxSessions: maxSessions, computeID: computeID, computeHost: computeHost, ConsoleLock: NewConsoleLock()}
}

// Launch implements the resume-or-create path described in the spec.
func (s *Service) Launch(ctx context.Context, userID uuid.UUID, labID int, isPro bool) (*Session, error) {
	if !isPro {
		return nil, ErrPlanGate
	}

	// Content-only check: labs with zero template nodes have no live session.
	// Must come before resume path and session creation to avoid wasted DB rows.
	template := lookupTopologyTemplate(labID)
	if len(template.Nodes) == 0 {
		return nil, ErrConceptualLab
	}

	// Resume path: if there's an existing active session, restart nodes if idle and return it.
	if existing, err := s.repo.FindActiveForUserLab(ctx, userID, labID); err == nil {
		if existing.Status == StatusIdleStopped {
			if err := s.gns3.StartNodes(ctx, *existing.GNS3ProjectID); err != nil {
				return nil, err
			}
			if err := s.repo.SetStatus(ctx, existing.ID, StatusRunning); err != nil {
				return nil, err
			}
			// Touch last_active_at so the reaper doesn't immediately suspend
			// a just-resumed session whose last_active_at is still hours old.
			if err := s.repo.Touch(ctx, existing.ID); err != nil {
				log.Printf("labsession: touch after resume: %v", err)
			}
			existing.Status = StatusRunning
		}
		return existing, nil
	} else if !errors.Is(err, ErrNotFound) {
		return nil, err
	}

	// Concurrency cap check
	count, err := s.repo.ActiveCount(ctx)
	if err != nil {
		return nil, err
	}
	if count >= s.maxSessions {
		return nil, ErrSlotConflict
	}

	// Must come before creating the session row to avoid wasted DB rows.

	// Create provisioning row
	sess, err := s.repo.Create(ctx, userID, labID, s.computeID)
	if err != nil {
		return nil, err
	}

	go s.provision(sess.ID, labID)

	return sess, nil
}

func (s *Service) provision(sessionID uuid.UUID, labID int) {
	ctx := context.Background()

	// Pre-flight: confirm the pinned Kali image exists on the compute
	// node *before* creating any GNS3 resources. Fails closed with an
	// actionable message rather than a generic "image not found" mid-flow.
	if err := s.gns3.EnsureKaliImage(ctx, s.computeID); err != nil {
		log.Printf("labsession: kali image pre-flight failed: %v", err)
		_ = s.repo.SetStatus(ctx, sessionID, StatusFailed)
		return
	}

	projectID, err := s.gns3.CreateProject(ctx, s.computeID, 0, labID)
	if err != nil {
		log.Printf("labsession: create GNS3 project: %v", err)
		_ = s.repo.SetStatus(ctx, sessionID, StatusFailed)
		return
	}

	template := lookupTopologyTemplate(labID)
	nodes, err := s.gns3.ProvisionTopology(ctx, projectID, template)
	if err != nil {
		log.Printf("labsession: provision topology: %v", err)
		_ = s.repo.SetStatus(ctx, sessionID, StatusFailed)
		return
	}

	if err := s.gns3.StartNodes(ctx, projectID); err != nil {
		log.Printf("labsession: start nodes: %v", err)
		_ = s.repo.SetStatus(ctx, sessionID, StatusFailed)
		return
	}

	// Resolve host MACs AFTER StartNodes: docker/qemu MACs are static
	// GNS3 node properties (available regardless of run state), but
	// VPCS console listeners don't exist until the VPCS process starts.
	// All three strategies are safe to run post-boot.
	if err := s.gns3.PopulateNodeMACs(ctx, projectID, nodes); err != nil {
		log.Printf("labsession: populate MACs (non-fatal): %v", err)
	}

	if err := s.repo.SetProvisioned(ctx, sessionID, projectID, nodes); err != nil {
		log.Printf("labsession: set provisioned: %v", err)
	}
}

func (s *Service) Get(ctx context.Context, id uuid.UUID) (*Session, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *Service) Heartbeat(ctx context.Context, id uuid.UUID) error {
	return s.repo.Touch(ctx, id)
}

func (s *Service) EndLab(ctx context.Context, id uuid.UUID) error {
	sess, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return err
	}
	if sess.GNS3ProjectID != nil {
		if err := s.gns3.DeleteProject(ctx, *sess.GNS3ProjectID); err != nil {
			return err
		}
	}
	return s.repo.End(ctx, id)
}

// HasLiveSession reports whether the lab has a real topology template.
// Content-only labs (subnetting, theory) return false.
func HasLiveSession(labID int) bool {
	return len(lookupTopologyTemplate(labID).Nodes) > 0
}

// TopologyForLab returns the topology template for a lab ID, for tooling that
// needs read access to the registry (e.g. the topogen SVG generator).
func TopologyForLab(labID int) TopologyTemplate {
	return lookupTopologyTemplate(labID)
}

func lookupTopologyTemplate(labID int) TopologyTemplate {
	switch labID {
	case 1:
		return Lab01Topology
	case 2:
		return Lab02Topology
	case 3:
		return Lab03Topology
	case 4:
		return Lab04Topology
	case 5:
		return Lab05Topology
	case 6:
		return Lab06Topology
	case 7:
		return Lab07Topology
	case 8:
		return Lab08Topology
	case 9:
		return Lab09Topology
	case 10:
		return Lab10Topology
	case 11:
		return Lab11Topology
	case 12:
		return Lab12Topology
	case 13:
		return Lab13Topology
	case 14:
		return Lab14Topology
	case 15:
		return Lab15Topology
	case 16:
		return Lab16Topology
	case 17:
		return Lab17Topology
	case 18:
		return Lab18Topology
	case 19:
		return Lab19Topology
	case 20:
		return Lab20Topology
	case 21:
		return Lab21Topology
	case 24:
		return Lab24Topology
	case 25:
		return Lab25Topology
	case 26:
		return Lab26Topology
	case 27:
		return Lab27Topology
	case 28:
		return Lab28Topology
	case 29:
		return Lab29Topology
	case 31:
		return Lab31Topology
	case 32:
		return Lab32Topology
	case 33:
		return Lab33Topology
	case 34:
		return Lab34Topology
	case 35:
		return Lab35Topology
	case 36:
		return Lab36Topology
	case 37:
		return Lab37Topology
	case 38:
		return Lab38Topology
	case 39:
		return Lab39Topology
	case 43:
		return Lab43Topology
	case 44:
		return Lab44Topology
	case 45:
		return Lab45Topology
	case 46:
		return Lab46Topology
	case 47:
		return Lab47Topology
	default:
		return TopologyTemplate{LabID: labID, Nodes: []NodeTemplate{}}
	}
}

// EnsureProjectRunning reopens the session's GNS3 project and restarts
// its nodes if they were stopped (e.g. GNS3 auto-closed the project
// when console connections dropped). Console handlers call this before
// dialing a node port so a reconnect actually reconnects.
func (s *Service) EnsureProjectRunning(ctx context.Context, projectID string) error {
	if projectID == "" {
		return nil
	}
	return s.gns3.EnsureProjectRunning(ctx, projectID)
}

// derefStr safely dereferences a *string, returning "" for nil.
func derefStr(s *string) string {
	if s == nil {
		return ""
	}
	return *s
}
