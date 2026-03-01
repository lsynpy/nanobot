# Pawpsicle DEVELOPMENT Workflow

## Development Guide

### Setup Dev Env

```sh
# 1. setup venv (optional)

# 2. install from source
git clone https://github.com/lsynpy/pawpsicle.git
cd pawpsicle
make dev

# 3. onboard & config
pawpsicle onboard

# 4. run gateway
pawpsicle gateway &

# 5. run agent send a msg
pawpsicle agent -m "hi"
```

### Code Style

```bash
make lint
make format
```

## Testing Guide

## Releasing Guide

### Version Management

pawpsicle uses **Git tags** as the single source of truth for versioning via `hatch-vcs`.

**How it works:**

|                Component |                                            Role |
|-------------------------:|------------------------------------------------:|
| Git tag (e.g., `v0.1.5`) |                          Single source of truth |
|              `hatch-vcs` |  Reads tag at build time, sets package metadata |
|     `importlib.metadata` | Reads version from installed package at runtime |
|  `pawpsicle/__init__.py` |  Exposes `__version__` via `importlib.metadata` |

> **Note:** Do NOT edit `version` in `pyproject.toml` — Git tags control the version.

### Version Format

Follows [PEP 440](https://peps.python.org/pep-0440/):

```text
0.1.4          # Release
0.1.4.post2    # Post-release (packaging fixes)
0.1.5a1        # Alpha
0.1.5b1        # Beta
0.1.5rc1       # Release candidate
```

### Release Workflow

```bash
# 1. Create version tag
git tag v0.1.5
git push origin v0.1.5

# 2. Build (hatch-vcs reads tag, sets metadata)
hatch build
# or
uv build

# 3. Publish to PyPI
uv publish
# or
twine upload dist/*

# 4. Deploy
./deploy/deploy-to-vps.sh
./deploy/verify.sh
```

### Version Types

```bash
# Patch release (bug fixes)
git tag v0.1.5

# Minor release (new features)
git tag v0.2.0

# Major release (breaking changes)
git tag v1.0.0

# Post-release (packaging/docs fixes)
git tag v0.1.5.post1

# Pre-release (alpha/beta/rc)
git tag v0.1.5a1
git tag v0.1.5b1
git tag v0.1.5rc1
```

### Check Version

```bash
# Current tag
git describe --tags

# From installed package
python -c "from pawpsicle import __version__; print(__version__)"
```

## Rollback

```bash
./deploy/rollback.sh 0.1.4    # Deploy existing version from registry
```
