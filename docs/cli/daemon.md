---
summary: "CLI reference for `openhand daemon` (legacy alias for gateway service management)"
read_when:
  - You still use `openhand daemon ...` in scripts
  - You need service lifecycle commands (install/start/stop/restart/status)
title: "daemon"
---

# `openhand daemon`

Legacy alias for Gateway service management commands.

`openhand daemon ...` maps to the same service control surface as `openhand gateway ...` service commands.

## Usage

```bash
openhand daemon status
openhand daemon install
openhand daemon start
openhand daemon stop
openhand daemon restart
openhand daemon uninstall
```

## Subcommands

- `status`: show service install state and probe Gateway health
- `install`: install service (`launchd`/`systemd`/`schtasks`)
- `uninstall`: remove service
- `start`: start service
- `stop`: stop service
- `restart`: restart service

## Common options

- `status`: `--url`, `--token`, `--password`, `--timeout`, `--no-probe`, `--deep`, `--json`
- `install`: `--port`, `--runtime <node|bun>`, `--token`, `--force`, `--json`
- lifecycle (`uninstall|start|stop|restart`): `--json`

## Prefer

Use [`openhand gateway`](/cli/gateway) for current docs and examples.
