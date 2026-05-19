#!/usr/bin/env bash
# AIPS v6.0 toolkit — copied by /aips:init to project tmp-igbkp/
###############################################################################
# verify-setup.sh — One-shot verification of AIPS v6.0 install
#
# v6.0 layout:
#   GLOBAL  (~/.claude/)         — hooks, agents, commands, skills, statusline
#   LOCAL   (.priv-storage/)     — CLAUDE.md, WORK_STATUS.md, memory/, sessions/,
#                                  team agents (project-specific)
#
# This script asserts BOTH global plugin install AND project init are healthy.
###############################################################################
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
while [[ "$PROJECT_ROOT" != "/" ]]; do
    [[ -d "$PROJECT_ROOT/.git" ]] && break
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done
cd "$PROJECT_ROOT"

QUIET=false; JSON=false
for arg in "$@"; do
    case "$arg" in
        --quiet) QUIET=true ;;
        --json) JSON=true ;;
    esac
done

if [[ -t 1 ]] && [[ "$JSON" != true ]]; then
    GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'
else
    GREEN=''; RED=''; YELLOW=''; NC=''
fi

PASS_COUNT=0; FAIL_COUNT=0; WARN_COUNT=0

check() {
    local label="$1"; local status="$2"; local detail="${3:-}"
    case "$status" in
        OK)   ((PASS_COUNT++)); [[ "$QUIET" != true ]] && echo -e "${GREEN}[OK]${NC}    $label${detail:+ — $detail}" ;;
        FAIL) ((FAIL_COUNT++)); echo -e "${RED}[FAIL]${NC}  $label${detail:+ — $detail}" ;;
        WARN) ((WARN_COUNT++)); [[ "$QUIET" != true ]] && echo -e "${YELLOW}[WARN]${NC}  $label${detail:+ — $detail}" ;;
    esac
}

# ============================================================================
# GLOBAL plugin install (~/.claude/)
# ============================================================================

GLOBAL="$HOME/.claude"

[[ -d "$GLOBAL" ]] && check "Global ~/.claude/ exists" OK || check "Global ~/.claude/ exists" FAIL "run install.sh"

# Required global dirs
for d in "$GLOBAL/hooks" "$GLOBAL/agents" "$GLOBAL/commands" "$GLOBAL/skills" "$GLOBAL/output-styles"; do
    [[ -d "$d" ]] && check "Global dir: ${d#$HOME/}" OK || check "Global dir: ${d#$HOME/}" FAIL "missing"
done

# Required global hooks (5 hooks v6.0)
for h in SessionStart PostToolUse PreCompact Stop PreToolUse; do
    f="$GLOBAL/hooks/$h.sh"
    if [[ -x "$f" ]]; then check "Global hook: $h.sh executable" OK
    elif [[ -f "$f" ]]; then check "Global hook: $h.sh" FAIL "exists but not +x"
    else check "Global hook: $h.sh" FAIL "missing — run install.sh"
    fi
done

# Required aips-* slash commands (v6.0 expects 9)
for c in aips-init aips-update aips-verify aips-repair aips-uninstall aips-migrate aips-status aips-doctor aips-version; do
    f="$GLOBAL/commands/$c.md"
    [[ -f "$f" ]] && check "Global command: /$c" OK || check "Global command: /$c" WARN "missing (expected post-install)"
done

# Default agent templates
for agent in tech-lead explorer code-reviewer log-analyzer; do
    f="$GLOBAL/agents/$agent.md"
    [[ -f "$f" ]] && check "Global agent: $agent.md" OK || check "Global agent: $agent.md" WARN "missing"
done

# Output style + statusline
[[ -f "$GLOBAL/output-styles/terse.md" ]] && check "Global output style: terse" OK || check "Global output style: terse" WARN "missing"
[[ -x "$GLOBAL/statusline" ]] && check "Global statusline executable" OK || check "Global statusline executable" WARN "missing or not +x"

# Global plugin marker (install.sh writes a version file)
if [[ -f "$GLOBAL/AIPS_VERSION" ]]; then
    INSTALLED_VER=$(cat "$GLOBAL/AIPS_VERSION" 2>/dev/null | tr -d '[:space:]')
    check "Global plugin version: ${INSTALLED_VER:-unknown}" OK
else
    check "Global plugin version marker (~/.claude/AIPS_VERSION)" WARN "not present — install may pre-date v6.0"
fi

# agentmemory MCP plugin (global)
if command -v claude >/dev/null 2>&1; then
    if claude plugin list 2>/dev/null | grep -qi "agentmemory"; then
        check "agentmemory MCP plugin installed" OK
    else
        check "agentmemory MCP plugin" WARN "not detected via 'claude plugin list'"
    fi
else
    check "agentmemory MCP plugin" WARN "'claude' CLI not on PATH — skipped"
fi

# ============================================================================
# PROJECT init (.priv-storage/)
# ============================================================================

# Root symlinks
for item in CLAUDE.md AGENTS.md .cursorrules WORK_STATUS.md; do
    [[ -e "$item" ]] && check "Project link: $item" OK || check "Project link: $item" FAIL "missing — run /aips:init"
done

# CLAUDE.md == AGENTS.md
if [[ -e CLAUDE.md ]] && [[ -e AGENTS.md ]]; then
    if diff -q CLAUDE.md AGENTS.md >/dev/null 2>&1; then
        check "CLAUDE.md == AGENTS.md" OK
    else
        check "CLAUDE.md vs AGENTS.md" FAIL "content differs"
    fi
