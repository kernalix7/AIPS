<div align="center">

# AIPS

### Stop re-doing AI setup every project.

<p><b>AIPS v7.0</b> is a Claude Code plugin with a <b>hybrid global-first</b> architecture. One install scatters smart globals across <code>~/.claude/</code>. Each <code>/aips:init</code> plants just enough per-project to keep your team in sync — agent rules, work state, MCP config, encrypted backups. Hooks survive crashes. Memory survives <code>/clear</code>. Sessions survive a project rename.</p>

<pre><code># Once per machine — install
curl -fsSL https://raw.githubusercontent.com/kernalix7/AIPS/main/install.sh | bash

# Once per project
cd my-project && claude
> /aips:init

# Uninstall (interactive, safe by default — see flags below)
curl -fsSL https://raw.githubusercontent.com/kernalix7/AIPS/main/uninstall.sh | bash
</code></pre>

<sub>Uninstall flags: <code>--purge</code> (configs + deps + RTK) · <code>--remove-data</code> (sessions + memory + agentmemory db) · <code>--all</code> (everything) · <code>--dry-run</code> · <code>--yes</code>. Default is safest — only the AIPS plugin and <code>aips-*</code> symlinks are removed; every other category asks per-path before deletion.</sub>

[![Status](https://img.shields.io/badge/v7.0.0-stable-2EA44F?style=for-the-badge)](CHANGELOG.md)
[![Released](https://img.shields.io/badge/released-2026--05--19-2962FF?style=for-the-badge)](CHANGELOG.md)

[![license](https://img.shields.io/github/license/kernalix7/AIPS?style=flat-square&color=blue)](LICENSE)
[![plugin](https://img.shields.io/badge/Claude%20Code-plugin-7C3AED?style=flat-square&logo=anthropic&logoColor=white)](https://claude.com/claude-code)
[![commands](https://img.shields.io/badge/slash%20commands-11-2EA44F?style=flat-square)](#slash-commands)
[![deps](https://img.shields.io/badge/bundled%20plugins-4-blue?style=flat-square)](#what-lands-where)
[![stars](https://img.shields.io/github/stars/kernalix7/AIPS?style=flat-square&color=FFD93D&logo=github&logoColor=white)](https://github.com/kernalix7/AIPS/stargazers)
[![PRs](https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square)](CONTRIBUTING.md)

###### Works with

[![Claude Code](https://img.shields.io/badge/Claude%20Code-2.0%2B-7C3AED?style=flat-square&logo=anthropic&logoColor=white)](https://claude.com/claude-code)
[![Codex CLI](https://img.shields.io/badge/Codex%20CLI-0.10%2B-10B981?style=flat-square&logo=openai&logoColor=white)](https://github.com/openai/codex)
[![Cursor](https://img.shields.io/badge/Cursor-0.40%2B-000000?style=flat-square&logo=cursor&logoColor=white)](https://cursor.sh)
[![GitHub Copilot](https://img.shields.io/badge/Copilot-1.150%2B-24292F?style=flat-square&logo=githubcopilot&logoColor=white)](https://github.com/features/copilot)
[![MCP](https://img.shields.io/badge/MCP-aware-FF6B6B?style=flat-square)](https://modelcontextprotocol.io)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](#)
[![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white)](#)
[![Windows](https://img.shields.io/badge/Windows-Git%20Bash-0078D6?style=flat-square&logo=windows&logoColor=white)](#)

<sub>**English** &nbsp;·&nbsp; [한국어](docs/README.ko.md) &nbsp;·&nbsp; [install.sh](install.sh) &nbsp;·&nbsp; [Contributing](CONTRIBUTING.md) &nbsp;·&nbsp; [Security](SECURITY.md) &nbsp;·&nbsp; [Changelog](CHANGELOG.md)</sub>

</div>

---

### Status: v7.0.0 stable — shipped 2026-05-19

AIPS v7.0 is the current, supported release. The 11 `/aips:*` slash commands, hybrid global-first layout, 4 bundled plugins, and 3-line statusline are all in place and tested on Linux, macOS, and Git Bash / WSL. If you're already running v6.0, migration is one command (`/aips:upgrade --to v7.0`) and the strict mode result is byte-identical to a fresh v7.0 install.

---

## Table of contents

- [Why this exists](#why-this-exists)
- [Quick start](#quick-start)
- [What lands where](#what-lands-where)
- [Lifecycle](#lifecycle)
- [Statusline](#statusline)
- [Slash commands](#slash-commands)
- [Migration](#migration)
- [Supported AI tools](#supported-ai-tools)
- [Comparison](#comparison)
- [Documentation](#documentation)
- [FAQ](#faq)
- [Roadmap](#roadmap)
- [Star history](#star-history)
- [Support](#support)
- [License](#license)

---

## Why this exists

You've been here before:

- Cloned a fresh repo, then spent an hour re-wiring `CLAUDE.md`, `.cursorrules`, `AGENTS.md`, the same 4 hooks, the same 9 backup scripts.
- Lost a 2-hour session to a `/clear` because nobody wrote a handoff.
- Re-installed RTK and caveman on a new laptop and forgot which order matters.
- Watched the AI burn 25k tokens reading a setup doc before doing actual work.
- Renamed a project directory and watched session history evaporate.

AIPS v7.0 fixes all of that with a single principle: **state that should be global, lives global. State that should be local, lives local. Nothing duplicated.**

| Without AIPS | With AIPS v7 |
|---|---|
| Hand-write CLAUDE.md from scratch — hours | `/aips:init` — ~30 seconds |
| Hooks, agents, statusline copied per project | Once per machine in `~/.claude/`, every project inherits |
| Session lost on crash / compact / `/clear` | 3-tier autosave (current / handoff / recovery) reloaded on next start |
| Memory tied to one repo path | Path-hash-keyed in `~/.claude/projects/`, survives renames via `/aips:rebind` |
| 22-line `.gitignore` block in every repo | One block in `~/.config/git/ignore`, every repo gets it free |
| AI reads a 7,600-line setup doc each session | AI reads a ~150-line CLAUDE.md; the rest is shell-level deterministic |

---

## Quick start

**Once per machine** — runs for every project you'll ever open:

```bash
curl -fsSL https://raw.githubusercontent.com/kernalix7/AIPS/main/install.sh | bash
```

What `install.sh` does:

1. Registers the AIPS marketplace in `~/.claude/`
2. Installs / updates **4 bundled plugins**:
   - **codex-plugin-cc** — `/codex:*` commands (Claude ↔ Codex relay)
   - **caveman** — ultra-terse output style + `/caveman*` commands
   - **agentmemory** + systemd unit — file-backed memory + auto-backup
   - **RTK** (Rust Token Killer) — 60–90% token savings CLI proxy
3. Drops hooks / agents / commands / skills / output-styles / statusline into `~/.claude/`
4. Globalizes toolkit scripts (`~/.local/bin/aips-*`) and the AIPS gitignore block (`~/.config/git/ignore`)

**Per project**:

```bash
cd my-project
claude
> /aips:init
```

`/aips:init` auto-detects 4 cases:

| Case | Trigger | Action |
|---|---|---|
| **A. Fresh** | No `.priv-storage/`, no v5.x `.md` | Fresh init (~30 sec) |
| **B. v5.x migrate** | Root `AI_PROJECT_SETUP.md` detected | Confirm → backup → cleanup → v7.0 init |
| **C. Re-init (idempotent)** | `.priv-storage/` v7.0 marker present | Drift repair, no destructive ops |
| **D. Repair** | Broken / partial state detected | Repair mode with selective rebuild |

Done. Every artifact is gitignored — your git history stays clean. Verify any time with `/aips:health`.

---

## What lands where

v7.0 keeps a clean split: smart globals once per machine, minimum-viable per-project state per repo. Nothing is duplicated.

### Global — `~/.claude/` + `~/.local/bin/` + `~/.config/git/ignore`

Installed once by `install.sh`. Every project inherits.

| Category | Contents |
|---|---|
| Plugins | 4 bundled: `codex-plugin-cc`, `caveman`, `agentmemory` (+ systemd unit), `RTK` |
| Hooks | 5: `PreToolUse`, `PostToolUse`, `SessionStart`, `PreCompact`, `Stop` |
| Agents | 3 templates: `tech-lead`, `explorer`, `code-reviewer` |
| Commands | 15: 11 `/aips:*` + bundled plugin commands |
| Skills | On-demand knowledge modules (caveman, codex, etc.) |
| Output styles | `terse` (default), `caveman/full`, `caveman/ultra`, etc. |
| Statusline | 3-line multi-line (preview below) |
| Binaries | RTK Rust binary (`~/.local/bin/rtk`), aips-* toolkit symlinks |
| Daemons | agentmemory systemd unit (user-level) |
| Sessions mirror | `~/.claude/sessions/{path-hash}/` — survives project renames |
| Memory store | `~/.claude/projects/{path-encoded}/memory/` — single source of truth |
| Gitignore block | `~/.config/git/ignore` — 22 entries, zero per-repo noise |

### Per-project — `.priv-storage/` (`/aips:init`)

```text
your-project/
|-- CLAUDE.md              -> .priv-storage/CLAUDE.md  (symlink)
|-- AGENTS.md              -> .priv-storage/CLAUDE.md  (symlink, Codex / Copilot)
|-- .cursorrules           -> .priv-storage/CLAUDE.md  (symlink, Cursor)
|-- WORK_STATUS.md         -> .priv-storage/WORK_STATUS.md
|
|-- .priv-storage/         [gitignored] per-project AI state
|   |-- CLAUDE.md                   # Sections 1-7 + 11 only, ~150 lines
|   |-- CLAUDE.local.md             # per-developer overrides
|   |-- WORK_STATUS.md              # team-shared task state
|   |-- sessions/                   # fast-write buffer; mirrored globally
|   |-- agents/                     # tech-lead.md + per-team agents
|   `-- .mcp.json                   # project-specific MCP server registry
|
`-- tmp-igbkp/             [gitignored] encrypted backup outputs only
    `-- (archives produced by aips-archive, aips-restore, aips-purge-history)
```

> Only `WORK_STATUS.md`, GitHub standard files, the `docs/` Korean mirrors, and `.github/` get committed. Everything in `.priv-storage/` and `tmp-igbkp/` is gitignored on purpose. `CLAUDE.md` keeps Sections **1–7 + 11** (~150 lines) — Sections 8/9/10/12/13 moved into the global plugin / skill / hook layer.

### Why this split

| Item | Lives | Why |
|---|---|---|
| Toolkit scripts (`aips-archive`, `aips-restore`, etc.) | global | One canonical copy, no per-project drift, single PATH lookup |
| Sessions mirror | global (project keeps fast-write buffer) | Survives project-dir renames, cross-machine via single dir |
| Memory store | global only | Single source of truth, no dual-write drift |
| `.gitignore` AIPS block | global | Zero-noise project gitignore; works across all repos automatically |
| `CLAUDE.md` Sections 1–7 + 11 | per-project | Team-shared project rules; multi-tool guarantee |
| `WORK_STATUS.md` | per-project | Team-shared task state — must live in the repo |
| `.mcp.json` | per-project | Project-specific MCP server registry |
| `tech-lead.md` + team agents | per-project | Per-project team composition |
| `tmp-igbkp/` backup outputs | per-project | Encrypted archives belong with the project they back up |

---

## Lifecycle

```text
[1. Global install] (once per machine)
  curl ... | bash
  - Register AIPS marketplace → ~/.claude/
  - Install/update 4 bundled plugins
  - Drop hooks/agents/commands/skills/output-styles/statusline
  - Globalize toolkit (~/.local/bin/aips-*) + gitignore block
  - Install RTK binary, agentmemory systemd unit
        |
        v
[2. Project init] (once per project, ~30 sec)
  cd project && claude → /aips:init
  - Auto-branch A/B/C/D
  - Create .priv-storage/, drop 3 symlinks
  - CLAUDE.md Sections 1-7 + 11 (~150 lines)
  - Register project with global sessions mirror + memory store
        |
        v
[3. Normal session]
  - SessionStart hook auto-injects prior handoff + current.md tail
  - AI reads only CLAUDE.md (~150 lines) — no 7,600-line .md
  - PreToolUse blocks dangerous commands + oversized reads
  - PostToolUse appends current.md + dual-writes to agentmemory
  - Stop hook writes handoff-{date}.md
  - PreCompact hook writes recovery.md (best-effort)
  - 3-line statusline updates live: project / windows / savings
        |
        v
[4. Crash / rate-limit / /clear / rename]
  - Next session, SessionStart auto-loads handoff + recovery
  - AI resumes prior state without asking "where were we?"
  - Renamed project? `/aips:rebind <old-path>` rewires globals
        |
        v
[5. Updates] (trigger: /aips:update)
  - marketplace pull → update 4 bundled plugins
  - Global hooks/commands auto-sync
  - Projects untouched (re-init via /aips:init if needed)
```

---

## Statusline

3-line multi-line. Three glances tell you everything: what you're working on, how much budget you have left, and how much you've saved.

```
project [main*3] wip:2 | opus-4.7 | ctx:8%(15.5k/200k) | cache:71%
5h:8% ↻2h11m ∅1h23m | wk:12% ↻4d18h ∅2d4h
🦴cv:75%/full | 🧠am:40%/127 | 💰rtk:34% | 🤖cdx:55%/3runs | 💯Σ:95%
```

| Line | Shows |
|---|---|
| 1 | Project name, git branch [commits since base], `wip` count, model, context usage, prompt cache hit rate |
| 2 | 5-hour window usage + time until reset (`↻`) + projected empty ETA at current burn rate (`∅`); weekly window same |
| 3 | caveman savings/intensity, agentmemory hit rate / observation count, RTK savings, codex delegation rate / runs, cumulative savings (`Σ`) |

`↻` = time until reset · `∅` = projected empty ETA at current burn rate · `Σ` = cumulative savings (`Σ = 1 − Π(1 − SAVED_i / 100)`).

---

## Slash commands

### AIPS native — 11 commands

| | Command | Action |
|---|---|---|
| ⚙️ | `/aips:init` | Auto-branched init (fresh / migrate / re-init / repair) |
| 🔄 | `/aips:update` | marketplace pull + bundled plugin update |
| 🩺 | `/aips:health` | `verify-setup.sh` + `smoke-test-hooks.sh` |
| 🗑️ | `/aips:uninstall` | Safe removal, global + project |
| 📊 | `/aips:status` | Current task + recent activity summary |
| 📜 | `/aips:migrate-from-md` | Explicit v5.x `.md` migration (manual case-B trigger) |
| ⬆️ | `/aips:upgrade` | Version upgrade — supports `--to v7.0` for v6.0 → v7.0 hybrid migration |
| 🔧 | `/aips:repair` | Repair broken state (manual case-D trigger) |
| ♻️ | `/aips:reset` | Reset project init (with backup) |
| 🔗 | `/aips:rebind <old-path>` | Rebind globalized state when a project moves or is renamed |
| 🔍 | `/aips:scope` | Diagnose what is globalized vs per-project; flag drift or orphans |

### Bundled plugin commands

| Plugin | Commands |
|---|---|
| codex-plugin-cc | `/codex:brief`, `/codex:review`, `/codex:fix`, `/codex:relay-status` |
| caveman | `/caveman`, `/caveman:lite`, `/caveman:ultra`, `/caveman:wenyan-*` |
| agentmemory | `/am:save`, `/am:recall`, `/am:reflect`, `/am:consolidate`, `/am:sessions` |
| RTK | Hook-based auto — no explicit command (`rtk gain` from shell) |

> Legacy custom `/codex-brief`, `/codex-review`, `/codex-fix`, `/codex-relay-status` from v5.x were retired in v6.0. Use `/codex:*` from the official `codex-plugin-cc` instead.

---

## Migration

### From v5.x — `/aips:init` handles it

```bash
cd existing-v5-project
claude
> /aips:init
# → Detects root AI_PROJECT_SETUP.md (v5.x)
# → "v5.x install detected. Migrate to v7.0? [y/N]"
# → On y:
#   1. Full backup to .priv-storage/v5-backup/
#   2. Reduce 7,600-line AI_PROJECT_SETUP.md → 30-line DEPRECATED redirect
#   3. Remove custom /codex-* (4 commands) — replaced by codex-plugin-cc
#   4. Slim CLAUDE.md to Sections 1-7 + 11 only (~150 lines)
#   5. Register with global sessions mirror + memory store
#   6. Write v7.0 marker
```

Or trigger it explicitly: `/aips:migrate-from-md`.

### From v6.0 — `/aips:upgrade --to v7.0`

```bash
cd existing-v6-project
claude
> /aips:upgrade --to v7.0
# → Strict mode (default): result is identical to a fresh v7.0 install.
#   per-project tmp-igbkp/*.sh and sessions/*.md are purged after their
#   global counterparts are verified. Full backup at
#   tmp-igbkp/upgrade-v7-backup-{ts}/ is always taken first.
# → Pass --keep-local-fallback to retain both as fallback (lenient).
```

### What v7.0 changed vs v6.0

| Item | v6.0 | v7.0 |
|---|---|---|
| Toolkit scripts | `tmp-igbkp/*.sh` copied per project | `~/.local/bin/aips-*` symlinks (one canonical copy) |
| Sessions | `.priv-storage/sessions/` only | per-project buffer + `~/.claude/sessions/{path-hash}/` mirror |
| Memory | per-project + global (dual-write) | global only — `~/.claude/projects/{path-encoded}/memory/` |
| Gitignore | 22 entries in every `.gitignore` | one block in `~/.config/git/ignore` |
| New commands | — | `/aips:rebind`, `/aips:scope`, `/aips:upgrade --to v7.0` |

---

## Supported AI tools

**AIPS is built for Claude Code first.** Other tools get policy-only support via `CLAUDE.md` / `AGENTS.md` / `.cursorrules`. Full plugin parity for them is on the roadmap.

### Tier 1 — Primary / Full

| Tool | Min version | Reads | Features |
|---|---|---|---|
| **Claude Code (CLI)** | 2.0+ | `CLAUDE.md` | Full plugin install, 11 `/aips:*` commands, 5 hooks, 3-line statusline, output styles, 4 bundled plugins |

### Tier 2 — Partial (policy-only)

| Tool | Min version | Reads | Features |
|---|---|---|---|
| **ChatGPT Codex CLI** | 0.10+ | `AGENTS.md` → `CLAUDE.md` | Rules only (no hooks / slash / statusline) |
| **Cursor** | 0.40+ | `.cursorrules` → `CLAUDE.md` | Rules only |
| **GitHub Copilot** | 1.150+ | `AGENTS.md` | Rules only |
| **claude.ai (web)** | current | `CLAUDE.md` manual upload | Rules only |
| **Any MCP-aware tool** | — | depends | `.mcp.json` only |

> *Policy-only* = rules enforced through prompt content. No kernel-level blocking, no hooks, no slash commands, no statusline — but the rule file is read by the AI and followed.

### Tier 3 — Full support TBD

Full plugin-like parity (hooks, slash commands, statusline, bundled-plugin stack) for Codex / Cursor / Copilot is roadmap. Track progress in [Roadmap](#roadmap) or open an issue to upvote.

---

## Comparison

| | AIPS v7.0 | `.cursorrules` only | Hand-written CLAUDE.md | Nothing |
|---|:---:|:---:|:---:|:---:|
| Per-project setup time | ~30 sec | instant | hours | 0 |
| Deterministic (no AI interpretation) | yes | yes | yes | n/a |
| Single source of truth across tools | yes | Cursor only | Claude only | no |
| One-line global install | yes | no | no | n/a |
| Safety hooks (kernel-level) | yes | no | manual | no |
| Session resume on crash / `/clear` | yes (3-tier) | no | manual | no |
| 3-line statusline (incl. savings) | yes | no | no | no |
| Cross-AI relay (Claude ↔ Codex) | yes (plugin) | no | no | no |
| Token savings (RTK + caveman + agentmemory) | yes | no | no | no |
| Upstream self-update | yes (`/aips:update`) | no | no | n/a |
| Survives project rename | yes (`/aips:rebind`) | no | manual | no |
| Zero per-repo gitignore noise | yes (global ignore) | yes | no | yes |
| Linux / macOS / Windows | yes | yes | yes | n/a |

---

## Documentation

| Document | What's inside |
|---|---|
| [install.sh](install.sh) | Global install script |
| [docs/README.ko.md](docs/README.ko.md) | This README in Korean |
| [AI_PROJECT_SETUP.md](AI_PROJECT_SETUP.md) | v5.2 archive (30-line DEPRECATED stub for downstream raw-URL compatibility) |
| [CONTRIBUTING.md](CONTRIBUTING.md) · [한국어](docs/CONTRIBUTING.ko.md) | Dev setup, version-bump checklist, PR conventions |
| [SECURITY.md](SECURITY.md) · [한국어](docs/SECURITY.ko.md) | Disclosure process, secret-guard patterns |
| [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) · [한국어](docs/CODE_OF_CONDUCT.ko.md) | Contributor Covenant v2.1 |
| [CHANGELOG.md](CHANGELOG.md) · [한국어](docs/CHANGELOG.ko.md) | Full version history |

---

## FAQ

<details>
<summary><b>Why a 150-line CLAUDE.md instead of dumping everything in?</b></summary>

Because your AI loads it every session. Token discipline = your wallet. The other 12 sections of project policy live in global hooks, skills, and output-styles — they execute deterministically without the AI re-reading them.
</details>

<details>
<summary><b>Do I still have to upgrade from v6.0?</b></summary>

No, v6.0 keeps working. v7.0 is opt-in and non-breaking. Run `/aips:upgrade --to v7.0` when you want a single canonical toolkit, sessions mirror, global gitignore, and single-source memory.
</details>

<details>
<summary><b>What if I rename or move my project after v7.0 init?</b></summary>

`/aips:rebind <old-path>` from inside the project's new location. It rewrites the path-hash-keyed globals (`~/.claude/sessions/{path-hash}/`, memory mappings) so sessions and memory continue resolving to the same project.
</details>

<details>
<summary><b>How do I see what's globalized vs per-project?</b></summary>

`/aips:scope`. It prints which artifacts live where for the current project, and flags drift (per-project sessions buffer ahead of global mirror) or orphans (global state for a project dir that no longer exists).
</details>

<details>
<summary><b>What does install.sh touch on my system?</b></summary>

`~/.claude/`, `~/.local/bin/`, `~/.config/git/ignore`, and a user-level systemd unit (agentmemory). It does not touch system-wide directories (`/usr/local/`, `/etc/`). Uninstall via `/aips:uninstall`.
</details>

<details>
<summary><b>Why bundle 4 plugins instead of letting me pick?</b></summary>

Each one is orthogonal — codex-plugin-cc (relay), caveman (output compression), agentmemory (persistent memory), RTK (CLI token savings). Installed separately, hook order and statusline fallbacks become painful. Bundling guarantees cross-plugin sync; you can still disable any of them via Claude Code's plugin settings.
</details>

<details>
<summary><b>Does it work offline?</b></summary>

Install / update need the network (marketplace pull, RTK binary fetch). Normal sessions and `/aips:init` work offline — every artifact is read from the local plugin store.
</details>

<details>
<summary><b>How do I sync across multiple machines?</b></summary>

agentmemory writes project memory to `~/.claude/projects/{path-encoded}/memory/`. On a new machine: `install.sh` → `/aips:init` in the project → `rsync` the memory dir over. Sessions mirror works the same way under `~/.claude/sessions/`.
</details>

<details>
<summary><b>Windows?</b></summary>

Git Bash, WSL, and MSYS2 work. `install.sh` is bash, hooks are bash, so native PowerShell is not supported. WSL is recommended.
</details>

<details>
<summary><b>Multiple AI tools in the same project?</b></summary>

Yes. Claude Code reads `CLAUDE.md`, Codex / Copilot read `AGENTS.md`, Cursor reads `.cursorrules` — all three are symlinks to the same `.priv-storage/CLAUDE.md`, so updates are atomic. Hooks, statusline, and slash commands are Claude Code-only.
</details>

<details>
<summary><b>Can I skip the marketplace and just clone the repo?</b></summary>

Yes. Clone the repo and run `install.sh` from the local path — the marketplace step falls back to pointing at the local path. Useful for forks and air-gapped environments.</summary>
</details>

<details>
<summary><b>Found a bug or want a feature.</b></summary>

Open an issue or PR at <https://github.com/kernalix7/AIPS>. See [CONTRIBUTING.md](CONTRIBUTING.md).
</details>

---

## Roadmap

- **v7.0.0** *(stable, 2026-05-19)* — Hybrid global-first: globalized toolkit / sessions / memory / gitignore, 3 new `/aips:*` commands (`upgrade --to v7.0`, `rebind`, `scope`), strict-by-default non-breaking migration from v6.0
- **v7.1** — agentmemory deeper integration: cross-project workflow recommendations, shared lesson surfaces visible in `/am:recall`
- **v7.2** — `/aips:rebind` UX: auto-detect moved projects via path-hash heuristics; one-command recovery without specifying `<old-path>`
- **v7.3** — Tier 2 → Tier 1 promotion experiments: prototype hook / statusline support for Codex CLI via wrapper shim
- **v8.0 (candidate)** — Team-shared globals via opt-in cloud sync, or full plugin-marketplace publishing for third-party AIPS extensions

See [CHANGELOG.md](CHANGELOG.md) for shipped versions.

---

## Star history

<a href="https://star-history.com/#kernalix7/AIPS&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=kernalix7/AIPS&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=kernalix7/AIPS&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=kernalix7/AIPS&type=Date" />
  </picture>
</a>

---

## Support

If AIPS saved you setup time:

[![Ko-fi](https://img.shields.io/badge/Ko--fi-F16061?logo=ko-fi&logoColor=white&style=for-the-badge)](https://ko-fi.com/kernalix7)
[![Fairy](https://img.shields.io/badge/Fairy-EE6E73?style=for-the-badge&logoColor=white)](https://fairy.hada.io/@kernalix7)

Ko-fi handles international cards and PayPal; fairy.hada.io is a Korean tipping platform. Bug reports, PRs, and stars on the repo are equally appreciated and free.

---

## License

[MIT](LICENSE) — Kim DaeHyun ([kernalix7@kodenet.io](mailto:kernalix7@kodenet.io))

<div align="center">

[Report bug](https://github.com/kernalix7/AIPS/issues/new?template=bug_report.md) &nbsp;·&nbsp; [Request feature](https://github.com/kernalix7/AIPS/issues/new?template=feature_request.md) &nbsp;·&nbsp; [한국어 README](docs/README.ko.md)

</div>
