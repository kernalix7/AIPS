#!/usr/bin/env bash
# AIPS v6.0 toolkit — copied by /aips:init to project tmp-igbkp/
###############################################################################
# smoke-test-hooks.sh — Fires each hook and verifies side-effects (v6.0).
#
# In v6.0, hooks live at GLOBAL ~/.claude/hooks/ (installed by install.sh).
# Legacy v5.x projects keep hooks at .priv-storage/.claude/hooks/.
# This script auto-detects which layout applies.
###############################################################################
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
while [[ "$PROJECT_ROOT" != "/" ]]; do
    [[ -d "$PROJECT_ROOT/.git" ]] && break
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done
cd "$PROJECT_ROOT"

QUIET=false
[[ "${1:-}" == "--quiet" ]] && QUIET=true

GREEN=''; RED=''; YELLOW=''; NC=''
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'
fi

PASS=0; FAIL=0
pass() { ((PASS++)); [[ "$QUIET" != true ]] && echo -e "${GREEN}[PASS]${NC} $*"; }
fail() { ((FAIL++)); echo -e "${RED}[FAIL]${NC} $*"; }
warn() { [[ "$QUIET" != true ]] && echo -e "${YELLOW}[WARN]${NC} $*"; }

# v6.0: prefer global hooks, fall back to per-project (v5.x layout)
GLOBAL_HOOKS_DIR="$HOME/.claude/hooks"
LOCAL_HOOKS_DIR="$PROJECT_ROOT/.priv-storage/.claude/hooks"

if [[ -d "$GLOBAL_HOOKS_DIR" ]] && ls "$GLOBAL_HOOKS_DIR"/*.sh >/dev/null 2>&1; then
    HOOKS_DIR="$GLOBAL_HOOKS_DIR"
    [[ "$QUIET" != true ]] && echo "Using GLOBAL hooks: $HOOKS_DIR"
elif [[ -d "$LOCAL_HOOKS_DIR" ]] && ls "$LOCAL_HOOKS_DIR"/*.sh >/dev/null 2>&1; then
    HOOKS_DIR="$LOCAL_HOOKS_DIR"
    [[ "$QUIET" != true ]] && echo "Using LOCAL hooks (v5.x layout): $HOOKS_DIR"
else
    fail "No hooks found in $GLOBAL_HOOKS_DIR or $LOCAL_HOOKS_DIR"
    echo "=========================================="
    echo " Hook Smoke Test (v6.0)"
    echo "=========================================="
    echo -e " ${GREEN}Pass:${NC} $PASS"
    echo -e " ${RED}Fail:${NC} $FAIL"
    exit 1
fi

SESSIONS="$PROJECT_ROOT/.priv-storage/sessions"
mkdir -p "$SESSIONS"

# Test 1: PostToolUse.sh appends to current.md
if [[ -x "$HOOKS_DIR/PostToolUse.sh" ]]; then
    BEFORE=$(wc -l < "$SESSIONS/current.md" 2>/dev/null || echo 0)
    PAYLOAD='{"tool_name":"smoke-test","tool_input":{"file_path":"smoke-test-marker.txt"}}'
    echo "$PAYLOAD" | "$HOOKS_DIR/PostToolUse.sh" >/dev/null 2>&1 || true
    AFTER=$(wc -l < "$SESSIONS/current.md" 2>/dev/null || echo 0)
    if [[ "$AFTER" -gt "$BEFORE" ]]; then
        pass "PostToolUse.sh appended to current.md ($BEFORE → $AFTER)"
        sed -i.bak '/smoke-test-marker.txt/d' "$SESSIONS/current.md" 2>/dev/null && rm -f "$SESSIONS/current.md.bak"
    else
        fail "PostToolUse.sh did not append"
    fi
else
    fail "PostToolUse.sh missing or not executable"
fi

# Test 2: SessionStart.sh produces output
if [[ -x "$HOOKS_DIR/SessionStart.sh" ]]; then
    OUT=$("$HOOKS_DIR/SessionStart.sh" 2>/dev/null)
    if [[ -n "$OUT" ]] && echo "$OUT" | grep -q "SESSION RESUME CONTEXT"; then
        pass "SessionStart.sh produced expected output"
    else
        fail "SessionStart.sh output missing 'SESSION RESUME CONTEXT'"
    fi
else
    fail "SessionStart.sh missing"
fi

# Test 3a: PreToolUse.sh blocks rm -rf /
if [[ -x "$HOOKS_DIR/PreToolUse.sh" ]]; then
    PAYLOAD='{"tool_name":"Bash","tool_input":{"command":"rm -rf /"}}'
    echo "$PAYLOAD" | "$HOOKS_DIR/PreToolUse.sh" >/dev/null 2>&1
    EC=$?
    if [[ "$EC" -eq 2 ]]; then
        pass "PreToolUse.sh correctly blocks 'rm -rf /' (exit 2)"
    else
        fail "PreToolUse.sh did not block 'rm -rf /' (exit $EC)"
    fi

    # Test 3b: allows safe ls
    PAYLOAD='{"tool_name":"Bash","tool_input":{"command":"ls -la"}}'
    echo "$PAYLOAD" | "$HOOKS_DIR/PreToolUse.sh" >/dev/null 2>&1
    EC=$?
    if [[ "$EC" -eq 0 ]]; then
        pass "PreToolUse.sh allows 'ls -la' (exit 0)"
    else
        fail "PreToolUse.sh blocked safe 'ls -la' (exit $EC)"
    fi
else
    fail "PreToolUse.sh missing"
fi

# Test 4: Stop.sh creates handoff
if [[ -x "$HOOKS_DIR/Stop.sh" ]]; then
    DATE=$(date +%Y-%m-%d)
    HANDOFF="$SESSIONS/handoff-$DATE.md"
    BACKUP=""
    [[ -f "$HANDOFF" ]] && { BACKUP="$HANDOFF.smoketest-bak"; mv "$HANDOFF" "$BACKUP"; }
    "$HOOKS_DIR/Stop.sh" >/dev/null 2>&1 || true
    if [[ -s "$HANDOFF" ]]; then
        pass "Stop.sh created $HANDOFF"
    else
        fail "Stop.sh did not create $HANDOFF"
    fi
    [[ -n "$BACKUP" ]] && mv "$BACKUP" "$HANDOFF"
fi

# Test 5: PreCompact.sh writes recovery.md (best-effort)
if [[ -x "$HOOKS_DIR/PreCompact.sh" ]]; then
    BACKUP=""
    [[ -f "$SESSIONS/recovery.md" ]] && { BACKUP="$SESSIONS/recovery.md.smoketest-bak"; mv "$SESSIONS/recovery.md" "$BACKUP"; }
    "$HOOKS_DIR/PreCompact.sh" >/dev/null 2>&1 || true
    if [[ -s "$SESSIONS/recovery.md" ]]; then
        pass "PreCompact.sh writes recovery.md"
    else
        warn "PreCompact.sh did not create recovery.md"
    fi
    [[ -n "$BACKUP" ]] && mv "$BACKUP" "$SESSIONS/recovery.md"
else
    warn "PreCompact.sh not present"
fi

echo
echo "=========================================="
echo " Hook Smoke Test (AIPS v6.0)"
echo "=========================================="
echo -e " ${GREEN}Pass:${NC} $PASS"
echo -e " ${RED}Fail:${NC} $FAIL"
echo "=========================================="
exit $(( FAIL > 0 ? 1 : 0 ))
