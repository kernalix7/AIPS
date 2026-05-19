---
description: Rebind globalized AIPS state when project path changes (after move or rename)
allowed-tools: ["Bash", "Read", "Glob"]
---

# /aips:rebind

When v7.0 globalizes per-project state, that state is keyed by **project path hash** (`md5sum <abs-path> | cut -c1-12`) and **path-encoded directory name** (`/` → `-`). If you move or rename the project, those keys no longer match and the global state is orphaned. `/aips:rebind` moves the orphan into the new key.

## Args

```
/aips:rebind $ARGUMENTS
```

`$ARGUMENTS` = `<old-path>` (absolute). If empty, prompt the user:

```
Old project path (absolute) [default: read from .priv-storage/.aips-prev-path]: ___
```

New path is always the current `pwd`.

## What it does

For both global locations:

| Key | Path |
|-----|------|
| sessions | `~/.claude/sessions/<path-hash>/` |
| projects | `~/.claude/projects/<path-encoded>/` (includes `memory/`) |

Run rebind:

```bash
REBIND_SH="$(find ~/.claude/plugins/cache/AIPS/AIPS/lib -name rebind.sh 2>/dev/null | head -1)"
[ -z "$REBIND_SH" ] && REBIND_SH="$(find ~/.claude/plugins -name rebind.sh 2>/dev/null | head -1)"
bash "$REBIND_SH" "<old-path>" "$(pwd)"
```

The script:

1. Computes old and new `path-hash` (first 12 chars of `md5sum`) and `path-encoded` (`/` → `-`, leading `-` stripped).
2. For each location pair, if old exists and new doesn't → `mv old new`.
3. If **both** old and new exist → prompt `merge / replace / abort`.
4. If **neither** → log `nothing to rebind at <location>` and continue.
5. agentmemory rebind: best-effort via API (`memory_rebind --from <old> --to <new>`) if exposed; otherwise print a one-line manual instruction.
6. Update `.priv-storage/.aips-prev-path` ← new path (for next move).

## Output

```
[rebind] old-path        /home/user/projects/myapp
[rebind] new-path        /home/user/work/myapp
[rebind] sessions        moved 14 files: .claude/sessions/abc123… → def456…
[rebind] projects        moved 3 dirs:   .claude/projects/-home-user-projects-myapp → -home-user-work-myapp
[rebind] memory          rebind requested via agentmemory API (ok)
Rebound: 14 session files, 3 memory entries from /home/user/projects/myapp → /home/user/work/myapp
```

## Rules

- Read-only on the project itself. Only `~/.claude/` is mutated (plus optional agentmemory API call).
- Never silently overwrite — always prompt on conflict.
- Print the new path-hash and path-encoded so the user can verify against `/aips:scope` afterward.
