#!/bin/bash
# Deploy: Deploy latest version (:ultra tag) to VPS

set -e

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
IMAGE="${REGISTRY}/${ALIYUN_NAMESPACE}/nanobot:latest"

echo "=== Deploy Latest ==="
echo "VPS: ${VPS_HOSTNAME}"
echo "Image: ${IMAGE}"
echo ""

# Deploy
ssh "${VPS_HOSTNAME}" bash << EOF
set -e

echo "[1/4] Pulling image..."
docker pull ${IMAGE}

echo "[2/4] Stopping old container..."
docker stop nanobot-gateway 2>/dev/null || true
docker rm nanobot-gateway 2>/dev/null || true

echo "[3/4] Starting new container..."
docker run -d \\
  --name nanobot-gateway \\
  --restart unless-stopped \\
  -p ${GATEWAY_PORT}:${GATEWAY_PORT} \\
  -v /root/.nanobot:/root/.nanobot \\
  --dns 172.17.0.1 \\
  --memory 512m \\
  --cpus 0.5 \\
  ${IMAGE} gateway

echo "[4/4] Verifying..."
sleep 5
docker ps --filter name=nanobot-gateway --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "✅ Deployed!"
EOF

echo ""
echo "Useful commands:"
echo "  ssh ${VPS_HOSTNAME} 'docker logs -f nanobot-gateway'"
echo "  ssh ${VPS_HOSTNAME} 'docker stats nanobot-gateway'"
