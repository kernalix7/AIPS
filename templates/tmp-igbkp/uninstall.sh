#!/usr/bin/env bash
# AIPS v6.0 toolkit — copied by /aips:init to project tmp-igbkp/
###############################################################################
# uninstall.sh — Safely remove AIPS from this project (backs up first) (v6.0)
#
# Project-local uninstall ONLY. Removes per-project .priv-storage/ and root
# symlinks. Does NOT touch global ~/.claude/ install (use install.sh --uninstall
# or remove ~/.claude/ manually for that).
###############################################################################
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
while [[ "$PROJECT_ROOT" != "/" ]]; do
    [[ -d "$PROJECT_ROOT/.git" ]] && break
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done
cd "$PROJECT_ROOT"

YES=false; DRY=false; CLEAN_GI=false
for arg in "$@"; do
    case "$arg" in
        --yes) YES=true ;;
        --dry-run) DRY=true ;;
        --clean-gitignore) CLEAN_GI=true ;;
    esac
done

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${GREEN}[uninstall]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC} $*"; }
err()  { echo -e "${RED}[error]${NC} $*" >&2; }

ITEMS_REMOVE=(
    .priv-storage
    CLAUDE.md AGENTS.md .cursorrules .claude .vscode WORK_STATUS.md
    .mcp.json CLAUDE.local.md
)

EXISTING=()
for item in "${ITEMS_REMOVE[@]}"; do
    if [[ -e "$item" ]] || [[ -L "$item" ]]; then
        EXISTING+=("$item")
    fi
done

if [[ ${#EXISTING[@]} -eq 0 ]]; then
    log "Nothing to uninstall."
    exit 0
fi

log "Detected AI setup items:"
for item in "${EXISTING[@]}"; do
    if [[ -L "$item" ]]; then
        echo "  - $item -> $(readlink "$item")"
    elif [[ -d "$item" ]]; then
        echo "  - $item/ ($(find "$item" -type f 2>/dev/null | wc -l) files)"
    else
        echo "  - $item"
    fi
done

if [[ "$DRY" == true ]]; then
    log "(dry-run)"
    exit 0
fi

if [[ "$YES" != true ]]; then
    echo
    echo -e "${YELLOW}This will remove the AI setup. A backup will be saved first.${NC}"
    echo -n "Continue? (yes/no): "
    read -r answer
    [[ "$answer" == "yes" ]] || { log "Cancelled."; exit 0; }
fi

TS=$(date -u +"%Y%m%d-%H%M%S")
BACKUP_DIR="$SCRIPT_DIR/uninstall-backup-$TS"
mkdir -p "$BACKUP_DIR"
log "Backing up to: $BACKUP_DIR"

for item in "${EXISTING[@]}"; do
    cp -aL "$item" "$BACKUP_DIR/" 2>/dev/null || cp -a "$item" "$BACKUP_DIR/" 2>/dev/null || true
done

{
    echo "# Uninstall Backup Manifest (AIPS v6.0)"
    echo "# Created: $(date -Iseconds 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "# Project: $(basename "$PROJECT_ROOT")"
    echo
    echo "## Items backed up"
    for item in "${EXISTING[@]}"; do echo "- $item"; done
    echo
    echo "## To restore:"
    echo "cd '$PROJECT_ROOT'"
    echo "cp -a '$BACKUP_DIR'/. ."
} > "$BACKUP_DIR/MANIFEST.md"

log "Backup complete"

log "Removing items..."
for item in "${EXISTING[@]}"; do
    if [[ -L "$item" ]]; then
        rm -f "$item"; echo "  removed symlink: $item"
    elif [[ -d "$item" ]]; then
        rm -rf "$item"; echo "  removed dir: $item/"
    else
        rm -f "$item"; echo "  removed file: $item"
    fi
done

GLOBAL_MEM="$HOME/.claude/projects/$(echo "$PROJECT_ROOT" | tr '/' '-')/memory"
if [[ -d "$GLOBAL_MEM" ]] && [[ "$YES" != true ]]; then
    echo
    echo -n "Also remove global memory at $GLOBAL_MEM? (yes/no): "
    read -r answer
    if [[ "$answer" == "yes" ]]; then
        cp -a "$GLOBAL_MEM" "$BACKUP_DIR/global-memory" 2>/dev/null || true
        rm -rf "$GLOBAL_MEM"
        log "Global memory removed"
    fi
fi

if [[ "$CLEAN_GI" == true ]] && [[ -f .gitignore ]]; then
    log "Cleaning .gitignore..."
    cp .gitignore "$BACKUP_DIR/.gitignore.bak"
    grep -vE '^(\.priv-storage/|CLAUDE\.md|AGENTS\.md|\.cursorrules|\.claude$|\.vscode$|WORK_STATUS\.md|CLAUDE\.local\.md|tmp-igbkp/\.work/|tmp-igbkp/output/)$' .gitignore > .gitignore.tmp || true
    mv .gitignore.tmp .gitignore
fi

echo
echo "=========================================="
echo " Uninstall Complete (AIPS v6.0)"
echo "=========================================="
echo " Backup:  $BACKUP_DIR"
echo " Restore: cp -a '$BACKUP_DIR'/. '$PROJECT_ROOT'/"
echo
echo " NOTE: Global AIPS install (~/.claude/) untouched."
echo " To remove globals: rm -rf ~/.claude/{hooks,commands/aips-*,agents/aips-*}"
echo "=========================================="
