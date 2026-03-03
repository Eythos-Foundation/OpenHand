---
summary: "Uninstall OpenHand completely (CLI, service, state, workspace)"
read_when:
  - You want to remove OpenHand from a machine
  - The gateway service is still running after uninstall
title: "Uninstall"
---

# Uninstall

Two paths:

- **Easy path** if `openhand` is still installed.
- **Manual service removal** if the CLI is gone but the service is still running.

## Easy path (CLI still installed)

Recommended: use the built-in uninstaller:

```bash
openhand uninstall
```

Non-interactive (automation / npx):

```bash
openhand uninstall --all --yes --non-interactive
npx -y openhand uninstall --all --yes --non-interactive
```

Manual steps (same result):

1. Stop the gateway service:

```bash
openhand gateway stop
```

2. Uninstall the gateway service (launchd/systemd/schtasks):

```bash
openhand gateway uninstall
```

3. Delete state + config:

```bash
rm -rf "${OPENHAND_STATE_DIR:-$HOME/.openhand}"
```

If you set `OPENHAND_CONFIG_PATH` to a custom location outside the state dir, delete that file too.

4. Delete your workspace (optional, removes agent files):

```bash
rm -rf ~/.openhand/workspace
```

5. Remove the CLI install (pick the one you used):

```bash
npm rm -g openhand
pnpm remove -g openhand
bun remove -g openhand
```

6. If you installed the macOS app:

```bash
rm -rf /Applications/OpenHand.app
```

Notes:

- If you used profiles (`--profile` / `OPENHAND_PROFILE`), repeat step 3 for each state dir (defaults are `~/.openhand-<profile>`).
- In remote mode, the state dir lives on the **gateway host**, so run steps 1-4 there too.

## Manual service removal (CLI not installed)

Use this if the gateway service keeps running but `openhand` is missing.

### macOS (launchd)

Default label is `ai.openhand.gateway` (or `ai.openhand.<profile>`; legacy `com.openhand.*` may still exist):

```bash
launchctl bootout gui/$UID/ai.openhand.gateway
rm -f ~/Library/LaunchAgents/ai.openhand.gateway.plist
```

If you used a profile, replace the label and plist name with `ai.openhand.<profile>`. Remove any legacy `com.openhand.*` plists if present.

### Linux (systemd user unit)

Default unit name is `openhand-gateway.service` (or `openhand-gateway-<profile>.service`):

```bash
systemctl --user disable --now openhand-gateway.service
rm -f ~/.config/systemd/user/openhand-gateway.service
systemctl --user daemon-reload
```

### Windows (Scheduled Task)

Default task name is `OpenHand Gateway` (or `OpenHand Gateway (<profile>)`).
The task script lives under your state dir.

```powershell
schtasks /Delete /F /TN "OpenHand Gateway"
Remove-Item -Force "$env:USERPROFILE\.openhand\gateway.cmd"
```

If you used a profile, delete the matching task name and `~\.openhand-<profile>\gateway.cmd`.

## Normal install vs source checkout

### Normal install (install.sh / npm / pnpm / bun)

If you used `https://openhand.ai/install.sh` or `install.ps1`, the CLI was installed with `npm install -g openhand@latest`.
Remove it with `npm rm -g openhand` (or `pnpm remove -g` / `bun remove -g` if you installed that way).

### Source checkout (git clone)

If you run from a repo checkout (`git clone` + `openhand ...` / `bun run openhand ...`):

1. Uninstall the gateway service **before** deleting the repo (use the easy path above or manual service removal).
2. Delete the repo directory.
3. Remove state + workspace as shown above.
