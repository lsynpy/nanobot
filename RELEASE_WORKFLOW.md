# nanobot Release Workflow

## Release

```bash
# 1. Test
pytest
ruff check .

# 2. Release (auto-increments VERSION)
./deploy/release.sh        # Patch: 0.1.4 → 0.1.5
./deploy/release.sh minor  # Minor: 0.1.4 → 0.2.0
./deploy/release.sh major  # Major: 0.1.4 → 1.0.0

# 3. Commit & tag
git add VERSION
git commit -m "Release v$(cat VERSION)"
git push
git tag -a "v$(cat VERSION)" -m "Release v$(cat VERSION)"
git push origin "v$(cat VERSION)"

# 4. Deploy
./deploy/deploy-to-vps.sh
./deploy/verify.sh
```

## Rollback

```bash
./deploy/rollback.sh 0.1.4    # Deploy existing version from registry
```