fi

# .cursorrules == CLAUDE.md
if [[ -e .priv-storage/CLAUDE.md ]] && [[ -e .priv-storage/.cursorrules ]]; then
    if diff -q .priv-storage/CLAUDE.md .priv-storage/.cursorrules >/dev/null 2>&1; then
        check ".cursorrules in sync with CLAUDE.md" OK
    else
        check ".cursorrules out of sync" FAIL "re-run: cp .priv-storage/CLAUDE.md .priv-storage/.cursorrules"
    fi
fi

# Project-local .priv-storage/ dirs (v6.0 minimal layout)
for d in .priv-storage .priv-storage/memory .priv-storage/sessions; do
    [[ -d "$d" ]] && check "Project dir: $d" OK || check "Project dir: $d" FAIL "missing"
done

# Project-local memory/ files
for f in .priv-storage/memory/MEMORY.md .priv-storage/memory/README.md; do
    [[ -f "$f" ]] && check "Project file: $f" OK || check "Project file: $f" FAIL "missing"
done

# CLAUDE.md sections (v6.0: 1-7 + 11 only — 8 sections)
if [[ -f .priv-storage/CLAUDE.md ]]; then
    SECTION_COUNT=$(grep -c "^## [0-9]" .priv-storage/CLAUDE.md)
    if [[ "$SECTION_COUNT" -ge 7 ]] && [[ "$SECTION_COUNT" -le 9 ]]; then
        check "CLAUDE.md sections (v6.0 expects 7-8: §1-7 + §11)" OK "found $SECTION_COUNT"
    elif [[ "$SECTION_COUNT" -ge 13 ]]; then
        check "CLAUDE.md sections" WARN "found $SECTION_COUNT — looks like v5.x layout (run /aips:migrate)"
    else
        check "CLAUDE.md sections" FAIL "found $SECTION_COUNT (expected 7-8 for v6.0)"
    fi

    SIZE=$(wc -c < .priv-storage/CLAUDE.md)
    if [[ "$SIZE" -le 8000 ]]; then
        check "CLAUDE.md token budget ($SIZE chars / 8000 cap for v6.0)" OK
    elif [[ "$SIZE" -le 16000 ]]; then
        check "CLAUDE.md token budget" WARN "$SIZE chars (>8k WARN — consider trimming)"
    else
        check "CLAUDE.md token budget" FAIL "$SIZE chars (>16k cap)"
    fi
fi

# .gitignore mandatory entries (v6.0)
if [[ -f .gitignore ]]; then
    REQUIRED_GITIGNORE=(
        ".priv-storage/" "tmp-igbkp/" ".claude/" ".codex/" ".aider*" ".continue/" ".cline/" ".roo/"
        ".mcp.json" "CLAUDE.local.md" "AGENTS.md" ".cursorrules" ".vscode/settings.json"
        "uninstall-backup-*/" "migrate-backup-*/" "reset-backup-*/" "*.bak"
    )
    for entry in "${REQUIRED_GITIGNORE[@]}"; do
        if grep -qFx "$entry" .gitignore; then
            check ".gitignore: $entry" OK
        else
            check ".gitignore: $entry" WARN "not in .gitignore (add via /aips:init)"
        fi
    done
else
    check ".gitignore" FAIL "missing"
fi

# tmp-igbkp toolkit (v6.0: 9 scripts, no codex-relay-*)
for f in tmp-igbkp/archive.sh tmp-igbkp/restore.sh tmp-igbkp/purge-history.sh \
         tmp-igbkp/setup-worktree.sh tmp-igbkp/verify-setup.sh tmp-igbkp/uninstall.sh \
         tmp-igbkp/smoke-test-hooks.sh tmp-igbkp/secret-guard.sh tmp-igbkp/automode-validate.sh \
         tmp-igbkp/README.md; do
    if [[ -e "$f" ]]; then
        if [[ "$f" == *.sh ]] && [[ ! -x "$f" ]]; then
            check "Toolkit: $f" FAIL "exists but not +x"
        else
            check "Toolkit: $f" OK
        fi
    else
        check "Toolkit: $f" FAIL "missing"
    fi
done

# Assert v5.x codex-relay scripts are GONE (v6.0 explicitly drops them)
for legacy in tmp-igbkp/codex-relay-check.sh tmp-igbkp/codex-relay-run.sh; do
    if [[ -e "$legacy" ]]; then
        check "Legacy v5.x: $legacy" WARN "should be removed in v6.0"
    fi
done

# Optional files
[[ -f .mcp.json ]] && check ".mcp.json at root" OK || check ".mcp.json at root" WARN "missing"
[[ -f CLAUDE.local.md ]] && check "CLAUDE.local.md" OK || check "CLAUDE.local.md" WARN "missing"

# Summary
echo ""
echo "=========================================="
echo " AIPS v6.0 Verification"
echo "=========================================="
echo -e " ${GREEN}Pass:${NC}  $PASS_COUNT"
echo -e " ${RED}Fail:${NC}  $FAIL_COUNT"
echo -e " ${YELLOW}Warn:${NC}  $WARN_COUNT"
echo "=========================================="
if [[ "$FAIL_COUNT" -eq 0 ]]; then
    echo -e "${GREEN}All required checks passed.${NC}"
else
    echo -e "${RED}Setup incomplete. Fix FAIL items above.${NC}"
fi

exit $(( FAIL_COUNT > 0 ? 1 : 0 ))
