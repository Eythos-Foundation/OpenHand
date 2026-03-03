# Migration Guide: OpenClaw → OpenHand

**Date:** March 3, 2026  
**Rebrand Branch:** `rebrand-phase-1`  
**Repository:** https://github.com/Eythos-Foundation/OpenHand

---

## Overview

OpenHand is a complete rebrand of OpenClaw, now maintained by the Eythos Foundation. This guide helps existing OpenClaw users migrate to OpenHand.

## What Changed

### Package Names
- **npm package:** `openclaw` → `openhand`
- **Binary:** `openclaw` → `openhand`
- **CLI commands:** All `openclaw` commands now use `openhand`

### Repository & URLs
- **GitHub:** `openclaw/openclaw` → `Eythos-Foundation/OpenHand`
- **Documentation:** `docs.openclaw.ai` → `docs.eythosfound.org`
- **Website:** `openclaw.ai` → `openhand.ai` (planned)

### Environment Variables
All `OPENCLAW_*` environment variables renamed to `OPENHAND_*`:

| Old Variable | New Variable |
|-------------|-------------|
| `OPENCLAW_HOME` | `OPENHAND_HOME` |
| `OPENCLAW_CONFIG_DIR` | `OPENHAND_CONFIG_DIR` |
| `OPENCLAW_STATE_DIR` | `OPENHAND_STATE_DIR` |
| `OPENCLAW_LOGS_DIR` | `OPENHAND_LOGS_DIR` |
| `OPENCLAW_WORKSPACE_DIR` | `OPENHAND_WORKSPACE_DIR` |
| `OPENCLAW_GATEWAY_URL` | `OPENHAND_GATEWAY_URL` |
| `OPENCLAW_GATEWAY_TOKEN` | `OPENHAND_GATEWAY_TOKEN` |
| `OPENCLAW_IMAGE` | `OPENHAND_IMAGE` |

### File Paths (Examples)
- **Config:** `~/.openclaw/` → `~/.openhand/`
- **Workspace:** `~/.openclaw/workspace` → `~/.openhand/workspace`
- **Logs:** `~/.openclaw/logs` → `~/.openhand/logs`

### Docker
- **Image name:** `openclaw/openclaw` → `eythosfoundation/openhand`
- **Container name:** `openclaw-gateway` → `openhand-gateway`

### Code References
- **TypeScript/JavaScript imports:** `import { ... } from 'openclaw'` → `import { ... } from 'openhand'`
- **Python imports:** `import openclaw` → `import openhand`
- **Go packages:** `github.com/openclaw/openclaw` → `github.com/Eythos-Foundation/OpenHand`

---

## Migration Steps

### 1. Backup Your Data
```bash
# Backup existing OpenClaw config and data
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz ~/.openclaw
```

### 2. Uninstall OpenClaw
```bash
npm uninstall -g openclaw
# or
pnpm remove -g openclaw
# or
brew uninstall openclaw
```

### 3. Install OpenHand
```bash
npm install -g openhand
# or
pnpm add -g openhand
# or
brew install openhand  # (once published)
```

### 4. Migrate Configuration

#### Option A: Fresh Start (Recommended)
```bash
openhand onboard
```

#### Option B: Migrate Existing Config
```bash
# Copy config directory
cp -r ~/.openclaw ~/.openhand

# Update config files to use new package name
cd ~/.openhand
find . -type f -exec sed -i '' 's/openclaw/openhand/g' {} +
find . -type f -exec sed -i '' 's/OPENCLAW_/OPENHAND_/g' {} +
```

### 5. Update Environment Variables
Update your shell profile (`~/.zshrc`, `~/.bashrc`, etc.):
```bash
# Old
export OPENCLAW_HOME=~/.openclaw
export OPENCLAW_GATEWAY_TOKEN=your_token

# New
export OPENHAND_HOME=~/.openhand
export OPENHAND_GATEWAY_TOKEN=your_token
```

Reload your shell:
```bash
source ~/.zshrc  # or ~/.bashrc
```

### 6. Update Docker Deployments
Update `docker-compose.yml`:
```yaml
# Old
services:
  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw-gateway
    environment:
      - OPENCLAW_HOME=/data

# New
services:
  openhand:
    image: eythosfoundation/openhand:latest
    container_name: openhand-gateway
    environment:
      - OPENHAND_HOME=/data
```

