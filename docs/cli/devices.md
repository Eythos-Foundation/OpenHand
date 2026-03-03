---
summary: "CLI reference for `openhand devices` (device pairing + token rotation/revocation)"
read_when:
  - You are approving device pairing requests
  - You need to rotate or revoke device tokens
title: "devices"
---

# `openhand devices`

Manage device pairing requests and device-scoped tokens.

## Commands

### `openhand devices list`

List pending pairing requests and paired devices.

```
openhand devices list
openhand devices list --json
```

### `openhand devices remove <deviceId>`

Remove one paired device entry.

```
openhand devices remove <deviceId>
openhand devices remove <deviceId> --json
```

### `openhand devices clear --yes [--pending]`

Clear paired devices in bulk.

```
openhand devices clear --yes
openhand devices clear --yes --pending
openhand devices clear --yes --pending --json
```

### `openhand devices approve [requestId] [--latest]`

Approve a pending device pairing request. If `requestId` is omitted, OpenHand
automatically approves the most recent pending request.

```
openhand devices approve
openhand devices approve <requestId>
openhand devices approve --latest
```

### `openhand devices reject <requestId>`

Reject a pending device pairing request.

```
openhand devices reject <requestId>
```

### `openhand devices rotate --device <id> --role <role> [--scope <scope...>]`

Rotate a device token for a specific role (optionally updating scopes).

```
openhand devices rotate --device <deviceId> --role operator --scope operator.read --scope operator.write
```

### `openhand devices revoke --device <id> --role <role>`

Revoke a device token for a specific role.

```
openhand devices revoke --device <deviceId> --role node
```

## Common options

- `--url <url>`: Gateway WebSocket URL (defaults to `gateway.remote.url` when configured).
- `--token <token>`: Gateway token (if required).
- `--password <password>`: Gateway password (password auth).
- `--timeout <ms>`: RPC timeout.
- `--json`: JSON output (recommended for scripting).

Note: when you set `--url`, the CLI does not fall back to config or environment credentials.
Pass `--token` or `--password` explicitly. Missing explicit credentials is an error.

## Notes

- Token rotation returns a new token (sensitive). Treat it like a secret.
- These commands require `operator.pairing` (or `operator.admin`) scope.
- `devices clear` is intentionally gated by `--yes`.
- If pairing scope is unavailable on local loopback (and no explicit `--url` is passed), list/approve can use a local pairing fallback.
