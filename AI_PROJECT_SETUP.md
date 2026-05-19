# AI Project Setup — DEPRECATED (v6.0)

**This file is deprecated as of v6.0.** AIPS is now a Claude Code plugin distribution.

## New install (one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/kernalix7/AIPS/main/install.sh | bash
```

After install, in each project:

```bash
$ cd your-project && claude
> /aips:init
```

`/aips:init` auto-detects: fresh project / v5.x migration / re-init / repair.

## Migrating from v5.x

Existing `.priv-storage/AI_PROJECT_SETUP.md` (v5.x) installs auto-migrate on first `/aips:init`:

1. Backup → `tmp-igbkp/migrate-backup-{date}/`
2. Remove globalized files (hooks/agents/commands/skills/output-styles/statusline → `~/.claude/`)
3. Remove deprecated Codex relay (`/codex-brief`, `tmp-igbkp/codex-relay-*.sh`, etc.)
4. Slim per-project `CLAUDE.md` (Sections 8/9/10/12/13 → global ref)
5. Preserve: Section 1-7+11, `WORK_STATUS.md`, `memory/`, `sessions/`, `.mcp.json`, `tmp-igbkp/` (9 toolkit scripts)

Single confirm prompt. Idempotent.

## Documentation

- README: <https://github.com/kernalix7/AIPS>
- Korean: <https://github.com/kernalix7/AIPS/blob/main/docs/README.ko.md>
- Migration: <https://github.com/kernalix7/AIPS/blob/main/docs/MIGRATION-FROM-MD.md>
- Architecture: <https://github.com/kernalix7/AIPS/blob/main/docs/ARCHITECTURE.md>

## v5.x compatibility

This file used to host the v5.x self-update protocol. v5.x projects fetching this raw URL will see only this page from v6.0 onwards — there is no v5.3 or further v5.x release. The new path is `install.sh` + `/aips:init` above.

For users who specifically need the v5.2 bootstrap markdown (historical reference), check the git tag `v5.2`:
<https://raw.githubusercontent.com/kernalix7/AIPS/v5.2/AI_PROJECT_SETUP.md>

---

**Last Updated**: 2026-05-19 — v6.0 plugin transition.
