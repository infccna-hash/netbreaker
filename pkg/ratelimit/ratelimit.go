package ratelimit

import (
	"net"
	"net/http"
	"sync"
	"time"
)

type bucket struct {
	tokens   float64
	lastSeen time.Time
	mu       sync.Mutex
}

type Limiter struct {
	mu       sync.Mutex
	buckets  map[string]*bucket
	rate     float64 // tokens per second
	capacity float64
}

// New creates a rate limiter. ratePerMinute is the max requests allowed per minute per IP.
func New(ratePerMinute int) *Limiter {
	l := &Limiter{
		buckets:  make(map[string]*bucket),
		rate:     float64(ratePerMinute) / 60.0,
		capacity: float64(ratePerMinute),
	}
	// Clean up old buckets every 5 minutes
	go func() {
		for range time.Tick(5 * time.Minute) {
			l.cleanup()
		}
	}()
	return l
}

func (l *Limiter) allow(ip string) bool {
	l.mu.Lock()
	b, ok := l.buckets[ip]
	if !ok {
		b = &bucket{tokens: l.capacity, lastSeen: time.Now()}
		l.buckets[ip] = b
	}
	l.mu.Unlock()

	b.mu.Lock()
	defer b.mu.Unlock()

	now := time.Now()
	elapsed := now.Sub(b.lastSeen).Seconds()
	b.tokens = min(l.capacity, b.tokens+elapsed*l.rate)
	b.lastSeen = now

	if b.tokens < 1 {
		return false
	}
	b.tokens--
	return true
}

func (l *Limiter) cleanup() {
	l.mu.Lock()
	defer l.mu.Unlock()
	cutoff := time.Now().Add(-10 * time.Minute)
	for ip, b := range l.buckets {
		if b.lastSeen.Before(cutoff) {
			delete(l.buckets, ip)
		}
	}
}

// Middleware returns an http.Handler middleware that rate limits by IP.
func (l *Limiter) Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// r.RemoteAddr is already the real client IP: chi's middleware.RealIP
		// runs ahead of this and rewrites it from trusted proxy headers.
		// Do NOT read X-Forwarded-For here — clients can spoof it to mint
		// unlimited buckets and bypass the limiter.
		ip := r.RemoteAddr
		if host, _, err := net.SplitHostPort(ip); err == nil {
			ip = host
		}
		if !l.allow(ip) {
			http.Error(w, `{"error":"too many requests"}`, http.StatusTooManyRequests)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func min(a, b float64) float64 {
	if a < b {
		return a
	}
	return b
}
