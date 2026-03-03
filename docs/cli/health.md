---
summary: "CLI reference for `openhand health` (gateway health endpoint via RPC)"
read_when:
  - You want to quickly check the running Gateway’s health
title: "health"
---

# `openhand health`

Fetch health from the running Gateway.

```bash
openhand health
openhand health --json
openhand health --verbose
```

Notes:

- `--verbose` runs live probes and prints per-account timings when multiple accounts are configured.
- Output includes per-agent session stores when multiple agents are configured.
