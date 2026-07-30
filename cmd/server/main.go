package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/pgx/v5"
	_ "github.com/golang-migrate/migrate/v4/source/file"

	"netbreaker.io/api/internal/admin"
	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/internal/certificate"
	"netbreaker.io/api/internal/labs"
	"netbreaker.io/api/internal/labsession"
	"netbreaker.io/api/internal/progress"
	"netbreaker.io/api/internal/subscription"
	"netbreaker.io/api/internal/team"
	"netbreaker.io/api/internal/users"
	"netbreaker.io/api/internal/verification"
	"netbreaker.io/api/internal/verify"
	"netbreaker.io/api/pkg/config"
	"netbreaker.io/api/pkg/db"
	"netbreaker.io/api/pkg/email"
	jwtutil "netbreaker.io/api/pkg/jwt"
	"netbreaker.io/api/pkg/ratelimit"
	"netbreaker.io/api/pkg/storage"
)

func main() {
	// ── Config ────────────────────────────────────────────────────────────
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("load config: %v", err)
	}

	// ── Database ──────────────────────────────────────────────────────────
	ctx := context.Background()
	pool, err := db.Connect(ctx, cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("connect database: %v", err)
	}
	defer pool.Close()
	log.Println("database connected")

	// ── Migrations ────────────────────────────────────────────────────────
	migrateURL := cfg.DatabaseURL
	if strings.HasPrefix(migrateURL, "postgres://") {
		migrateURL = "pgx5://" + strings.TrimPrefix(migrateURL, "postgres://")
	} else if strings.HasPrefix(migrateURL, "postgresql://") {
		migrateURL = "pgx5://" + strings.TrimPrefix(migrateURL, "postgresql://")
	}
	m, err := migrate.New("file://migrations", migrateURL)
	if err != nil {
		log.Fatalf("init migrations: %v", err)
	}
	if err := m.Up(); err != nil && err != migrate.ErrNoChange {
		log.Fatalf("run migrations: %v", err)
	}
	log.Println("migrations applied")

	// ── JWT ───────────────────────────────────────────────────────────────
	keys, err := jwtutil.LoadKeyPair(cfg.JWTPrivateKeyPath, cfg.JWTPublicKeyPath)
	if err != nil {
		log.Fatalf("load JWT keys: %v", err)
	}

	// ── External services ─────────────────────────────────────────────────
	storageClient, err := storage.New(cfg.StorageEndpoint, cfg.StorageAccessKey, cfg.StorageSecretKey, cfg.StorageBucket, cfg.StorageUseSSL)
	if err != nil {
		log.Fatalf("init storage: %v", err)
	}
	emailClient := email.New(cfg.ResendAPIKey, cfg.EmailFrom)
	limiter := ratelimit.New(100)

	// ── Repositories & services ───────────────────────────────────────────
	userRepo := users.NewRepository(pool)
	labRepo := labs.NewRepository(pool)
	progressRepo := progress.NewRepository(pool)
	teamRepo := team.NewRepository(pool)

	authSvc := auth.NewService(pool, keys, cfg.JWTAccessTTL, cfg.JWTRefreshTTL)
	labSvc := labs.NewService(labRepo, storageClient)
	subSvc := subscription.NewService(cfg, pool, userRepo)
	certSvc := certificate.NewService(pool, progressRepo, emailClient)

	// ── Handlers ──────────────────────────────────────────────────────────
	authHandler := auth.NewHandler(authSvc, emailClient, cfg.JWTRefreshTTL, cfg.IsProd())
	userHandler := users.NewHandler(userRepo)
	labHandler := labs.NewHandler(labSvc, labRepo)
	progHandler := progress.NewHandler(progressRepo)
	subHandler := subscription.NewHandler(subSvc)
	certHandler := certificate.NewHandler(certSvc, userRepo)
	teamHandler := team.NewHandler(teamRepo, userRepo, emailClient)
	adminHandler := admin.NewHandler(pool, userRepo)

	// ── Lab Sessions (live GNS3 orchestration) ────────────────────────────
	sessionRepo := labsession.NewRepository(pool)
	var gns3Client labsession.GNS3Client
	if cfg.GNS3ServerURL != "" {
		gns3Client = labsession.NewHTTPGNS3Client(cfg.GNS3ServerURL, cfg.GNS3Username, cfg.GNS3Password, cfg.KaliPinnedTag)
	} else {
		gns3Client = nil
	}
	// Derive telnet host from config; fall back to localhost since
	// GNS3 runs on the same machine in development.
	computeHost := cfg.GNS3ComputeHost
	if computeHost == "" {
		computeHost = "localhost"
	}
	sessionSvc := labsession.NewService(sessionRepo, gns3Client, cfg.GNS3MaxSessions, "local", computeHost)
	sessionHandler := labsession.NewHandler(sessionSvc)

	// ── Console-truth verifier registry ──────────────────────────────────
	verifyReg := verify.NewVerifierRegistry()
	labsession.RegisterLab1Verifiers(verifyReg)
	labsession.RegisterLab8Verifiers(verifyReg)
	labsession.RegisterLab15Verifiers(verifyReg)
	labsession.RegisterLab16Verifiers(verifyReg)

	// ── Verification handler (supports both legacy + console-truth) ─────
	verifyHandler := verification.NewHandler(progressRepo, sessionRepo, sessionSvc, verifyReg, cfg)

	// ── Reaper: reclaim stale GNS3 sessions ───────────────────────────
	if gns3Client != nil {
		reaper := labsession.NewReaper(sessionRepo, gns3Client,
			cfg.GNS3IdleTimeout, cfg.GNS3SessionTTL, cfg.GNS3ReaperTick, cfg.GNS3OpTimeout)
		reaper.Start(context.Background())
	}

	// ── Router ────────────────────────────────────────────────────────────
	r := chi.NewRouter()

	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.Timeout(30 * time.Second))
	r.Use(limiter.Middleware)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{cfg.FrontendURL},
		AllowedMethods:   []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		AllowCredentials: true,
	}))

	r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(`{"status":"ok"}`))
	})

	r.Route("/api/v1", func(r chi.Router) {
		r.Post("/auth/register", authHandler.Register)
		r.Post("/auth/login", authHandler.Login)
		r.Post("/auth/refresh", authHandler.Refresh)
		r.Post("/webhooks/stripe", subHandler.StripeWebhook)

		// Public, but read the token if present so pro users get full lab content.
		r.Group(func(r chi.Router) {
			r.Use(auth.OptionalJWTMiddleware(keys))
			r.Get("/labs", labHandler.List)
			r.Get("/labs/{id}", labHandler.Get)
			r.Get("/labs/{id}/topology", labHandler.GetTopology)
		})
		r.Get("/certificate/verify/{code}", certHandler.Verify)

		r.Group(func(r chi.Router) {
			r.Use(auth.JWTMiddleware(keys))

			r.Post("/auth/logout", authHandler.Logout)
			r.Get("/me", userHandler.Get)
			r.Patch("/me", userHandler.Update)
			r.Delete("/me", userHandler.Delete)

			r.Get("/progress", progHandler.Get)
			r.Post("/labs/{id}/verify", verifyHandler.Verify)
			r.Put("/progress/{labID}/{phase}", progHandler.Mark)
			r.Delete("/progress/{labID}/{phase}", progHandler.Unmark)

			r.Get("/subscription", subHandler.Get)
			r.Post("/subscription/checkout", subHandler.Checkout)

			// Lab Sessions — requires pro or bootcamp
			r.Group(func(r chi.Router) {
				r.Use(auth.RequirePlan("pro", "bootcamp"))
				r.Get("/labs/{id}/config", labHandler.GetConfig)
				r.Get("/certificate", certHandler.Get)
				r.Post("/subscription/portal", subHandler.Portal)
				sessionHandler.Routes(r)
			})

			r.Group(func(r chi.Router) {
				r.Use(auth.RequirePlan("bootcamp"))
				r.Get("/team", teamHandler.Get)
				r.Post("/team/invite", teamHandler.Invite)
				r.Delete("/team/members/{userID}", teamHandler.RemoveMember)
				r.Get("/team/progress", teamHandler.Progress)
			})

			r.Group(func(r chi.Router) {
				r.Use(auth.RequireAdmin())
				r.Get("/admin/stats", adminHandler.Stats)
				r.Get("/admin/users", adminHandler.Users)
				r.Patch("/admin/users/{id}/plan", adminHandler.SetPlan)
			})
		})
	})

	// ── Server + graceful shutdown ────────────────────────────────────────
	addr := fmt.Sprintf(":%s", cfg.Port)
	log.Printf("NetBreaker API starting on %s (env=%s)", addr, cfg.Env)

	srv := &http.Server{
		Addr:         addr,
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 30 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// Start server in goroutine so we can listen for shutdown signals
	serverErr := make(chan error, 1)
	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			serverErr <- err
		}
	}()

	// Wait for SIGINT or SIGTERM
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

	select {
	case err := <-serverErr:
		log.Fatalf("server error: %v", err)
	case sig := <-quit:
		log.Printf("received signal %s — shutting down gracefully", sig)
	}

	// Give in-flight requests 30s to complete
	shutdownCtx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	if err := srv.Shutdown(shutdownCtx); err != nil {
		log.Printf("forced shutdown: %v", err)
	}
	log.Println("server stopped")
}
