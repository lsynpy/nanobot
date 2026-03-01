#!/bin/bash
# Verify pawpsicle deployment on VPS

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

echo "=== Verify on ${VPS_HOSTNAME} ==="
echo ""

echo "[1/3] Container status..."
ssh "${VPS_HOSTNAME}" "docker ps | grep pawpsicle" || echo "❌ Not running"

echo ""
echo "[2/3] Resource usage..."
ssh "${VPS_HOSTNAME}" "docker stats pawpsicle-gateway --no-stream" || echo "❌ Not available"

echo ""
echo "[3/3] Agent test..."
ssh "${VPS_HOSTNAME}" "docker exec -i pawpsicle-gateway pawpsicle agent -m 'hi'" || echo "❌ Agent not responding"

echo ""
echo "✅ Verification complete"
