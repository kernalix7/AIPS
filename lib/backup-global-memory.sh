#!/usr/bin/env bash
# AIPS v7.0 — backup-global-memory.sh
# Helper called by templates/tmp-igbkp/archive.sh to include the project's
# global memory dir in the backup tarball.
#
# Usage:
#   bash lib/backup-global-memory.sh <project_root> <output_tar_path>
#
# Looks for global memory in (in order, first match wins):
#   1) ~/.claude/projects/<path-with-slashes-as-dashes>/memory/   (v6.0 dual-write)
#   2) ~/.claude/sessions/<md5-12>/memory/                        (v7.0 path-hash)
#
# Appends `memory/` into the supplied uncompressed tar. If the tarball is
# gzipped (.tar.gz / .tgz), this script will skip the append (gzip streams
# cannot be appended to) and just emit a warning — caller should pass an
# uncompressed staging tar.
#
# Exit codes:
#   0  appended OR no global memory found (informational)
#   1  bad usage / unrecoverable error

set -euo pipefail

usage() {
    echo "usage: $(basename "$0") <project_root> <output_tar_path>" >&2
    exit 1
}

[[ $# -eq 2 ]] || usage

PROJECT_ROOT="$1"
OUTPUT_TAR="$2"

[[ -d "$PROJECT_ROOT" ]] || { echo "[backup] project_root not a directory: $PROJECT_ROOT" >&2; exit 1; }
[[ -f "$OUTPUT_TAR"   ]] || { echo "[backup] output tar not found: $OUTPUT_TAR" >&2; exit 1; }

# Path-hash (same algo as PostToolUse.sh)
PATH_HASH="$(echo -n "$PROJECT_ROOT" | md5sum 2>/dev/null | cut -c1-12)"
[[ -z "$PATH_HASH" ]] && PATH_HASH="$(echo -n "$PROJECT_ROOT" | openssl md5 2>/dev/null | awk '{print $NF}' | cut -c1-12)"

# Path-encoded (v6.0 dual-write convention)
PATH_ENCODED="$(echo "$PROJECT_ROOT" | tr '/' '-')"

CANDIDATES=(
    "$HOME/.claude/projects/${PATH_ENCODED}/memory"
    "$HOME/.claude/sessions/${PATH_HASH}/memory"
)

GLOBAL_MEM=""
for c in "${CANDIDATES[@]}"; do
    if [[ -d "$c" ]]; then
        GLOBAL_MEM="$c"
        break
    fi
done

if [[ -z "$GLOBAL_MEM" ]]; then
    echo "[backup] no global memory dir found (looked in: ${CANDIDATES[*]})"
    exit 0
fi

# Refuse gzipped tarballs (cannot append)
case "$OUTPUT_TAR" in
    *.tar.gz|*.tgz)
        echo "[backup] WARN: $OUTPUT_TAR is gzipped; cannot append. Pass uncompressed tar instead." >&2
        exit 0
        ;;
esac

PARENT_DIR="$(dirname "$GLOBAL_MEM")"
FILE_COUNT=$(find "$GLOBAL_MEM" -type f 2>/dev/null | wc -l | tr -d ' ')

tar --append --file="$OUTPUT_TAR" -C "$PARENT_DIR" memory/ 2>/dev/null || {
    echo "[backup] WARN: tar --append failed for $GLOBAL_MEM" >&2
    exit 0
}

echo "[backup] included global memory: $GLOBAL_MEM ($FILE_COUNT files)"
exit 0
