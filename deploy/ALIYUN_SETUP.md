# Aliyun Container Registry (ACR) Setup

## Concepts

| Term | Example | Purpose |
|------|---------|---------|
| **Login Username** | `your-email@example.com` | Aliyun account for `docker login` |
| **Fixed Password** | `xxxxxxxx` | Registry password (set in console) |
| **Namespace** | `your-namespace` | Image path (`registry/namespace/image`) |

---

## Quick Setup

### 1. Create Registry (First Time)

1. Visit <https://cr.console.aliyun.com/>
2. Create **Personal Edition** (免费)
3. Set **Fixed Password** at: 访问凭证 → 固定密码
4. Create **Namespace** at: 命名空间

### 2. Login

```bash
# Login with Aliyun account username (email)
docker login --username=your-email@example.com registry.cn-hangzhou.aliyuncs.com
```

### 3. Login on jdc

```bash
ssh jdc "docker login --username=your-email@example.com registry.cn-hangzhou.aliyuncs.com"
```
