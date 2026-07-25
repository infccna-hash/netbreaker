package config

import (
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/joho/godotenv"
)

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
		GNS3MaxSessions: getIntEnv("GNS3_MAX_SESSIONS", 8),
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