### 7. Update Systemd Services (Linux)
```bash
# Update service file
sudo sed -i 's/openclaw/openhand/g' /etc/systemd/system/openclaw.service
sudo sed -i 's/OPENCLAW_/OPENHAND_/g' /etc/systemd/system/openclaw.service

# Rename service file
sudo mv /etc/systemd/system/openclaw.service /etc/systemd/system/openhand.service

# Reload systemd
sudo systemctl daemon-reload
sudo systemctl enable openhand
sudo systemctl start openhand
```

### 8. Update LaunchAgent (macOS)
```bash
# Update plist file
sed -i '' 's/openclaw/openhand/g' ~/Library/LaunchAgents/ai.openclaw.gateway.plist
sed -i '' 's/OPENCLAW_/OPENHAND_/g' ~/Library/LaunchAgents/ai.openclaw.gateway.plist

# Rename plist file
mv ~/Library/LaunchAgents/ai.openclaw.gateway.plist \
   ~/Library/LaunchAgents/org.eythosfound.openhand.plist

# Reload LaunchAgent
launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/org.eythosfound.openhand.plist
```

### 9. Update Custom Scripts & Extensions
Search and replace in your custom code:
```bash
# Find all references
grep -r "openclaw" ~/your-scripts/

# Replace (example)
find ~/your-scripts/ -type f -exec sed -i 's/openclaw/openhand/g' {} +
```

### 10. Verify Installation
```bash
# Check version
openhand --version

# Check gateway status
openhand status

# Test basic command
openhand gateway status
```

---

## Breaking Changes

### Configuration Schema
- No breaking changes to config structure
- Only package name and environment variable names changed

### API Compatibility
- **REST API endpoints:** Unchanged (internal routes use same structure)
- **Gateway protocol:** Backward compatible
- **Plugin interface:** Compatible (as long as package name updated)

### Data Migration
- **Session transcripts:** No migration needed (stored as JSON, structure unchanged)
- **Memory files:** No migration needed (plain text/markdown)
- **Skills:** Update any hardcoded references to `openclaw` package

---

## Common Issues

### Issue: Command not found: openhand
**Solution:**
```bash
# Verify installation
npm list -g openhand

# Check PATH
echo $PATH

# Reinstall if needed
npm install -g openhand
```

### Issue: Gateway won't start
**Solution:**
```bash
# Check for old process
ps aux | grep openclaw
kill <pid>  # if found

# Check logs
openhand logs
```

### Issue: Environment variables not loading
**Solution:**
```bash
# Verify shell profile was updated and reloaded
source ~/.zshrc  # or ~/.bashrc

# Check current environment
env | grep OPENHAND
```

### Issue: Docker container fails to start
**Solution:**
```bash
# Pull new image
docker pull eythosfoundation/openhand:latest

# Remove old container
docker rm -f openclaw-gateway

# Start new container
docker-compose up -d
```

---

## Rollback Instructions

If you need to rollback to OpenClaw:

```bash
# Stop OpenHand
openhand gateway stop

# Uninstall OpenHand
npm uninstall -g openhand

# Reinstall OpenClaw
npm install -g openclaw@latest

# Restore backup
tar -xzf openclaw-backup-YYYYMMDD.tar.gz -C ~/

# Restart OpenClaw
openclaw gateway start
```

---

## Support

- **Documentation:** https://docs.eythosfound.org
- **GitHub Issues:** https://github.com/Eythos-Foundation/OpenHand/issues
- **Discord:** https://discord.gg/clawd (OpenClaw community - temporary during transition)

---

## Timeline

- **March 3, 2026:** Rebrand completed, testing phase
- **TBD:** Official OpenHand 1.0 release
- **TBD:** npm package publication

---

## FAQ

### Why the rebrand?
OpenHand is now maintained by the Eythos Foundation, a 501(c)(3) nonprofit focused on adaptive technology for people with disabilities and neurodiversity.

### Will OpenClaw continue to be maintained?
No. All development is now focused on OpenHand. The OpenClaw repository will be archived after the transition period.

### Is this a fork or a continuation?
Continuation. OpenHand is the same project with a new name and organizational home.

### Will my existing setup work?
Yes, with the migration steps above. The core functionality is unchanged.

### When will OpenHand be published to npm?
After QA testing is complete and the rebrand is merged to main branch.

---

**Last Updated:** March 3, 2026  
**Rebrand Commit:** d349ab0c6  
**Files Changed:** 3,601  
**Lines Changed:** 51,205 insertions
