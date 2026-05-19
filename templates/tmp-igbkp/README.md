# tmp-igbkp/ — AIPS project toolkit

Project-local backup, verification, and operational scripts. Copied here by `/aips:init`. Gitignored.

| Script | Purpose |
|--------|---------|
| `archive.sh` | Encrypted backup of `.priv-storage/` (AES-256-CBC + PBKDF2 600k) |
| `restore.sh` | Restore from archive |
| `purge-history.sh` | git-filter-repo wrapper for removing leaked secrets |
| `verify-setup.sh` | Health check (returns PASS/FAIL/WARN counts) |
| `uninstall.sh` | Project-local uninstall with backup |
| `smoke-test-hooks.sh` | Fire each hook with mock payload |
| `secret-guard.sh` | Pre-commit secret scanner (14 patterns) |
| `automode-validate.sh` | Setup validator gate |
| `setup-worktree.sh` | Symlink worktree to main project's `.priv-storage/` |

Globals (agentmemory, hooks, commands, agents) live at `~/.claude/` — see AIPS plugin.
