package labs

import (
	"context"
	"errors"
	"time"

	"netbreaker.io/api/internal/labsession"
	"netbreaker.io/api/pkg/storage"
	"netbreaker.io/api/pkg/types"
)

type Service struct {
	repo    *Repository
	storage *storage.Client
}

func NewService(repo *Repository, storage *storage.Client) *Service {
	return &Service{repo: repo, storage: storage}
}

// GetLabForUser returns a lab with phases filtered by the user's plan.
// Free users only see the "build" phase of pro labs, with content hidden.
func (s *Service) GetLabForUser(ctx context.Context, labID int, isPro bool) (*types.Lab, error) {
	lab, err := s.repo.GetByID(ctx, labID)
	if err != nil {
		return nil, err
	}

	phases, err := s.repo.GetPhases(ctx, labID)
	if err != nil {
		return nil, err
	}

	// Free users: for pro labs, show only the build phase shell (no content)
	if !isPro && !lab.IsFree {
		filtered := make([]types.LabPhase, 0, 1)
		for _, p := range phases {
			if p.Phase == types.PhaseBuild {
				p.Content = "" // strip content — paywall applies
				filtered = append(filtered, p)
			}
		}
		phases = filtered
	}

	lab.HasLiveSession = labsession.HasLiveSession(labID)
	lab.Phases = phases
	return lab, nil
}

// GetPresignedURL returns a 1-hour presigned download URL for the lab's GNS3 config file.
func (s *Service) GetPresignedURL(ctx context.Context, labID int) (string, error) {
	key, _, err := s.repo.GetConfigKey(ctx, labID)
	if err != nil {
		if errors.Is(err, ErrNotFound) {
			return "", ErrNotFound
		}
		return "", err
	}

	url, err := s.storage.PresignedDownloadURL(ctx, key, time.Hour)
	if err != nil {
		return "", err
	}
	return url, nil
}
