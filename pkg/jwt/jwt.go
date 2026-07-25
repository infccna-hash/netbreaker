package jwtutil

import (
	"crypto/rsa"
	"errors"
	"fmt"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

var (
	ErrTokenInvalid = errors.New("token is invalid")
	ErrTokenExpired = errors.New("token is expired")
)

// Claims is the JWT payload stored in the access token.
type Claims struct {
	jwt.RegisteredClaims
	Plan    string `json:"plan"`
	IsAdmin bool   `json:"is_admin"`
}

// KeyPair holds the RSA keys loaded from disk.
type KeyPair struct {
	Private *rsa.PrivateKey
	Public  *rsa.PublicKey
}

// LoadKeyPair reads RSA PEM files from disk.
func LoadKeyPair(privatePath, publicPath string) (*KeyPair, error) {
	privBytes, err := os.ReadFile(privatePath)
	if err != nil {
		return nil, fmt.Errorf("read private key: %w", err)
	}
	privKey, err := jwt.ParseRSAPrivateKeyFromPEM(privBytes)
	if err != nil {
		return nil, fmt.Errorf("parse private key: %w", err)
	}

	pubBytes, err := os.ReadFile(publicPath)
	if err != nil {
		return nil, fmt.Errorf("read public key: %w", err)
	}
	pubKey, err := jwt.ParseRSAPublicKeyFromPEM(pubBytes)
	if err != nil {
		return nil, fmt.Errorf("parse public key: %w", err)
	}

	return &KeyPair{Private: privKey, Public: pubKey}, nil
}

// GenerateAccessToken signs a new RS256 JWT for the given user.
func (kp *KeyPair) GenerateAccessToken(userID uuid.UUID, plan string, isAdmin bool, ttl time.Duration) (string, error) {
	now := time.Now()
	claims := Claims{
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   userID.String(),
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(now.Add(ttl)),
		},
		Plan:    plan,
		IsAdmin: isAdmin,
	}

	token := jwt.NewWithClaims(jwt.SigningMethodRS256, claims)
	return token.SignedString(kp.Private)
}

// ParseAccessToken verifies the token and returns its claims.
func (kp *KeyPair) ParseAccessToken(tokenStr string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(tokenStr, &Claims{}, func(t *jwt.Token) (any, error) {
		if _, ok := t.Method.(*jwt.SigningMethodRSA); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
		}
		return kp.Public, nil
	})
	if err != nil {
		if errors.Is(err, jwt.ErrTokenExpired) {
			return nil, ErrTokenExpired
		}
		return nil, ErrTokenInvalid
	}

	claims, ok := token.Claims.(*Claims)
	if !ok || !token.Valid {
		return nil, ErrTokenInvalid
	}
	return claims, nil
}
