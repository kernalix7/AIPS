#!/usr/bin/env bash
# scope.sh — diagnose globalized vs per-project AIPS state for one project.
# Args: [<project_root>]   (default: pwd)
set -euo pipefail

PROJECT_ROOT="${1:-$(pwd)}"
PROJECT_ROOT="$(cd "$PROJECT_ROOT" 2>/dev/null && pwd || echo "$PROJECT_ROOT")"

path_hash()    { printf '%s' "$1" | md5sum | cut -c1-12; }
path_encoded() { printf '%s' "$1" | sed 's|/|-|g; s|^-||'; }
PHASH="$(path_hash "$PROJECT_ROOT")"
PENC="$(path_encoded "$PROJECT_ROOT")"

# --- counters for summary -------------------------------------------------
G_COUNT=0
S_COUNT=0
P_COUNT=0
L_COUNT=0

# --- helpers --------------------------------------------------------------
human_size() {
  local p="$1"
  [ -e "$p" ] || { printf -- '-'; return; }
  du -sh "$p" 2>/dev/null | awk '{print $1}'
}
mtime_of() {
  local p="$1"
  [ -e "$p" ] || { printf -- '-'; return; }
  # GNU date works on Linux; macOS users have BSD stat but this is a Linux project.
  date -d "@$(stat -c %Y "$p" 2>/dev/null || echo 0)" '+%Y-%m-%d' 2>/dev/null || echo '-'
}

row() {
  # row <path-display> <scope> <count-var>
  local p="$1" scope="$2" cv="$3"
  local size mt mark
  if [ -e "$p" ]; then
    size="$(human_size "$p")"
    mt="$(mtime_of "$p")"
    mark=""
    eval "$cv=\$((\$$cv + 1))"
  else
    size="-"; mt="-"; mark="  (absent)"
  fi
  printf '  %-58s  %-10s  %-8s  %s%s\n' "${p/#$HOME/~}" "$scope" "$size" "$mt" "$mark"
}

hdr() {
  printf '\n=== %s ===\n' "$1"
  printf '  %-58s  %-10s  %-8s  %s\n' "FILE/DIR" "SCOPE" "SIZE" "MTIME"
}

# --- header ---------------------------------------------------------------
echo "[scope] project: $PROJECT_ROOT"
echo "[scope] path-hash:    $PHASH"
echo "[scope] path-encoded: $PENC"

# --- 1. Global ------------------------------------------------------------
hdr "Global (shared across all projects)"
for p in \
  "$HOME/.claude/plugins/cache/AIPS" \
  "$HOME/.claude/hooks" \
  "$HOME/.claude/agents" \
  "$HOME/.claude/commands" \
  "$HOME/.claude/skills" \
  "$HOME/.claude/output-styles" \
  "$HOME/.claude/statusline"
do
  row "$p" "global" G_COUNT
done
# wildcard: ~/.local/bin/aips-*
if compgen -G "$HOME/.local/bin/aips-*" >/dev/null 2>&1; then
  for p in "$HOME"/.local/bin/aips-*; do
    row "$p" "global" G_COUNT
  done
else
  row "$HOME/.local/bin/aips-*" "global" G_COUNT
fi

# --- 2. Globalized state for this project ---------------------------------
hdr "Globalized state for this project (path-keyed)"
row "$HOME/.claude/sessions/$PHASH"          "globalized" S_COUNT
row "$HOME/.claude/projects/$PENC/memory"    "globalized" S_COUNT

# --- 3. Per-project -------------------------------------------------------
hdr "Per-project (lives in repo or .priv-storage/)"
for p in \
  "$PROJECT_ROOT/.priv-storage/CLAUDE.md" \
  "$PROJECT_ROOT/.priv-storage/WORK_STATUS.md" \
  "$PROJECT_ROOT/.priv-storage/.mcp.json"
do
  row "$p" "local" P_COUNT
done
# agents (tech-lead + *-team)
AGENTS_DIR="$PROJECT_ROOT/.priv-storage/.claude/agents"
if [ -d "$AGENTS_DIR" ]; then
  for p in "$AGENTS_DIR"/tech-lead.md "$AGENTS_DIR"/*-team.md; do
    [ -e "$p" ] || continue
    row "$p" "local" P_COUNT
  done
else
  row "$AGENTS_DIR/tech-lead.md" "local" P_COUNT
fi
row "$PROJECT_ROOT/tmp-igbkp" "local" P_COUNT

# --- 4. Legacy v6.0 warnings ---------------------------------------------
hdr "Legacy v6.0 (warn — run /aips:upgrade --to v7.0)"
legacy_check() {
  local local_path="$1" mirror_path="$2" label="$3"
  if [ -e "$local_path" ] && [ ! -e "$mirror_path" ]; then
    printf '  [legacy] %-50s  no global mirror at %s\n' "${local_path/#$PROJECT_ROOT/.}" "${mirror_path/#$HOME/~}"
    L_COUNT=$((L_COUNT + 1))
  fi
}
for sub in hooks skills output-styles statusline; do
  legacy_check "$PROJECT_ROOT/.priv-storage/.claude/$sub" "$HOME/.claude/$sub" "$sub"
done
# AIPS block in gitignore
if [ -f "$PROJECT_ROOT/.gitignore" ] && grep -q '^# === AIPS v6.0 ===' "$PROJECT_ROOT/.gitignore" 2>/dev/null; then
  printf '  [legacy] %-50s  per-project AIPS v6.0 block present\n' ".gitignore"
  L_COUNT=$((L_COUNT + 1))
fi
# memory / sessions without global mirror
[ -d "$PROJECT_ROOT/.priv-storage/memory" ] && [ -n "$(ls -A "$PROJECT_ROOT/.priv-storage/memory" 2>/dev/null)" ] && \
  legacy_check "$PROJECT_ROOT/.priv-storage/memory" "$HOME/.claude/projects/$PENC/memory" "memory"
[ -d "$PROJECT_ROOT/.priv-storage/sessions" ] && [ -n "$(ls -A "$PROJECT_ROOT/.priv-storage/sessions" 2>/dev/null)" ] && \
  legacy_check "$PROJECT_ROOT/.priv-storage/sessions" "$HOME/.claude/sessions/$PHASH" "sessions"

if [ "$L_COUNT" -eq 0 ]; then
  echo "  (none — project is clean)"
fi

# --- 5. Summary -----------------------------------------------------------
VER="unknown"
[ -f "$PROJECT_ROOT/.priv-storage/.aips-version" ] && VER="$(tr -d '[:space:]' < "$PROJECT_ROOT/.priv-storage/.aips-version")"

TOTAL=$((G_COUNT + S_COUNT + P_COUNT))
[ "$TOTAL" -eq 0 ] && TOTAL=1   # avoid div-by-zero
GLOBAL_PCT=$(( (G_COUNT + S_COUNT) * 100 / TOTAL ))
LOCAL_PCT=$(( P_COUNT * 100 / TOTAL ))
LEGACY_PCT=$(( L_COUNT * 100 / TOTAL ))

printf '\n=== Summary ===\n'
printf '  AIPS version:        %s\n' "$VER"
printf '  path hash:           %s\n' "$PHASH"
printf '  path encoded:        %s\n' "$PENC"
printf '  scope split:         globalized %d%%   per-project %d%%   legacy %d%%\n' "$GLOBAL_PCT" "$LOCAL_PCT" "$LEGACY_PCT"
printf '  tracked files:       global=%d  globalized=%d  local=%d  legacy=%d\n' "$G_COUNT" "$S_COUNT" "$P_COUNT" "$L_COUNT"
