#!/usr/bin/env bash
# Backward-compat wrapper — calls lib/upgrade.sh --only-cleanup.
# The v5.x cleanup logic now lives in lib/upgrade.sh (v7.1+).
#
# Usage:
#   bash lib/migrate-from-md.sh [PROJECT_ROOT] [--dry-run] [--auto-confirm]
#
# All flags are forwarded; --only-cleanup is appended so the unified script
# stops after the cleanup phase (no globalize, no mirror, no strict purge),
# matching the historical migrate-from-md.sh behaviour.
set -euo pipefail
LIB_DIR="$(cd "$(dirname "$0")" && pwd)"
exec bash "$LIB_DIR/upgrade.sh" "$@" --only-cleanup
