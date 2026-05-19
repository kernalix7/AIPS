# Memory System ({{PROJECT_NAME}})

File-backed memory portable across machines. Index: `MEMORY.md`.

Memory types: `user`, `feedback`, `project`, `reference`. See `~/.claude/CLAUDE.md` Section 10 for the full protocol (globalized in v6.0).

## v7.0 — single-source memory (global)

**Per-project `.priv-storage/memory/` is DEPRECATED in v7.0.** Memory now lives at:

```
~/.claude/projects/<path-encoded>/memory/
```

where `<path-encoded>` is the absolute project path with `/` replaced by `-`.

- Existing files under `.priv-storage/memory/` are kept **read-only for backwards compat**; the v6.0 dual-write proved global storage is stable, so v7.0 drops the local copy.
- New memories save to the global path only.
- `tmp-igbkp/archive.sh` (v7.0) includes the global memory dir in the encrypted backup; `tmp-igbkp/restore.sh` extracts `memory/` back to the global location automatically.
- `lib/upgrade-to-v7.sh` performs the local drop on existing installs.

agentmemory MCP plugin (global) provides cross-project observation memory in parallel.
