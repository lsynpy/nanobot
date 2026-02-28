#!/bin/bash
# Release: Auto-increment version, build & push

set -e

# Parse arguments
INCREMENT="${1:-patch}"  # patch, minor, or major

# Load .env
if [ -f "../.env" ]; then
    set -a
    source ../.env
    set +a
elif [ -f ".env" ]; then
    set -a
    source .env
    set +a
fi

# Load defaults
PLATFORM="${PLATFORM:-linux/arm64,linux/amd64}"
ALIYUN_NAMESPACE="${ALIYUN_NAMESPACE:-your-namespace}"
REGION="${REGION:-cn-hangzhou}"

# Get current version from VERSION file
VERSION_FILE="../VERSION"
CURRENT=$(cat "${VERSION_FILE}" 2>/dev/null || echo "0.1.0")

# Parse and increment
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$INCREMENT" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch|*)
        PATCH=$((PATCH + 1))
        ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"

# Update VERSION file
echo "${NEW_VERSION}" > "${VERSION_FILE}"

REGISTRY="registry.${REGION}.aliyuncs.com"

echo "=== Release ==="
echo "Version: ${CURRENT} → ${NEW_VERSION} (${INCREMENT})"
echo "Registry: ${REGISTRY}/${ALIYUN_NAMESPACE}"
echo "Platform: ${PLATFORM}"
echo ""

# Build and push
docker buildx build \
  --platform "${PLATFORM}" \
  -f Dockerfile \
  -t "${REGISTRY}/${ALIYUN_NAMESPACE}/nanobot:${NEW_VERSION}" \
  -t "${REGISTRY}/${ALIYUN_NAMESPACE}/nanobot:latest" \
  --push \
  .

echo ""
echo "✅ Release ${NEW_VERSION} complete"
echo ""
echo "Deploy with:"
echo "  ./deploy/deploy-to-vps.sh"
