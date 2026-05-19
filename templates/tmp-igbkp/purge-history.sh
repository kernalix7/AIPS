#!/usr/bin/env bash
# AIPS v6.0 toolkit — copied by /aips:init to project tmp-igbkp/
set -euo pipefail

###############################################################################
# purge-history.sh — Permanently remove tmp-igbkp/ traces from git history (v6.0)
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
while [[ "$PROJECT_ROOT" != "/" ]]; do
    [[ -d "$PROJECT_ROOT/.git" ]] && break
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${GREEN}[purge]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC} $*"; }
err()  { echo -e "${RED}[error]${NC} $*" >&2; }

CONFIRM=false
PURGE_PATH="tmp-igbkp"
REMOTE="origin"
BRANCH=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --confirm) CONFIRM=true; shift ;;
        --path) PURGE_PATH="$2"; shift 2 ;;
        --remote) REMOTE="$2"; shift 2 ;;
        --branch) BRANCH="$2"; shift 2 ;;
        *) err "Unknown option: $1"; exit 1 ;;
    esac
done

cd "$PROJECT_ROOT"
[[ -z "$BRANCH" ]] && BRANCH=$(git rev-parse --abbrev-ref HEAD)

USE_FILTER_REPO=false
command -v git-filter-repo >/dev/null 2>&1 && USE_FILTER_REPO=true

COMMITS_WITH_PATH=$(git log --all --oneline -- "$PURGE_PATH" 2>/dev/null | wc -l)
[[ "$COMMITS_WITH_PATH" -gt 0 ]] || { log "'$PURGE_PATH' not in history."; exit 0; }
log "Found $COMMITS_WITH_PATH commits with '$PURGE_PATH'"

if [[ "$CONFIRM" != true ]]; then
    echo -e "${RED}WARNING: DESTRUCTIVE OPERATION${NC}"
    echo "Will remove '$PURGE_PATH' from ALL git history and force push to $REMOTE/$BRANCH"
    echo -n "Continue? (yes/no): "
    read -r answer
    [[ "$answer" == "yes" ]] || { log "Cancelled."; exit 0; }
fi

BACKUP_SHA=$(git rev-parse HEAD)
log "HEAD backup: $BACKUP_SHA"

REMOTE_URL=""
git remote get-url "$REMOTE" >/dev/null 2>&1 && REMOTE_URL=$(git remote get-url "$REMOTE")

if [[ "$USE_FILTER_REPO" == true ]]; then
    log "Using git filter-repo..."
    git filter-repo --invert-paths --path "$PURGE_PATH" --force
    [[ -n "$REMOTE_URL" ]] && git remote add "$REMOTE" "$REMOTE_URL" 2>/dev/null || true
else
    log "Using git filter-branch..."
    warn "Install git-filter-repo for better results"
    git filter-branch --force --index-filter \
        "git rm -rf --cached --ignore-unmatch '$PURGE_PATH'" \
        --prune-empty --tag-name-filter cat -- --all 2>/dev/null || { err "filter-branch failed"; exit 1; }
    rm -rf .git/refs/original/ 2>/dev/null || true
fi

if git remote get-url "$REMOTE" >/dev/null 2>&1; then
    log "Force pushing to $REMOTE/$BRANCH..."
    git push "$REMOTE" "$BRANCH" --force-with-lease 2>/dev/null || git push "$REMOTE" "$BRANCH" --force
fi

log "Done. Recovery: git reset --hard $BACKUP_SHA"
