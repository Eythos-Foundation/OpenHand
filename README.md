# 🖐 OpenHand — Personal AI Assistant

<p align="center">
  <strong>Eythos Foundation</strong><br/>
  Adaptive Technology for People with Disabilities and Neurodiversity
</p>

**OpenHand** is a _personal AI assistant_ you run on your own devices.
It answers you on the channels you already use (WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, BlueBubbles, IRC, Microsoft Teams, Matrix, Feishu, LINE, Mattermost, Nextcloud Talk, Nostr, Synology Chat, Tlon, Twitch, Zalo, Zalo Personal, WebChat). It can speak and listen on macOS/iOS/Android, and can render a live Canvas you control. The Gateway is just the control plane — the product is the assistant.

If you want a personal, single-user assistant that feels local, fast, and always-on, this is it.

[Docs](https://docs.eythosfound.org) · [Vision](VISION.md) · [Getting Started](https://docs.eythosfound.org/start/getting-started) · [Updating](https://docs.eythosfound.org/install/updating) · [FAQ](https://docs.eythosfound.org/help/faq) · [Wizard](https://docs.eythosfound.org/start/wizard) · [Docker](https://docs.eythosfound.org/install/docker) · [Discord](https://discord.gg/clawd)

Preferred setup: run the onboarding wizard (`openhand onboard`) in your terminal.
The wizard guides you step by step through setting up the gateway, workspace, channels, and skills. The CLI wizard is the recommended path and works on **macOS, Linux, and Windows (via WSL2; strongly recommended)**.
Works with npm, pnpm, or bun.
New install? Start here: [Getting started](https://docs.eythosfound.org/start/getting-started)

## About OpenHand

OpenHand is maintained by the **Eythos Foundation**, a 501(c)(3) nonprofit organization focused on adaptive technology for people with disabilities and neurodiversity.

Model note: while many providers/models are supported, for the best experience and lower prompt-injection risk use the strongest latest-generation model available to you. See [Onboarding](https://docs.eythosfound.org/start/onboarding).

## Models (selection + auth)

- Models config + CLI: [Models](https://docs.eythosfound.org/concepts/models)
- Auth profile rotation (OAuth vs API keys) + fallbacks: [Model failover](https://docs.eythosfound.org/concepts/model-failover)

## Install (recommended)

Runtime: **Node ≥22**.

```bash
npm install -g openhand@latest
# or: pnpm add -g openhand@latest

openhand onboard --install-daemon
```

The wizard installs the Gateway daemon (launchd/systemd user service) so it stays running.

## Quick start (TL;DR)

Runtime: **Node ≥22**.

Full beginner guide (auth, pairing, channels): [Getting started](https://docs.eythosfound.org/start/getting-started)

```bash
openhand onboard --install-daemon

openhand gateway --port 18789 --verbose

# Send a message
openhand message send --to +1234567890 --message "Hello from OpenHand"

# Talk to the assistant (optionally deliver back to any connected channel: WhatsApp/Telegram/Slack/Discord/Google Chat/Signal/iMessage/BlueBubbles/IRC/Microsoft Teams/Matrix/Feishu/LINE/Mattermost/Nextcloud Talk/Nostr/Synology Chat/Tlon/Twitch/Zalo/Zalo Personal/WebChat)
openhand agent --message "Ship checklist" --thinking high
```

Upgrading? [Updating guide](https://docs.eythosfound.org/install/updating) (and run `openhand doctor`).

## Development channels

- **stable**: tagged releases (`vYYYY.M.D` or `vYYYY.M.D-<patch>`), npm dist-tag `latest`.
- **beta**: prerelease tags (`vYYYY.M.D-beta.N`), npm dist-tag `beta` (macOS app may be missing).
- **dev**: moving head of `main`, npm dist-tag `dev` (when published).

Switch channels (git + npm): `openhand update --channel stable|beta|dev`.
Details: [Development channels](https://docs.eythosfound.org/install/development-channels).

## From source (development)

Prefer `pnpm` for builds from source. Bun is optional for running TypeScript directly.

```bash
git clone https://github.com/openhand/openhand.git
cd openhand

pnpm install
pnpm ui:build # auto-installs UI deps on first run
pnpm build

pnpm openhand onboard --install-daemon

# Dev loop (auto-reload on TS changes)
pnpm gateway:watch
```

Note: `pnpm openhand ...` runs TypeScript directly (via `tsx`). `pnpm build` produces `dist/` for running via Node / the packaged `openhand` binary.

## Security defaults (DM access)

OpenHand connects to real messaging surfaces. Treat inbound DMs as **untrusted input**.

Full security guide: [Security](https://docs.eythosfound.org/gateway/security)

Default behavior on Telegram/WhatsApp/Signal/iMessage/Microsoft Teams/Discord/Google Chat/Slack:

- **DM pairing** (`dmPolicy="pairing"` / `channels.discord.dmPolicy="pairing"` / `channels.slack.dmPolicy="pairing"`; legacy: `channels.discord.dm.policy`, `channels.slack.dm.policy`): unknown senders receive a short pairing code and the bot does not process their message.
- Approve with: `openhand pairing approve <channel> <code>` (then the sender is added to a local allowlist store).
- Public inbound DMs require an explicit opt-in: set `dmPolicy="open"` and include `"*"` in the channel allowlist (`allowFrom` / `channels.discord.allowFrom` / `channels.slack.allowFrom`; legacy: `channels.discord.dm.allowFrom`, `channels.slack.dm.allowFrom`).

Run `openhand doctor` to surface risky/misconfigured DM policies.

## Highlights

- **[Local-first Gateway](https://docs.eythosfound.org/gateway)** — single control plane for sessions, channels, tools, and events.
- **[Multi-channel inbox](https://docs.eythosfound.org/channels)** — WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, BlueBubbles (iMessage), iMessage (legacy), IRC, Microsoft Teams, Matrix, Feishu, LINE, Mattermost, Nextcloud Talk, Nostr, Synology Chat, Tlon, Twitch, Zalo, Zalo Personal, WebChat, macOS, iOS/Android.
- **[Multi-agent routing](https://docs.eythosfound.org/gateway/configuration)** — route inbound channels/accounts/peers to isolated agents (workspaces + per-agent sessions).
- **[Voice Wake](https://docs.eythosfound.org/nodes/voicewake) + [Talk Mode](https://docs.eythosfound.org/nodes/talk)** — wake words on macOS/iOS and continuous voice on Android (ElevenLabs + system TTS fallback).
- **[Live Canvas](https://docs.eythosfound.org/platforms/mac/canvas)** — agent-driven visual workspace with [A2UI](https://docs.eythosfound.org/platforms/mac/canvas#canvas-a2ui).
- **[First-class tools](https://docs.eythosfound.org/tools)** — browser, canvas, nodes, cron, sessions, and Discord/Slack actions.
- **[Companion apps](https://docs.eythosfound.org/platforms/macos)** — macOS menu bar app + iOS/Android [nodes](https://docs.eythosfound.org/nodes).
- **[Onboarding](https://docs.eythosfound.org/start/wizard) + [skills](https://docs.eythosfound.org/tools/skills)** — wizard-driven setup with bundled/managed/workspace skills.

## Everything we built so far

### Core platform

- [Gateway WS control plane](https://docs.eythosfound.org/gateway) with sessions, presence, config, cron, webhooks, [Control UI](https://docs.eythosfound.org/web), and [Canvas host](https://docs.eythosfound.org/platforms/mac/canvas#canvas-a2ui).
- [CLI surface](https://docs.eythosfound.org/tools/agent-send): gateway, agent, send, [wizard](https://docs.eythosfound.org/start/wizard), and [doctor](https://docs.eythosfound.org/gateway/doctor).
- [Pi agent runtime](https://docs.eythosfound.org/concepts/agent) in RPC mode with tool streaming and block streaming.
- [Session model](https://docs.eythosfound.org/concepts/session): `main` for direct chats, group isolation, activation modes, queue modes, reply-back. Group rules: [Groups](https://docs.eythosfound.org/channels/groups).
- [Media pipeline](https://docs.eythosfound.org/nodes/images): images/audio/video, transcription hooks, size caps, temp file lifecycle. Audio details: [Audio](https://docs.eythosfound.org/nodes/audio).

### Channels

- [Channels](https://docs.eythosfound.org/channels): [WhatsApp](https://docs.eythosfound.org/channels/whatsapp) (Baileys), [Telegram](https://docs.eythosfound.org/channels/telegram) (grammY), [Slack](https://docs.eythosfound.org/channels/slack) (Bolt), [Discord](https://docs.eythosfound.org/channels/discord) (discord.js), [Google Chat](https://docs.eythosfound.org/channels/googlechat) (Chat API), [Signal](https://docs.eythosfound.org/channels/signal) (signal-cli), [BlueBubbles](https://docs.eythosfound.org/channels/bluebubbles) (iMessage, recommended), [iMessage](https://docs.eythosfound.org/channels/imessage) (legacy imsg), [IRC](https://docs.eythosfound.org/channels/irc), [Microsoft Teams](https://docs.eythosfound.org/channels/msteams), [Matrix](https://docs.eythosfound.org/channels/matrix), [Feishu](https://docs.eythosfound.org/channels/feishu), [LINE](https://docs.eythosfound.org/channels/line), [Mattermost](https://docs.eythosfound.org/channels/mattermost), [Nextcloud Talk](https://docs.eythosfound.org/channels/nextcloud-talk), [Nostr](https://docs.eythosfound.org/channels/nostr), [Synology Chat](https://docs.eythosfound.org/channels/synology-chat), [Tlon](https://docs.eythosfound.org/channels/tlon), [Twitch](https://docs.eythosfound.org/channels/twitch), [Zalo](https://docs.eythosfound.org/channels/zalo), [Zalo Personal](https://docs.eythosfound.org/channels/zalouser), [WebChat](https://docs.eythosfound.org/web/webchat).
- [Group routing](https://docs.eythosfound.org/channels/group-messages): mention gating, reply tags, per-channel chunking and routing. Channel rules: [Channels](https://docs.eythosfound.org/channels).

### Apps + nodes

- [macOS app](https://docs.eythosfound.org/platforms/macos): menu bar control plane, [Voice Wake](https://docs.eythosfound.org/nodes/voicewake)/PTT, [Talk Mode](https://docs.eythosfound.org/nodes/talk) overlay, [WebChat](https://docs.eythosfound.org/web/webchat), debug tools, [remote gateway](https://docs.eythosfound.org/gateway/remote) control.
- [iOS node](https://docs.eythosfound.org/platforms/ios): [Canvas](https://docs.eythosfound.org/platforms/mac/canvas), [Voice Wake](https://docs.eythosfound.org/nodes/voicewake), [Talk Mode](https://docs.eythosfound.org/nodes/talk), camera, screen recording, Bonjour + device pairing.
- [Android node](https://docs.eythosfound.org/platforms/android): Connect tab (setup code/manual), chat sessions, voice tab, [Canvas](https://docs.eythosfound.org/platforms/mac/canvas), camera/screen recording, and Android device commands (notifications/location/SMS/photos/contacts/calendar/motion/app update).
- [macOS node mode](https://docs.eythosfound.org/nodes): system.run/notify + canvas/camera exposure.

### Tools + automation

- [Browser control](https://docs.eythosfound.org/tools/browser): dedicated openhand Chrome/Chromium, snapshots, actions, uploads, profiles.
- [Canvas](https://docs.eythosfound.org/platforms/mac/canvas): [A2UI](https://docs.eythosfound.org/platforms/mac/canvas#canvas-a2ui) push/reset, eval, snapshot.
- [Nodes](https://docs.eythosfound.org/nodes): camera snap/clip, screen record, [location.get](https://docs.eythosfound.org/nodes/location-command), notifications.
- [Cron + wakeups](https://docs.eythosfound.org/automation/cron-jobs); [webhooks](https://docs.eythosfound.org/automation/webhook); [Gmail Pub/Sub](https://docs.eythosfound.org/automation/gmail-pubsub).
- [Skills platform](https://docs.eythosfound.org/tools/skills): bundled, managed, and workspace skills with install gating + UI.

### Runtime + safety

- [Channel routing](https://docs.eythosfound.org/channels/channel-routing), [retry policy](https://docs.eythosfound.org/concepts/retry), and [streaming/chunking](https://docs.eythosfound.org/concepts/streaming).
- [Presence](https://docs.eythosfound.org/concepts/presence), [typing indicators](https://docs.eythosfound.org/concepts/typing-indicators), and [usage tracking](https://docs.eythosfound.org/concepts/usage-tracking).
- [Models](https://docs.eythosfound.org/concepts/models), [model failover](https://docs.eythosfound.org/concepts/model-failover), and [session pruning](https://docs.eythosfound.org/concepts/session-pruning).
- [Security](https://docs.eythosfound.org/gateway/security) and [troubleshooting](https://docs.eythosfound.org/channels/troubleshooting).

### Ops + packaging

- [Control UI](https://docs.eythosfound.org/web) + [WebChat](https://docs.eythosfound.org/web/webchat) served directly from the Gateway.
- [Tailscale Serve/Funnel](https://docs.eythosfound.org/gateway/tailscale) or [SSH tunnels](https://docs.eythosfound.org/gateway/remote) with token/password auth.
- [Nix mode](https://docs.eythosfound.org/install/nix) for declarative config; [Docker](https://docs.eythosfound.org/install/docker)-based installs.
- [Doctor](https://docs.eythosfound.org/gateway/doctor) migrations, [logging](https://docs.eythosfound.org/logging).

## How it works (short)

```
WhatsApp / Telegram / Slack / Discord / Google Chat / Signal / iMessage / BlueBubbles / IRC / Microsoft Teams / Matrix / Feishu / LINE / Mattermost / Nextcloud Talk / Nostr / Synology Chat / Tlon / Twitch / Zalo / Zalo Personal / WebChat
               │
               ▼
┌───────────────────────────────┐
│            Gateway            │
│       (control plane)         │
│     ws://127.0.0.1:18789      │
└──────────────┬────────────────┘
               │
               ├─ Pi agent (RPC)
               ├─ CLI (openhand …)
               ├─ WebChat UI
               ├─ macOS app
               └─ iOS / Android nodes
```

## Key subsystems

- **[Gateway WebSocket network](https://docs.eythosfound.org/concepts/architecture)** — single WS control plane for clients, tools, and events (plus ops: [Gateway runbook](https://docs.eythosfound.org/gateway)).
- **[Tailscale exposure](https://docs.eythosfound.org/gateway/tailscale)** — Serve/Funnel for the Gateway dashboard + WS (remote access: [Remote](https://docs.eythosfound.org/gateway/remote)).
- **[Browser control](https://docs.eythosfound.org/tools/browser)** — openhand‑managed Chrome/Chromium with CDP control.
- **[Canvas + A2UI](https://docs.eythosfound.org/platforms/mac/canvas)** — agent‑driven visual workspace (A2UI host: [Canvas/A2UI](https://docs.eythosfound.org/platforms/mac/canvas#canvas-a2ui)).
- **[Voice Wake](https://docs.eythosfound.org/nodes/voicewake) + [Talk Mode](https://docs.eythosfound.org/nodes/talk)** — wake words on macOS/iOS plus continuous voice on Android.
- **[Nodes](https://docs.eythosfound.org/nodes)** — Canvas, camera snap/clip, screen record, `location.get`, notifications, plus macOS‑only `system.run`/`system.notify`.

## Tailscale access (Gateway dashboard)

OpenHand can auto-configure Tailscale **Serve** (tailnet-only) or **Funnel** (public) while the Gateway stays bound to loopback. Configure `gateway.tailscale.mode`:

- `off`: no Tailscale automation (default).
- `serve`: tailnet-only HTTPS via `tailscale serve` (uses Tailscale identity headers by default).
- `funnel`: public HTTPS via `tailscale funnel` (requires shared password auth).

Notes:

- `gateway.bind` must stay `loopback` when Serve/Funnel is enabled (OpenHand enforces this).
- Serve can be forced to require a password by setting `gateway.auth.mode: "password"` or `gateway.auth.allowTailscale: false`.
- Funnel refuses to start unless `gateway.auth.mode: "password"` is set.
- Optional: `gateway.tailscale.resetOnExit` to undo Serve/Funnel on shutdown.

Details: [Tailscale guide](https://docs.eythosfound.org/gateway/tailscale) · [Web surfaces](https://docs.eythosfound.org/web)

## Remote Gateway (Linux is great)

It’s perfectly fine to run the Gateway on a small Linux instance. Clients (macOS app, CLI, WebChat) can connect over **Tailscale Serve/Funnel** or **SSH tunnels**, and you can still pair device nodes (macOS/iOS/Android) to execute device‑local actions when needed.

- **Gateway host** runs the exec tool and channel connections by default.
- **Device nodes** run device‑local actions (`system.run`, camera, screen recording, notifications) via `node.invoke`.
  In short: exec runs where the Gateway lives; device actions run where the device lives.

Details: [Remote access](https://docs.eythosfound.org/gateway/remote) · [Nodes](https://docs.eythosfound.org/nodes) · [Security](https://docs.eythosfound.org/gateway/security)

## macOS permissions via the Gateway protocol

The macOS app can run in **node mode** and advertises its capabilities + permission map over the Gateway WebSocket (`node.list` / `node.describe`). Clients can then execute local actions via `node.invoke`:

- `system.run` runs a local command and returns stdout/stderr/exit code; set `needsScreenRecording: true` to require screen-recording permission (otherwise you’ll get `PERMISSION_MISSING`).
- `system.notify` posts a user notification and fails if notifications are denied.
- `canvas.*`, `camera.*`, `screen.record`, and `location.get` are also routed via `node.invoke` and follow TCC permission status.

Elevated bash (host permissions) is separate from macOS TCC:

- Use `/elevated on|off` to toggle per‑session elevated access when enabled + allowlisted.
- Gateway persists the per‑session toggle via `sessions.patch` (WS method) alongside `thinkingLevel`, `verboseLevel`, `model`, `sendPolicy`, and `groupActivation`.

Details: [Nodes](https://docs.eythosfound.org/nodes) · [macOS app](https://docs.eythosfound.org/platforms/macos) · [Gateway protocol](https://docs.eythosfound.org/concepts/architecture)

## Agent to Agent (sessions\_\* tools)

- Use these to coordinate work across sessions without jumping between chat surfaces.
- `sessions_list` — discover active sessions (agents) and their metadata.
- `sessions_history` — fetch transcript logs for a session.
- `sessions_send` — message another session; optional reply‑back ping‑pong + announce step (`REPLY_SKIP`, `ANNOUNCE_SKIP`).

Details: [Session tools](https://docs.eythosfound.org/concepts/session-tool)

## Skills registry (ClawHub)

ClawHub is a minimal skill registry. With ClawHub enabled, the agent can search for skills automatically and pull in new ones as needed.

[ClawHub](https://clawhub.com)

## Chat commands

Send these in WhatsApp/Telegram/Slack/Google Chat/Microsoft Teams/WebChat (group commands are owner-only):

- `/status` — compact session status (model + tokens, cost when available)
- `/new` or `/reset` — reset the session
- `/compact` — compact session context (summary)
- `/think <level>` — off|minimal|low|medium|high|xhigh (GPT-5.2 + Codex models only)
- `/verbose on|off`
- `/usage off|tokens|full` — per-response usage footer
- `/restart` — restart the gateway (owner-only in groups)
- `/activation mention|always` — group activation toggle (groups only)

## Apps (optional)

The Gateway alone delivers a great experience. All apps are optional and add extra features.

If you plan to build/run companion apps, follow the platform runbooks below.

### macOS (OpenHand.app) (optional)

- Menu bar control for the Gateway and health.
- Voice Wake + push-to-talk overlay.
- WebChat + debug tools.
- Remote gateway control over SSH.

Note: signed builds required for macOS permissions to stick across rebuilds (see `docs/mac/permissions.md`).

### iOS node (optional)

- Pairs as a node over the Gateway WebSocket (device pairing).
- Voice trigger forwarding + Canvas surface.
- Controlled via `openhand nodes …`.

Runbook: [iOS connect](https://docs.eythosfound.org/platforms/ios).

### Android node (optional)

- Pairs as a WS node via device pairing (`openhand devices ...`).
- Exposes Connect/Chat/Voice tabs plus Canvas, Camera, Screen capture, and Android device command families.
- Runbook: [Android connect](https://docs.eythosfound.org/platforms/android).

## Agent workspace + skills

- Workspace root: `~/.openhand/workspace` (configurable via `agents.defaults.workspace`).
- Injected prompt files: `AGENTS.md`, `SOUL.md`, `TOOLS.md`.
- Skills: `~/.openhand/workspace/skills/<skill>/SKILL.md`.

## Configuration

Minimal `~/.openhand/openhand.json` (model + defaults):

```json5
{
  agent: {
    model: "anthropic/claude-opus-4-6",
  },
}
```

[Full configuration reference (all keys + examples).](https://docs.eythosfound.org/gateway/configuration)

## Security model (important)

- **Default:** tools run on the host for the **main** session, so the agent has full access when it’s just you.
- **Group/channel safety:** set `agents.defaults.sandbox.mode: "non-main"` to run **non‑main sessions** (groups/channels) inside per‑session Docker sandboxes; bash then runs in Docker for those sessions.
- **Sandbox defaults:** allowlist `bash`, `process`, `read`, `write`, `edit`, `sessions_list`, `sessions_history`, `sessions_send`, `sessions_spawn`; denylist `browser`, `canvas`, `nodes`, `cron`, `discord`, `gateway`.

Details: [Security guide](https://docs.eythosfound.org/gateway/security) · [Docker + sandboxing](https://docs.eythosfound.org/install/docker) · [Sandbox config](https://docs.eythosfound.org/gateway/configuration)

### [WhatsApp](https://docs.eythosfound.org/channels/whatsapp)

- Link the device: `pnpm openhand channels login` (stores creds in `~/.openhand/credentials`).
- Allowlist who can talk to the assistant via `channels.whatsapp.allowFrom`.
- If `channels.whatsapp.groups` is set, it becomes a group allowlist; include `"*"` to allow all.

### [Telegram](https://docs.eythosfound.org/channels/telegram)

- Set `TELEGRAM_BOT_TOKEN` or `channels.telegram.botToken` (env wins).
- Optional: set `channels.telegram.groups` (with `channels.telegram.groups."*".requireMention`); when set, it is a group allowlist (include `"*"` to allow all). Also `channels.telegram.allowFrom` or `channels.telegram.webhookUrl` + `channels.telegram.webhookSecret` as needed.

```json5
{
  channels: {
    telegram: {
      botToken: "123456:ABCDEF",
    },
  },
}
```

### [Slack](https://docs.eythosfound.org/channels/slack)

- Set `SLACK_BOT_TOKEN` + `SLACK_APP_TOKEN` (or `channels.slack.botToken` + `channels.slack.appToken`).

### [Discord](https://docs.eythosfound.org/channels/discord)

- Set `DISCORD_BOT_TOKEN` or `channels.discord.token` (env wins).
- Optional: set `commands.native`, `commands.text`, or `commands.useAccessGroups`, plus `channels.discord.allowFrom`, `channels.discord.guilds`, or `channels.discord.mediaMaxMb` as needed.

```json5
{
  channels: {
    discord: {
      token: "1234abcd",
    },
  },
}
```

### [Signal](https://docs.eythosfound.org/channels/signal)

- Requires `signal-cli` and a `channels.signal` config section.

### [BlueBubbles (iMessage)](https://docs.eythosfound.org/channels/bluebubbles)

- **Recommended** iMessage integration.
- Configure `channels.bluebubbles.serverUrl` + `channels.bluebubbles.password` and a webhook (`channels.bluebubbles.webhookPath`).
- The BlueBubbles server runs on macOS; the Gateway can run on macOS or elsewhere.

### [iMessage (legacy)](https://docs.eythosfound.org/channels/imessage)

- Legacy macOS-only integration via `imsg` (Messages must be signed in).
- If `channels.imessage.groups` is set, it becomes a group allowlist; include `"*"` to allow all.

### [Microsoft Teams](https://docs.eythosfound.org/channels/msteams)

- Configure a Teams app + Bot Framework, then add a `msteams` config section.
- Allowlist who can talk via `msteams.allowFrom`; group access via `msteams.groupAllowFrom` or `msteams.groupPolicy: "open"`.

### [WebChat](https://docs.eythosfound.org/web/webchat)

- Uses the Gateway WebSocket; no separate WebChat port/config.

Browser control (optional):

```json5
{
  browser: {
    enabled: true,
    color: "#FF4500",
  },
}
```

## Docs

Use these when you’re past the onboarding flow and want the deeper reference.

- [Start with the docs index for navigation and “what’s where.”](https://docs.eythosfound.org)
- [Read the architecture overview for the gateway + protocol model.](https://docs.eythosfound.org/concepts/architecture)
- [Use the full configuration reference when you need every key and example.](https://docs.eythosfound.org/gateway/configuration)
- [Run the Gateway by the book with the operational runbook.](https://docs.eythosfound.org/gateway)
- [Learn how the Control UI/Web surfaces work and how to expose them safely.](https://docs.eythosfound.org/web)
- [Understand remote access over SSH tunnels or tailnets.](https://docs.eythosfound.org/gateway/remote)
- [Follow the onboarding wizard flow for a guided setup.](https://docs.eythosfound.org/start/wizard)
- [Wire external triggers via the webhook surface.](https://docs.eythosfound.org/automation/webhook)
- [Set up Gmail Pub/Sub triggers.](https://docs.eythosfound.org/automation/gmail-pubsub)
- [Learn the macOS menu bar companion details.](https://docs.eythosfound.org/platforms/mac/menu-bar)
- [Platform guides: Windows (WSL2)](https://docs.eythosfound.org/platforms/windows), [Linux](https://docs.eythosfound.org/platforms/linux), [macOS](https://docs.eythosfound.org/platforms/macos), [iOS](https://docs.eythosfound.org/platforms/ios), [Android](https://docs.eythosfound.org/platforms/android)
- [Debug common failures with the troubleshooting guide.](https://docs.eythosfound.org/channels/troubleshooting)
- [Review security guidance before exposing anything.](https://docs.eythosfound.org/gateway/security)

## Advanced docs (discovery + control)

- [Discovery + transports](https://docs.eythosfound.org/gateway/discovery)
- [Bonjour/mDNS](https://docs.eythosfound.org/gateway/bonjour)
- [Gateway pairing](https://docs.eythosfound.org/gateway/pairing)
- [Remote gateway README](https://docs.eythosfound.org/gateway/remote-gateway-readme)
- [Control UI](https://docs.eythosfound.org/web/control-ui)
- [Dashboard](https://docs.eythosfound.org/web/dashboard)

## Operations & troubleshooting

- [Health checks](https://docs.eythosfound.org/gateway/health)
- [Gateway lock](https://docs.eythosfound.org/gateway/gateway-lock)
- [Background process](https://docs.eythosfound.org/gateway/background-process)
- [Browser troubleshooting (Linux)](https://docs.eythosfound.org/tools/browser-linux-troubleshooting)
- [Logging](https://docs.eythosfound.org/logging)

## Deep dives

- [Agent loop](https://docs.eythosfound.org/concepts/agent-loop)
- [Presence](https://docs.eythosfound.org/concepts/presence)
- [TypeBox schemas](https://docs.eythosfound.org/concepts/typebox)
- [RPC adapters](https://docs.eythosfound.org/reference/rpc)
- [Queue](https://docs.eythosfound.org/concepts/queue)

## Workspace & skills

- [Skills config](https://docs.eythosfound.org/tools/skills-config)
- [Default AGENTS](https://docs.eythosfound.org/reference/AGENTS.default)
- [Templates: AGENTS](https://docs.eythosfound.org/reference/templates/AGENTS)
- [Templates: BOOTSTRAP](https://docs.eythosfound.org/reference/templates/BOOTSTRAP)
- [Templates: IDENTITY](https://docs.eythosfound.org/reference/templates/IDENTITY)
- [Templates: SOUL](https://docs.eythosfound.org/reference/templates/SOUL)
- [Templates: TOOLS](https://docs.eythosfound.org/reference/templates/TOOLS)
- [Templates: USER](https://docs.eythosfound.org/reference/templates/USER)

## Platform internals

- [macOS dev setup](https://docs.eythosfound.org/platforms/mac/dev-setup)
- [macOS menu bar](https://docs.eythosfound.org/platforms/mac/menu-bar)
- [macOS voice wake](https://docs.eythosfound.org/platforms/mac/voicewake)
- [iOS node](https://docs.eythosfound.org/platforms/ios)
- [Android node](https://docs.eythosfound.org/platforms/android)
- [Windows (WSL2)](https://docs.eythosfound.org/platforms/windows)
- [Linux app](https://docs.eythosfound.org/platforms/linux)

## Email hooks (Gmail)

- [docs.openhand.ai/gmail-pubsub](https://docs.eythosfound.org/automation/gmail-pubsub)

## Eythos Foundation

OpenHand is maintained by the **Eythos Foundation**, a Tennessee-based 501(c)(3) nonprofit organization.

**Mission:** Adaptive technology for people with disabilities and neurodiversity.

- **GitHub:** [Eythos-Foundation/OpenHand](https://github.com/Eythos-Foundation/OpenHand)
- **Documentation:** [docs.eythosfound.org](https://docs.eythosfound.org)
- **Email:** eythosfoundation@gmail.com
- **EIN:** 33-1423078

## Contributing

OpenHand welcomes contributions from developers, accessibility advocates, and community members who share our mission of making technology more accessible.

**How to contribute:**
- Read our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines and submission process
- Report issues or suggest features via [GitHub Issues](https://github.com/Eythos-Foundation/OpenHand/issues)
- Join discussions on [Discord](https://discord.gg/clawd)

**About this project:**
OpenHand is a continuation of the OpenHand project, now maintained by the Eythos Foundation as part of our commitment to adaptive technology. We honor the original vision while expanding accessibility features and community-driven development.

