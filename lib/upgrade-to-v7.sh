#!/usr/bin/env bash
# Backward-compat wrapper — calls lib/upgrade.sh.
# The unified upgrade flow (v5/v6/pre-current -> current) now lives in
# lib/upgrade.sh (v7.1+). All flags are forwarded unchanged.
#
# Usage:
#   bash lib/upgrade-to-v7.sh [PROJECT_ROOT] [--dry-run] [--force]
#                             [--plan] [--keep-local-fallback]
set -euo pipefail
LIB_DIR="$(cd "$(dirname "$0")" && pwd)"
exec bash "$LIB_DIR/upgrade.sh" "$@"
