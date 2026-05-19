#!/usr/bin/env bash
# AIPS v6.0 toolkit — copied by /aips:init to project tmp-igbkp/
###############################################################################
# automode-validate.sh — Setup validator gate (AIPS v6.0)
#
# Strict gate that must return exit 0 for the project to be considered
# "AIPS v6.0 ready". Subset of verify-setup.sh assertions, no warnings tolerated.
# Used by /aips:doctor and CI-style preflight checks.
#
# v6.0 changes:
#   - DROPS codex-relay-* assertions (deprecated, removed from toolkit).
#   - Asserts global plugin install at ~/.claude/.
#   - Asserts minimal per-project .priv-storage/ layout (no globalized dirs).
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

GREEN=''; RED=''; NC=''
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
fi

FAIL_COUNT=0
fail() {
    ((FAIL_COUNT++))
    echo -e "${RED}[FAIL]${NC} $*" >&2
}
ok() {
    [[ "$QUIET" != true ]] && echo -e "${GREEN}[OK]${NC} $*"
}

GLOBAL="$HOME/.claude"

# ---- HARD GATES (must pass) ----

# 1. Global plugin install
[[ -d "$GLOBAL" ]] || fail "Global ~/.claude/ missing — run install.sh"
[[ -d "$GLOBAL/hooks" ]] || fail "Global ~/.claude/hooks/ missing"
[[ -d "$GLOBAL/commands" ]] || fail "Global ~/.claude/commands/ missing"

for h in SessionStart PostToolUse PreCompact Stop PreToolUse; do
    f="$GLOBAL/hooks/$h.sh"
    [[ -x "$f" ]] || fail "Global hook $h.sh missing or not executable"
done

# 2. Per-project minimal layout
[[ -d .priv-storage ]] || fail ".priv-storage/ missing — run /aips:init"
[[ -f .priv-storage/CLAUDE.md ]] || fail ".priv-storage/CLAUDE.md missing"
[[ -d .priv-storage/memory ]] || fail ".priv-storage/memory/ missing"
[[ -d .priv-storage/sessions ]] || fail ".priv-storage/sessions/ missing"
[[ -f .priv-storage/memory/MEMORY.md ]] || fail ".priv-storage/memory/MEMORY.md missing"
[[ -f .priv-storage/WORK_STATUS.md ]] || fail ".priv-storage/WORK_STATUS.md missing"

# 3. Root symlinks (CLAUDE.md, AGENTS.md, .cursorrules, WORK_STATUS.md)
for item in CLAUDE.md AGENTS.md .cursorrules WORK_STATUS.md; do
    [[ -e "$item" ]] || fail "Root symlink $item missing"
done

# 4. CLAUDE.md ↔ AGENTS.md content match
if [[ -e CLAUDE.md ]] && [[ -e AGENTS.md ]]; then
    diff -q CLAUDE.md AGENTS.md >/dev/null 2>&1 || fail "CLAUDE.md and AGENTS.md differ"
fi

# 5. .cursorrules ↔ CLAUDE.md content match
if [[ -e .priv-storage/CLAUDE.md ]] && [[ -e .priv-storage/.cursorrules ]]; then
    diff -q .priv-storage/CLAUDE.md .priv-storage/.cursorrules >/dev/null 2>&1 || \
        fail ".cursorrules out of sync with CLAUDE.md"
fi

# 6. .gitignore must block .priv-storage/ (the bare minimum)
if [[ -f .gitignore ]]; then
    grep -qFx ".priv-storage/" .gitignore || fail ".gitignore does not block .priv-storage/"
else
    fail ".gitignore missing"
fi

# 7. tmp-igbkp toolkit — v6.0 expects exactly 9 scripts, no codex-relay-*
for s in archive.sh restore.sh purge-history.sh verify-setup.sh uninstall.sh \
         smoke-test-hooks.sh secret-guard.sh automode-validate.sh setup-worktree.sh; do
    f="tmp-igbkp/$s"
    [[ -x "$f" ]] || fail "Toolkit script $f missing or not executable"
done

# 8. Legacy codex-relay scripts must be ABSENT in v6.0
for legacy in tmp-igbkp/codex-relay-check.sh tmp-igbkp/codex-relay-run.sh; do
    [[ ! -e "$legacy" ]] || fail "Legacy v5.x script $legacy present — remove for v6.0"
done

# 9. CLAUDE.md must be v6.0 shape (7-8 numbered sections, not 13)
if [[ -f .priv-storage/CLAUDE.md ]]; then
    SC=$(grep -c "^## [0-9]" .priv-storage/CLAUDE.md)
    if [[ "$SC" -lt 7 ]] || [[ "$SC" -gt 9 ]]; then
        fail "CLAUDE.md has $SC numbered sections (v6.0 expects 7-8: §1-7 + §11)"
    fi
fi

# ---- RESULT ----

if [[ "$FAIL_COUNT" -eq 0 ]]; then
    ok "AIPS v6.0 setup validated"
    exit 0
else
    echo -e "${RED}automode-validate FAILED — $FAIL_COUNT hard-gate violations${NC}" >&2
    exit 1
fi
