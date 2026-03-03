---
summary: "CLI reference for `openhand config` (get/set/unset/file/validate)"
read_when:
  - You want to read or edit config non-interactively
title: "config"
---

# `openhand config`

Config helpers: get/set/unset/validate values by path and print the active
config file. Run without a subcommand to open
the configure wizard (same as `openhand configure`).

## Examples

```bash
openhand config file
openhand config get browser.executablePath
openhand config set browser.executablePath "/usr/bin/google-chrome"
openhand config set agents.defaults.heartbeat.every "2h"
openhand config set agents.list[0].tools.exec.node "node-id-or-name"
openhand config unset tools.web.search.apiKey
openhand config validate
openhand config validate --json
```

## Paths

Paths use dot or bracket notation:

```bash
openhand config get agents.defaults.workspace
openhand config get agents.list[0].id
```

Use the agent list index to target a specific agent:

```bash
openhand config get agents.list
openhand config set agents.list[1].tools.exec.node "node-id-or-name"
```

## Values

Values are parsed as JSON5 when possible; otherwise they are treated as strings.
Use `--strict-json` to require JSON5 parsing. `--json` remains supported as a legacy alias.

```bash
openhand config set agents.defaults.heartbeat.every "0m"
openhand config set gateway.port 19001 --strict-json
openhand config set channels.whatsapp.groups '["*"]' --strict-json
```

## Subcommands

- `config file`: Print the active config file path (resolved from `OPENHAND_CONFIG_PATH` or default location).

Restart the gateway after edits.

## Validate

Validate the current config against the active schema without starting the
gateway.

```bash
openhand config validate
openhand config validate --json
```
