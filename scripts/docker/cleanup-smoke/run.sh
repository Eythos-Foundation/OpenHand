#!/usr/bin/env bash
set -euo pipefail

cd /repo

export OPENHAND_STATE_DIR="/tmp/openhand-test"
export OPENHAND_CONFIG_PATH="${OPENHAND_STATE_DIR}/openhand.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${OPENHAND_STATE_DIR}/credentials"
mkdir -p "${OPENHAND_STATE_DIR}/agents/main/sessions"
echo '{}' >"${OPENHAND_CONFIG_PATH}"
echo 'creds' >"${OPENHAND_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${OPENHAND_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm openhand reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${OPENHAND_CONFIG_PATH}"
test ! -d "${OPENHAND_STATE_DIR}/credentials"
test ! -d "${OPENHAND_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${OPENHAND_STATE_DIR}/credentials"
echo '{}' >"${OPENHAND_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm openhand uninstall --state --yes --non-interactive

test ! -d "${OPENHAND_STATE_DIR}"

echo "OK"
