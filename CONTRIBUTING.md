# Contributing

**English** | [한국어](docs/CONTRIBUTING.ko.md)

Thanks for contributing to AIPS (Claude Code plugin, v6.0+).

## Setup

```bash
git clone https://github.com/kernalix7/AIPS.git
cd AIPS
```

No build step. Plugin ships as source: `commands/`, `hooks/`, `agents/`, `skills/`, `lib/`, `templates/`, `statusline`.

## Workflow

1. Branch: `git checkout -b feature/my-change`
2. Edit the relevant area:
   - Slash commands → `commands/aips-*.md`
   - Lifecycle hooks → `hooks/`
   - Subagent templates → `agents/`
   - Per-project init payload → `templates/`
   - Helpers → `lib/` (`detect-project.sh`, `render-claude-md.sh`, `verify-init.sh`, `migrate-from-md.sh`, `setup-agentmemory-service.sh`)
   - Statusline / output style → `statusline`, `output-styles/terse.md`
3. Install from your working tree: `bash install.sh --local-source "$(pwd)"`
4. Dogfood: `mkdir -p /tmp/test-project && cd /tmp/test-project && git init && claude`, then `/aips:init`.
5. Verify: `bash lib/verify-init.sh /tmp/test-project`
6. Commit with a conventional prefix (below).
7. Open a PR against `main`. Single maintainer for now (direct push on trivial fixes); PRs welcome when external contributors arrive. No CI yet — verify locally.

## Version Bump Checklist (v6.0+)

- `.claude-plugin/plugin.json` → bump `version`
- `README.md` → update status badge
- `CHANGELOG.md` → add entry
- Tag: `git tag v6.x.y`

## Commit Convention

`feat:` / `fix:` / `refactor:` / `docs:` / `chore:`

Example: `feat(commands): add /aips:repair for broken installs`

## Doc Sync

EN/KO docs stay in lockstep. Touching `README.md`, `CONTRIBUTING.md`, `docs/ARCHITECTURE.md`, or `docs/MIGRATION-FROM-MD.md` requires updating the matching file under `docs/ko/` (or `docs/CONTRIBUTING.ko.md`) in the same PR.

## Misc

- [Code of Conduct](CODE_OF_CONDUCT.md)
- License: contributions are [MIT](LICENSE).
