#!/usr/bin/env bash
# AIPS v6.0 toolkit — copied by /aips:init to project tmp-igbkp/
set -euo pipefail

###############################################################################
# archive.sh — Encrypted full-project backup (AIPS v6.0)
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPLIT_SIZE="95M"

PROJECT_ROOT="$SCRIPT_DIR"
while [[ "$PROJECT_ROOT" != "/" ]]; do
    [[ -d "$PROJECT_ROOT/.git" ]] && break
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done

TOOLKIT_REL="${SCRIPT_DIR#$PROJECT_ROOT/}"
OUTPUT_DIR="$SCRIPT_DIR/output"

RED='\033[0;31m'; GREEN='\033[0;32m'; NC='\033[0m'
log()  { echo -e "${GREEN}[archive]${NC} $*"; }
err()  { echo -e "${RED}[error]${NC} $*" >&2; }

if command -v sha256sum >/dev/null 2>&1; then
    sha256() { sha256sum "$@"; }
elif command -v shasum >/dev/null 2>&1; then
    sha256() { shasum -a 256 "$@"; }
else
    err "sha256sum or shasum required."; exit 1
fi

if command -v gsplit >/dev/null 2>&1; then
    SPLIT_CMD="gsplit"
elif split --version 2>&1 | grep -q GNU 2>/dev/null; then
    SPLIT_CMD="split"
else
    err "GNU split required."; exit 1
fi

for cmd in tar openssl; do
    command -v "$cmd" >/dev/null 2>&1 || { err "'$cmd' required."; exit 1; }
done

[[ -d "$PROJECT_ROOT/.git" ]] || { err "Git repository not found."; exit 1; }

if [[ $# -gt 0 ]]; then
    err "Password must not be passed as CLI argument (shell history exposure risk)."
    exit 1
fi

echo -n "Enter encryption password: "
read -rs PASSWORD; echo
echo -n "Confirm password: "
read -rs PASSWORD_CONFIRM; echo
[[ "$PASSWORD" == "$PASSWORD_CONFIRM" ]] || { err "Passwords do not match."; exit 1; }
[[ ${#PASSWORD} -ge 8 ]] || { err "Password must be at least 8 characters."; exit 1; }

cd "$PROJECT_ROOT"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

TMPDIR_WORK="$SCRIPT_DIR/.work"
rm -rf "$TMPDIR_WORK"
mkdir -p "$TMPDIR_WORK"
trap 'rm -rf "$TMPDIR_WORK"' EXIT

log "Collecting project files..."
FILE_COUNT=$(find . -not -path "./$TOOLKIT_REL/*" -not -path "./$TOOLKIT_REL" \
                    \( -type f -o -type l \) | wc -l)
[[ "$FILE_COUNT" -gt 0 ]] || { log "No files to back up."; exit 0; }
log "Archive target: $FILE_COUNT files"

TAR_FILE="$TMPDIR_WORK/project.tar.gz"
STAGE_TAR="$TMPDIR_WORK/project.tar"
log "Creating tar..."
tar cf "$STAGE_TAR" --exclude="./$TOOLKIT_REL" .

# v7.0: include global memory (~/.claude/projects/<path-encoded>/memory/) in backup
GLOBAL_BACKUP_HELPER=""
for cand in \
    "$SCRIPT_DIR/../../lib/backup-global-memory.sh" \
    "$HOME/.claude/plugins/cache/AIPS/AIPS/lib/backup-global-memory.sh" \
    "$HOME/.local/share/aips/lib/backup-global-memory.sh"; do
    if [[ -f "$cand" ]]; then
        GLOBAL_BACKUP_HELPER="$cand"
        break
    fi
done
if [[ -z "$GLOBAL_BACKUP_HELPER" ]] && command -v aips-archive >/dev/null 2>&1; then
    AIPS_BIN_DIR="$(dirname "$(command -v aips-archive)")"
    for cand in \
        "$AIPS_BIN_DIR/../share/aips/lib/backup-global-memory.sh" \
        "$AIPS_BIN_DIR/../share/aips/backup-global-memory.sh"; do
        [[ -f "$cand" ]] && { GLOBAL_BACKUP_HELPER="$cand"; break; }
    done
fi
if [[ -n "$GLOBAL_BACKUP_HELPER" ]]; then
    bash "$GLOBAL_BACKUP_HELPER" "$PROJECT_ROOT" "$STAGE_TAR" || \
        log "WARN: global memory backup helper exited non-zero; continuing"
else
    log "WARN: backup-global-memory.sh not found; backup is local-only (no global memory included)"
fi

log "Compressing tar -> tar.gz..."
gzip -c "$STAGE_TAR" > "$TAR_FILE"
rm -f "$STAGE_TAR"

TAR_SIZE=$(du -h "$TAR_FILE" | cut -f1)
log "tar.gz size: $TAR_SIZE"

ENC_FILE="$TMPDIR_WORK/project.tar.gz.enc"
log "Encrypting with AES-256-CBC..."
openssl enc -aes-256-cbc -salt -pbkdf2 -iter 600000 \
    -in "$TAR_FILE" -out "$ENC_FILE" -pass "fd:3" 3<<< "$PASSWORD"

log "Splitting..."
$SPLIT_CMD -b "$SPLIT_SIZE" -d --additional-suffix=".part" "$ENC_FILE" "$OUTPUT_DIR/igbkp_"

TIMESTAMP=$(date -Iseconds 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")
MANIFEST="$OUTPUT_DIR/manifest.txt"
{
    echo "# project full backup manifest (AIPS v6.0)"
    echo "# created: $TIMESTAMP"
    echo "# project: $(basename "$PROJECT_ROOT")"
    echo "# encryption: AES-256-CBC, PBKDF2, 600000 iterations"
    echo "# split_size: $SPLIT_SIZE"
    echo "# file_count: $FILE_COUNT"
    echo "#"
    for f in "$OUTPUT_DIR"/igbkp_*.part; do
        (cd "$OUTPUT_DIR" && sha256 "$(basename "$f")")
    done
} > "$MANIFEST"

PART_COUNT=$(ls "$OUTPUT_DIR"/igbkp_*.part 2>/dev/null | wc -l)
log "Done!"
echo "Files: $FILE_COUNT  Parts: $PART_COUNT  Output: $OUTPUT_DIR/"
