#!/bin/bash
# Uninstall pawpsicle from VPS

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

VPS_HOSTNAME="${VPS_HOSTNAME:-jdc}"

echo "=== Uninstall from ${VPS_HOSTNAME} ==="
echo ""

ssh "${VPS_HOSTNAME}" bash << 'EOF'
docker stop pawpsicle-gateway 2>/dev/null || true
docker rm pawpsicle-gateway 2>/dev/null || true
echo "✅ Container removed"
echo "Config preserved at: /root/.pawpsicle"
EOF
