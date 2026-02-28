# nanobot Deployment to VPS

## Quick Start

### 1. Setup Aliyun Registry

See [ALIYUN_SETUP.md](ALIYUN_SETUP.md).

### 2. Configure `.env`

```bash
cp .env.example .env
vim .env
```

### 3. Commands

```bash
./deploy/release.sh              # Auto-increment patch version, build & push
./deploy/release.sh minor        # Minor version bump (0.1.4 → 0.2.0)
./deploy/release.sh major        # Major version bump (0.1.4 → 1.0.0)
./deploy/deploy-to-vps.sh        # Deploy latest
./deploy/verify.sh               # Check status & test agent
./deploy/rollback.sh 0.1.3       # Rollback to specific version
./deploy/uninstall-from-vps.sh   # Remove from VPS
```

**Version:** Stored in `VERSION` file at project root.

## Network Config

**DNS: `172.17.0.1`** (for OpenClash)

Already set in scripts. Don't change to `127.0.0.1`.
