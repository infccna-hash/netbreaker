#!/usr/bin/env bash
# Build NetBreaker Kali image with provenance
# Usage: ./build.sh
# Output: immutable dated tag + expected-ID written atomically + latest updated
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME="netbreaker-kali"
DATE_TAG="$(date +%Y-%m-%d)"
EXPECTED_ID_FILE="${SCRIPT_DIR}/expected-id.txt"

echo "=== Building ${IMAGE_NAME} ==="

# Build the image
docker build -t "${IMAGE_NAME}:${DATE_TAG}" "${SCRIPT_DIR}"

# Get the full image ID (sha256:...)
FULL_ID=$(docker image inspect "${IMAGE_NAME}:${DATE_TAG}" --format '{{.Id}}')
SHORT_SHA="${FULL_ID:7:12}"  # strip "sha256:" prefix, keep first 12 chars

# Tag with immutable provenance tag: YYYY-MM-DD-shortsha
IMMUTABLE_TAG="${IMAGE_NAME}:${DATE_TAG}-${SHORT_SHA}"
docker tag "${IMAGE_NAME}:${DATE_TAG}" "${IMMUTABLE_TAG}"

# Atomic expected-ID write: write to temp file, then rename
# This means the check never reads a half-written file
EXPECTED_CONTENT="${FULL_ID}
${IMMUTABLE_TAG}
${DATE_TAG}"
echo "${EXPECTED_CONTENT}" > "${EXPECTED_ID_FILE}.tmp"
mv "${EXPECTED_ID_FILE}.tmp" "${EXPECTED_ID_FILE}"

# Update latest to point to the new build (only after expected-ID is written)
docker tag "${IMAGE_NAME}:${DATE_TAG}" "${IMAGE_NAME}:latest"

echo ""
echo "=== Build complete ==="
echo "  Canonical ID:   ${FULL_ID}"
echo "  Immutable tag:  ${IMMUTABLE_TAG}"
echo "  Dated tag:      ${IMAGE_NAME}:${DATE_TAG}"
echo "  Latest updated: yes"
echo "  Expected-ID:    written to ${EXPECTED_ID_FILE}"
echo ""
echo "Provenance record:"
cat "${EXPECTED_ID_FILE}"
