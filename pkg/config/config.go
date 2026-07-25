package config

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"time"

	"github.com/joho/godotenv"
)

// gns3RecommendedMaxSessions is a conservative ceiling for a single modest
// compute host (e.g. a 2-core / ~8GB laptop-class GNS3 server). Each live lab
// session runs several emulated nodes (Kali QEMU + IOU + Dynamips), so a cap
// much above this will exhaust RAM/CPU and trigger the reaper death-spiral
// (stops time out, nodes leak, orphans accumulate). Raise the env var only if
// the GNS3 host is genuinely larger.
const gns3RecommendedMaxSessions = 4

type Config struct {
	Port        string
	Env         string
	FrontendURL string

	DatabaseURL string

	JWTPrivateKeyPath string
	JWTPublicKeyPath  string
	JWTAccessTTL      time.Duration
	JWTRefreshTTL     time.Duration

	StripeSecretKey       string
	StripeWebhookSecret   string
	StripeProPriceID      string
	StripeBootcampPriceID string

	StorageEndpoint  string
	StorageAccessKey string
	StorageSecretKey string
	StorageBucket    string
	StorageUseSSL    bool

	ResendAPIKey string
	EmailFrom    string

	GNS3ServerURL   string
	GNS3ComputeHost string // host for raw telnet console (defaults to same host as ServerURL)
	GNS3Username    string
	GNS3Password    string
	GNS3MaxSessions int

	// Reaper sweeps stale lab sessions off the GNS3 compute box.
	GNS3IdleTimeout  time.Duration // running session idle → suspend
	GNS3SessionTTL   time.Duration // idle_stopped → full teardown
	GNS3ReaperTick   time.Duration // how often the reaper goroutine polls
	GNS3OpTimeout    time.Duration // per-call deadline for each GNS3 REST op in a sweep
}

func Load() (*Config, error) {
	_ = godotenv.Load()

	cfg := &Config{
		Port:        getEnv("PORT", "8080"),
		Env:         getEnv("ENV", "development"),
		FrontendURL: getEnv("FRONTEND_URL", "http://localhost:5173"),

		DatabaseURL: mustGetEnv("DATABASE_URL"),

		JWTPrivateKeyPath: getEnv("JWT_PRIVATE_KEY_PATH", "./keys/private.pem"),
		JWTPublicKeyPath:  getEnv("JWT_PUBLIC_KEY_PATH", "./keys/public.pem"),

		StripeSecretKey:       mustGetEnv("STRIPE_SECRET_KEY"),
		StripeWebhookSecret:   mustGetEnv("STRIPE_WEBHOOK_SECRET"),
		StripeProPriceID:      mustGetEnv("STRIPE_PRO_PRICE_ID"),
		StripeBootcampPriceID: mustGetEnv("STRIPE_BOOTCAMP_PRICE_ID"),

		StorageEndpoint:  getEnv("STORAGE_ENDPOINT", "minio:9000"),
		StorageAccessKey: mustGetEnv("STORAGE_ACCESS_KEY"),
		StorageSecretKey: mustGetEnv("STORAGE_SECRET_KEY"),
		StorageBucket:    getEnv("STORAGE_BUCKET", "netbreaker-configs"),
		StorageUseSSL:    getBoolEnv("STORAGE_USE_SSL", false),

		ResendAPIKey: mustGetEnv("RESEND_API_KEY"),
		EmailFrom:    getEnv("EMAIL_FROM", "noreply@netbreaker.io"),

		GNS3ServerURL:    getEnv("GNS3_SERVER_URL", "http://gns3:3080"),
		GNS3ComputeHost:  getEnv("GNS3_COMPUTE_HOST", ""),
		GNS3Username:     getEnv("GNS3_USERNAME", ""),
		GNS3Password:    getEnv("GNS3_PASSWORD", ""),
		GNS3MaxSessions: getIntEnv("GNS3_MAX_SESSIONS", 3),
	}

	var err error
	cfg.JWTAccessTTL, err = parseDuration("JWT_ACCESS_TTL", "15m")
	if err != nil {
		return nil, err
	}
	cfg.JWTRefreshTTL, err = parseDuration("JWT_REFRESH_TTL", "720h")
	if err != nil {
		return nil, err
	}

	cfg.GNS3IdleTimeout, err = parseDuration("GNS3_IDLE_TIMEOUT", "15m")
	if err != nil {
		return nil, err
	}
	cfg.GNS3SessionTTL, err = parseDuration("GNS3_SESSION_TTL", "1h")
	if err != nil {
		return nil, err
	}
	cfg.GNS3ReaperTick, err = parseDuration("GNS3_REAPER_TICK", "30s")
	if err != nil {
		return nil, err
	}
	// Per-operation deadline for each GNS3 REST call the reaper makes. Must be
	// shorter than the tick so one starved/unresponsive GNS3 call cannot stall
	// the whole sweep (the underlying HTTP client's own timeout is 30s, which
	// serializes badly when several sessions are stuck at once).
	cfg.GNS3OpTimeout, err = parseDuration("GNS3_OP_TIMEOUT", "20s")
	if err != nil {
		return nil, err
	}

	if cfg.GNS3MaxSessions > gns3RecommendedMaxSessions {
		log.Printf("WARNING: GNS3_MAX_SESSIONS=%d exceeds the recommended ceiling of %d "+
			"for a single modest GNS3 host. Each session runs multiple emulated nodes; "+
			"an over-provisioned cap is the primary cause of RAM exhaustion, reaper stop "+
			"timeouts, and orphaned-project pileup. Lower it unless the GNS3 host is large.",
			cfg.GNS3MaxSessions, gns3RecommendedMaxSessions)
	}

	return cfg, nil
}

func (c *Config) IsProd() bool { return c.Env == "production" }

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func mustGetEnv(key string) string {
	v := os.Getenv(key)
	if v == "" {
		panic(fmt.Sprintf("required env var %s not set", key))
	}
	return v
}

func getIntEnv(key string, fallback int) int {
	v := os.Getenv(key)
	if v == "" {
		return fallback
	}
	n, err := strconv.Atoi(v)
	if err != nil {
		return fallback
	}
	return n
}

func getBoolEnv(key string, fallback bool) bool {
	v := os.Getenv(key)
	if v == "" {
		return fallback
	}
	b, err := strconv.ParseBool(v)
	if err != nil {
		return fallback
	}
	return b
}

func parseDuration(key, fallback string) (time.Duration, error) {
	v := getEnv(key, fallback)
	d, err := time.ParseDuration(v)
	if err != nil {
		return 0, fmt.Errorf("invalid duration for %s: %w", key, err)
	}
	return d, nil
}
