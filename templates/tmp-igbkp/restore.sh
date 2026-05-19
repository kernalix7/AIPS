#!/usr/bin/env bash
# AIPS v6.0 toolkit — copied by /aips:init to project tmp-igbkp/
set -euo pipefail

###############################################################################
# restore.sh — Restore encrypted project backup (AIPS v6.0)
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
while [[ "$PROJECT_ROOT" != "/" ]]; do
    [[ -d "$PROJECT_ROOT/.git" ]] && break
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done

TOOLKIT_REL="${SCRIPT_DIR#$PROJECT_ROOT/}"
OUTPUT_DIR="$SCRIPT_DIR/output"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log()  { echo -e "${GREEN}[restore]${NC} $*"; }
err()  { echo -e "${RED}[error]${NC} $*" >&2; }

if command -v sha256sum >/dev/null 2>&1; then
    sha256() { sha256sum "$@"; }
elif command -v shasum >/dev/null 2>&1; then
    sha256() { shasum -a 256 "$@"; }
else
    err "sha256sum or shasum required."; exit 1
fi

for cmd in cat openssl tar diff; do
    command -v "$cmd" >/dev/null 2>&1 || { err "'$cmd' required."; exit 1; }
done

[[ -d "$PROJECT_ROOT/.git" ]] || { err "Git repository not found."; exit 1; }

DRY_RUN=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        *) err "Unknown option: $1"; exit 1 ;;
    esac
done

PARTS=("$OUTPUT_DIR"/igbkp_*.part)
[[ -f "${PARTS[0]}" ]] || { err "Split files not found: $OUTPUT_DIR/igbkp_*.part"; exit 1; }
log "${#PARTS[@]} split files found"

MANIFEST="$OUTPUT_DIR/manifest.txt"
if [[ -f "$MANIFEST" ]]; then
    log "Verifying checksums..."
    while IFS= read -r line; do
        [[ "$line" =~ ^# ]] && continue
        [[ -z "$line" ]] && continue
        expected=$(echo "$line" | awk '{print $1}')
        filename=$(echo "$line" | awk '{print $2}')
        if [[ -f "$OUTPUT_DIR/$filename" ]]; then
            actual=$(sha256 "$OUTPUT_DIR/$filename" | awk '{print $1}')
            [[ "$expected" == "$actual" ]] || { err "Checksum mismatch: $filename"; exit 1; }
        fi
    done < "$MANIFEST"
    log "Checksums OK"
fi

echo -n "Enter decryption password: "
read -rs PASSWORD; echo

TMPDIR_WORK="$SCRIPT_DIR/.work"
rm -rf "$TMPDIR_WORK"
mkdir -p "$TMPDIR_WORK"
CLEANUP=true
trap '[[ "$CLEANUP" == true ]] && rm -rf "$TMPDIR_WORK"' EXIT

ENC_FILE="$TMPDIR_WORK/project.tar.gz.enc"
TAR_FILE="$TMPDIR_WORK/project.tar.gz"

log "Joining split files..."
cat "${PARTS[@]}" > "$ENC_FILE"

log "Decrypting..."
openssl enc -aes-256-cbc -d -salt -pbkdf2 -iter 600000 \
    -in "$ENC_FILE" -out "$TAR_FILE" -pass "fd:3" 3<<< "$PASSWORD" 2>/dev/null || \
    { err "Decryption failed."; exit 1; }

if [[ "$DRY_RUN" == true ]]; then
    log "File list (dry-run):"
    tar tzf "$TAR_FILE" | head -100
    exit 0
fi

EXTRACT_DIR="$TMPDIR_WORK/extracted"
mkdir -p "$EXTRACT_DIR"
log "Extracting..."
tar xzf "$TAR_FILE" -C "$EXTRACT_DIR" --no-same-owner 2>/dev/null || tar xzf "$TAR_FILE" -C "$EXTRACT_DIR"

echo
echo -e "${RED}This will DELETE the existing project and REPLACE with backup.${NC}"
echo -n "Continue? (yes/no): "
read -r answer
[[ "$answer" == "yes" ]] || { log "Cancelled."; exit 0; }

CLEANUP=false
cd "$PROJECT_ROOT"
TOOLKIT_NAME="$(basename "$SCRIPT_DIR")"
log "Deleting existing files (excluding $TOOLKIT_NAME/)..."
find . -mindepth 1 -maxdepth 1 -not -name "$TOOLKIT_NAME" -exec rm -rf {} +

log "Restoring..."
# v7.0: if archive contains memory/ at the root, route it to global location
# (~/.claude/projects/<path-encoded>/memory/) instead of into PROJECT_ROOT.
if [[ -d "$EXTRACT_DIR/memory" ]]; then
    PATH_ENCODED="$(echo "$PROJECT_ROOT" | tr '/' '-')"
    GLOBAL_MEM="$HOME/.claude/projects/$PATH_ENCODED/memory"
    mkdir -p "$GLOBAL_MEM"
    if cp -a "$EXTRACT_DIR/memory/." "$GLOBAL_MEM/" 2>/dev/null; then
        MEM_COUNT=$(find "$GLOBAL_MEM" -type f 2>/dev/null | wc -l | tr -d ' ')
        log "Restored global memory -> $GLOBAL_MEM ($MEM_COUNT files)"
    else
        echo -e "${YELLOW}[warn]${NC} global memory restore failed: $GLOBAL_MEM" >&2
    fi
    rm -rf "$EXTRACT_DIR/memory"
fi
cp -a "$EXTRACT_DIR"/. "$PROJECT_ROOT"/

CLEANUP=true
log "Done."
