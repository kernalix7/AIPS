#!/usr/bin/env bash
# AIPS v6.0 toolkit — copied by /aips:init to project tmp-igbkp/
# setup-worktree.sh — Bridge git worktree to main project's AI tooling.
set -uo pipefail

GIT_DIR=$(git rev-parse --git-dir 2>/dev/null) || { echo "Not in a git repo."; exit 1; }
GIT_COMMON_DIR=$(git rev-parse --git-common-dir 2>/dev/null) || GIT_COMMON_DIR="$GIT_DIR"

if [[ "$GIT_DIR" == "$GIT_COMMON_DIR" ]]; then
    echo "Not in a worktree — this is the main project. Nothing to do."
    exit 0
fi

WORKTREE_ROOT=$(pwd)
MAIN_PROJECT_ROOT=$(cd "$(dirname "$GIT_COMMON_DIR")" && pwd)

if [[ "$WORKTREE_ROOT" == "$MAIN_PROJECT_ROOT" ]]; then
    echo "Worktree resolves to main — aborting."
    exit 1
fi

MAIN_PRIV="$MAIN_PROJECT_ROOT/.priv-storage"
[[ -d "$MAIN_PRIV" ]] || { echo "FAIL: Main project has no .priv-storage/"; exit 1; }

echo "Worktree:     $WORKTREE_ROOT"
echo "Main project: $MAIN_PROJECT_ROOT"
echo

for LINK in CLAUDE.md AGENTS.md .cursorrules .claude .vscode WORK_STATUS.md; do
    case "$LINK" in
        AGENTS.md|CLAUDE.md) TARGET="$MAIN_PRIV/CLAUDE.md" ;;
        .cursorrules)        TARGET="$MAIN_PRIV/.cursorrules" ;;
        .claude)             TARGET="$MAIN_PRIV/.claude" ;;
        .vscode)             TARGET="$MAIN_PRIV/.vscode" ;;
        WORK_STATUS.md)      TARGET="$MAIN_PRIV/WORK_STATUS.md" ;;
    esac

    [[ -e "$TARGET" ]] || { echo "  SKIP: $LINK ($TARGET missing)"; continue; }

    if [[ -L "$WORKTREE_ROOT/$LINK" ]]; then
        EXISTING=$(readlink "$WORKTREE_ROOT/$LINK")
        if [[ "$EXISTING" == "$TARGET" ]] || [[ "$(realpath "$WORKTREE_ROOT/$LINK")" == "$(realpath "$TARGET")" ]]; then
            echo "  OK:   $LINK (already linked)"
            continue
        fi
        rm "$WORKTREE_ROOT/$LINK"
    elif [[ -e "$WORKTREE_ROOT/$LINK" ]]; then
        mv "$WORKTREE_ROOT/$LINK" "$WORKTREE_ROOT/${LINK}.worktree-bak"
    fi

    ln -s "$TARGET" "$WORKTREE_ROOT/$LINK"
    echo "  LINK: $LINK → $TARGET"
done

echo
echo "Done."
