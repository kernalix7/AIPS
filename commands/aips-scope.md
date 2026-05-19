---
description: Diagnose this project's globalized vs per-project AIPS state
allowed-tools: ["Bash", "Read", "Grep", "Glob"]
---

# /aips:scope

Print a per-file scope table showing what lives **globally** (shared across all projects), what is **globalized for this project** (keyed by path), and what stays **per-project** (committed or in `.priv-storage/`). Flags legacy v6.0 artifacts that should be migrated via `/aips:upgrade --to v7.0`.

## Args

```
/aips:scope $ARGUMENTS
```

`$ARGUMENTS` = optional `<project_root>` (default: `pwd`).

## What it does

```bash
SCOPE_SH="$(find ~/.claude/plugins/cache/AIPS/AIPS/lib -name scope.sh 2>/dev/null | head -1)"
[ -z "$SCOPE_SH" ] && SCOPE_SH="$(find ~/.claude/plugins -name scope.sh 2>/dev/null | head -1)"
bash "$SCOPE_SH" "${ARGUMENTS:-$(pwd)}"
```

The script emits a 4-column table:

```
FILE/DIR                                          SCOPE       SIZE      MTIME
```

Grouped into the sections below.

### Sections

1. **Global** (shared, version-controlled by the plugin)
   - `~/.claude/plugins/cache/AIPS/`
   - `~/.claude/hooks/`
   - `~/.claude/agents/`
   - `~/.claude/commands/`
   - `~/.claude/skills/`
   - `~/.claude/output-styles/`
   - `~/.claude/statusline`
   - `~/.local/bin/aips-*`

2. **Globalized state for this project** (path-keyed)
   - `~/.claude/sessions/<path-hash>/`
   - `~/.claude/projects/<path-encoded>/memory/`

3. **Per-project** (lives in repo or `.priv-storage/`)
   - `.priv-storage/CLAUDE.md`
   - `.priv-storage/WORK_STATUS.md`
   - `.priv-storage/.mcp.json`
   - `.priv-storage/.claude/agents/tech-lead.md` and `*-team.md`
   - `tmp-igbkp/` backup output

4. **Legacy v6.0 — should be globalized via `/aips:upgrade --to v7.0`** (warning lines, prefixed `[legacy]`)
   - `.priv-storage/.claude/{hooks,skills,output-styles,statusline}`
   - Per-project AIPS block in `.gitignore`
   - `.priv-storage/memory/*` (when no global mirror exists)
   - `.priv-storage/sessions/*` (when no global mirror exists)

### Summary

```
AIPS version:        7.0    (from .priv-storage/.aips-version)
path hash:           ab12cd34ef56
path encoded:        -home-user-projects-myapp
scope split:         globalized 70%   per-project 30%   legacy 0%
total tracked files: N
```

## Rules

- Read-only. Never mutates anything.
- Missing entries are shown as `(absent)` — they are normal for sections the user hasn't populated.
- Legacy warnings only fire when both per-project artifact exists **and** no global mirror is found.
