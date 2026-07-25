package labs

import (
	"context"
	"errors"
	"fmt"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"netbreaker.io/api/pkg/types"
)

var ErrNotFound = errors.New("lab not found")

type Repository struct {
	pool *pgxpool.Pool
}

func NewRepository(pool *pgxpool.Pool) *Repository {
	return &Repository{pool: pool}
}

func (r *Repository) List(ctx context.Context, topic, difficulty string) ([]types.Lab, error) {
	query := `SELECT id, slug, title, topic, difficulty, is_free, sort_order, COALESCE(short_desc, ''), COALESCE(book_ref, '')
	          FROM labs WHERE ($1 = '' OR topic = $1) AND ($2 = '' OR difficulty = $2)
	          ORDER BY sort_order`
	rows, err := r.pool.Query(ctx, query, topic, difficulty)
	if err != nil {
		return nil, fmt.Errorf("list labs: %w", err)
	}
	defer rows.Close()

	var labs []types.Lab
	for rows.Next() {
		var l types.Lab
		if err := rows.Scan(&l.ID, &l.Slug, &l.Title, &l.Topic,
			&l.Difficulty, &l.IsFree, &l.SortOrder, &l.ShortDesc, &l.BookRef); err != nil {
			return nil, err
		}
		labs = append(labs, l)
	}
	return labs, rows.Err()
}

func (r *Repository) GetByID(ctx context.Context, id int) (*types.Lab, error) {
	var l types.Lab
	err := r.pool.QueryRow(ctx,
		`SELECT id, slug, title, topic, difficulty, is_free, sort_order, COALESCE(short_desc, ''), COALESCE(book_ref, '')
		 FROM labs WHERE id = $1`, id,
	).Scan(&l.ID, &l.Slug, &l.Title, &l.Topic, &l.Difficulty, &l.IsFree, &l.SortOrder, &l.ShortDesc, &l.BookRef)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("GetByID: %w", err)
	}
	return &l, nil
}

func (r *Repository) GetPhases(ctx context.Context, labID int) ([]types.LabPhase, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id, lab_id, phase, title, content, is_pro_only FROM lab_phases
		 WHERE lab_id = $1 ORDER BY CASE phase WHEN 'build' THEN 1 WHEN 'attack' THEN 2 WHEN 'harden' THEN 3 END`,
		labID)
	if err != nil {
		return nil, fmt.Errorf("get phases: %w", err)
	}
	defer rows.Close()

	var phases []types.LabPhase
	for rows.Next() {
		var p types.LabPhase
		if err := rows.Scan(&p.ID, &p.LabID, &p.Phase, &p.Title, &p.Content, &p.IsProOnly); err != nil {
			return nil, err
		}
		phases = append(phases, p)
	}
	return phases, rows.Err()
}

func (r *Repository) GetTopology(ctx context.Context, labID int) (*types.LabTopology, error) {
	var t types.LabTopology
	err := r.pool.QueryRow(ctx,
		`SELECT lab_id, svg_small, svg_large, COALESCE(legend::text, '[]')
		 FROM lab_topologies WHERE lab_id = $1`, labID,
	).Scan(&t.LabID, &t.SVGSmall, &t.SVGLarge, &t.Legend)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("GetTopology: %w", err)
	}
	return &t, nil
}

func (r *Repository) GetConfigKey(ctx context.Context, labID int) (string, string, error) {
	var storageKey, filename string
	err := r.pool.QueryRow(ctx,
		`SELECT storage_key, filename FROM lab_configs WHERE lab_id = $1`, labID,
	).Scan(&storageKey, &filename)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return "", "", ErrNotFound
		}
		return "", "", fmt.Errorf("GetConfigKey: %w", err)
	}
	return storageKey, filename, nil
}
