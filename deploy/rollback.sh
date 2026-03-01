#!/bin/bash
# Rollback: Deploy specific version to VPS

set -e

if [ -z "$1" ]; then
    echo "Usage: ./rollback.sh <version>"
    echo "Example: ./rollback.sh 0.1.3"
    exit 1
fi

VERSION="$1"

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

# Defaults
VPS_HOSTNAME="${VPS_HOSTNAME:-jdc}"
GATEWAY_PORT="${GATEWAY_PORT:-18790}"
ALIYUN_NAMESPACE="${ALIYUN_NAMESPACE:-your-namespace}"
REGION="${REGION:-cn-hangzhou}"

REGISTRY="registry.${REGION}.aliyuncs.com"
IMAGE="${REGISTRY}/${ALIYUN_NAMESPACE}/pawpsicle:${VERSION}"

echo "=== Rollback to ${VERSION} ==="
echo "VPS: ${VPS_HOSTNAME}"
echo "Image: ${IMAGE}"
echo ""

# Deploy
ssh "${VPS_HOSTNAME}" bash << EOF
set -e

echo "[1/4] Pulling image..."
docker pull ${IMAGE}

echo "[2/4] Stopping old container..."
docker stop pawpsicle-gateway 2>/dev/null || true
docker rm pawpsicle-gateway 2>/dev/null || true

echo "[3/4] Starting new container..."
docker run -d \\
  --name pawpsicle-gateway \\
  --restart unless-stopped \\
  -p ${GATEWAY_PORT}:${GATEWAY_PORT} \\
  -v /root/.pawpsicle:/root/.pawpsicle \\
  --dns 172.17.0.1 \\
  --memory 512m \\
  --cpus 0.5 \\
  ${IMAGE} gateway

echo "[4/4] Verifying..."
sleep 5
docker ps --filter name=pawpsicle-gateway --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "✅ Rolled back to ${VERSION}!"
EOF

echo ""
echo "Useful commands:"
echo "  ssh ${VPS_HOSTNAME} 'docker logs -f pawpsicle-gateway'"
echo "  ssh ${VPS_HOSTNAME} 'docker stats pawpsicle-gateway'"
