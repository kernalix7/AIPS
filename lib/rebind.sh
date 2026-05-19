#!/usr/bin/env bash
# rebind.sh — move globalized AIPS state from old project path to new project path.
# Args: <old-path> [<new-path>]   (new defaults to pwd)
set -euo pipefail

OLD="${1:-}"
NEW="${2:-$(pwd)}"

if [ -z "$OLD" ]; then
  echo "[rebind] ERROR: <old-path> required" >&2
  echo "usage: rebind.sh <old-path> [<new-path>]" >&2
  exit 2
fi

# Normalize (don't require old path to still exist on disk)
case "$OLD" in /*) ;; *) OLD="$(pwd)/$OLD" ;; esac
NEW="$(cd "$NEW" 2>/dev/null && pwd || echo "$NEW")"

path_hash()    { printf '%s' "$1" | md5sum | cut -c1-12; }
path_encoded() { printf '%s' "$1" | sed 's|/|-|g; s|^-||'; }

OHASH="$(path_hash "$OLD")"
NHASH="$(path_hash "$NEW")"
OENC="$(path_encoded "$OLD")"
NENC="$(path_encoded "$NEW")"

echo "[rebind] old-path        $OLD"
echo "[rebind] new-path        $NEW"
echo "[rebind] old hash/enc    $OHASH  /  $OENC"
echo "[rebind] new hash/enc    $NHASH  /  $NENC"

SESS_COUNT=0
MEM_COUNT=0

# Conflict handler: returns merge|replace|abort (interactive)
resolve_conflict() {
  local label="$1" old_path="$2" new_path="$3"
  echo "[rebind] CONFLICT at $label:" >&2
  echo "  old: $old_path" >&2
  echo "  new: $new_path (already exists)" >&2
  printf '  choose [merge/replace/abort] (default: abort): '
  read -r ans
  case "${ans:-abort}" in
    merge|m)   echo merge ;;
    replace|r) echo replace ;;
    *)         echo abort ;;
  esac
}

# Move one pair (old → new) given a category label.
move_pair() {
  local label="$1" old_path="$2" new_path="$3"
  if [ ! -e "$old_path" ] && [ ! -e "$new_path" ]; then
    echo "[rebind] $label         nothing to rebind at $old_path"
    return 0
  fi
  if [ ! -e "$old_path" ]; then
    echo "[rebind] $label         (no old state; new already at $new_path)"
    return 0
  fi
  if [ -e "$new_path" ]; then
    decision="$(resolve_conflict "$label" "$old_path" "$new_path")"
    case "$decision" in
      abort)
        echo "[rebind] $label         aborted by user; old left in place" >&2
        return 0
        ;;
      replace)
        rm -rf "$new_path"
        mv "$old_path" "$new_path"
        ;;
      merge)
        # copy contents from old into new, then drop old
        mkdir -p "$new_path"
        cp -an "$old_path"/. "$new_path"/ 2>/dev/null || true
        rm -rf "$old_path"
        ;;
    esac
  else
    mkdir -p "$(dirname "$new_path")"
    mv "$old_path" "$new_path"
  fi
  # count files moved into the new location (post-condition)
  local n
  n=$(find "$new_path" -type f 2>/dev/null | wc -l | tr -d ' ')
  if [ "$label" = "sessions" ]; then SESS_COUNT="$n"; fi
  if [ "$label" = "projects" ]; then MEM_COUNT="$n"; fi
  echo "[rebind] $label         moved → $new_path ($n files)"
}

# sessions
move_pair "sessions" "$HOME/.claude/sessions/$OHASH" "$HOME/.claude/sessions/$NHASH"

# projects (memory lives under projects/<encoded>/memory)
move_pair "projects" "$HOME/.claude/projects/$OENC" "$HOME/.claude/projects/$NENC"

# agentmemory best-effort rebind
if command -v claude >/dev/null 2>&1; then
  if claude --print "/agentmemory rebind --from '$OLD' --to '$NEW'" >/dev/null 2>&1; then
    echo "[rebind] memory          rebind requested via agentmemory API (ok)"
  else
    echo "[rebind] memory          agentmemory API rebind unavailable — manually run: /agentmemory rebind --from '$OLD' --to '$NEW'"
  fi
else
  echo "[rebind] memory          claude CLI not found — manual step required for agentmemory"
fi

# bookkeeping: store previous path so next /aips:rebind has a default
if [ -d "$NEW/.priv-storage" ]; then
  printf '%s\n' "$NEW" > "$NEW/.priv-storage/.aips-prev-path"
fi

echo "Rebound: ${SESS_COUNT} session files, ${MEM_COUNT} memory entries from $OLD → $NEW"
