#!/usr/bin/env bash
# PreCompact.sh — Snapshots full session state before Claude compacts the context.
# AIPS v6.0 plugin-distributed hook. No-op if .priv-storage/ absent.
set -u

[[ "${HOOKS_DISABLED:-0}" == "1" ]] && exit 0

HOOK_ERRORS="$HOME/.claude/hook-errors.log"
trap 'rc=$?; [[ $rc -ne 0 ]] && printf "%s\tPreCompact.sh\trc=%d\tcmd=%s\n" "$(date -Iseconds 2>/dev/null || date)" "$rc" "${BASH_COMMAND:-?}" >> "$HOOK_ERRORS" 2>/dev/null; exit $rc' ERR

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT" 2>/dev/null || true

# Graceful degradation: AIPS not initialized in this project.
[[ -d "$PROJECT_ROOT/.priv-storage" ]] || exit 0

# v7.0 path-hash for global sessions mirror
aips_path_hash() {
    echo -n "${1:-$PROJECT_ROOT}" | md5sum | cut -c1-12
}

SESSIONS_DIR="$PROJECT_ROOT/.priv-storage/sessions"
WORK_STATUS="$PROJECT_ROOT/.priv-storage/WORK_STATUS.md"
RECOVERY="$SESSIONS_DIR/recovery.md"
CURRENT="$SESSIONS_DIR/current.md"

# v7.0: global mirror at ~/.claude/sessions/{path-hash}/ preferred, local fallback
PATH_HASH=$(aips_path_hash "$PROJECT_ROOT")
GLOBAL_SESS="$HOME/.claude/sessions/$PATH_HASH"

[[ -d "$SESSIONS_DIR" ]] || exit 0

TIMESTAMP=$(date -Iseconds 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%S%z")

{
    echo "# Pre-Compaction Recovery Snapshot"
    echo "# Saved: $TIMESTAMP"
    echo "# Reason: Claude Code is about to compact context — this file preserves full state."
    echo
    echo "## Open task list"
    cat 2>/dev/null || echo "(no task list payload received)"
    echo
    echo "## WORK_STATUS.md"
    [[ -f "$WORK_STATUS" ]] && cat "$WORK_STATUS"
    echo
    echo "## current.md tail (last 200 entries)"
    [[ -f "$CURRENT" ]] && tail -200 "$CURRENT"
    echo
    echo "## Recent git activity"
    (cd "$PROJECT_ROOT" && git status --short 2>/dev/null) || true
    echo
    (cd "$PROJECT_ROOT" && git log --oneline -10 2>/dev/null) || true
} > "$RECOVERY"

# v7.0: global mirror — copy recovery.md to ~/.claude/sessions/{path-hash}/
if [[ -n "$PROJECT_ROOT" ]] && [[ -d "$PROJECT_ROOT/.priv-storage" ]] && [[ -f "$RECOVERY" ]]; then
    mkdir -p "$GLOBAL_SESS" 2>/dev/null || true
    _aips_mirror_pre() {
        cp "$RECOVERY" "$GLOBAL_SESS/recovery.md" 2>/dev/null || true
    }
    if command -v flock >/dev/null 2>&1; then
        (flock -x -w 1 200 || exit 0; _aips_mirror_pre) 200>"$GLOBAL_SESS/.lock" 2>/dev/null || true
    else
        _aips_mirror_pre
    fi
fi

exit 0
