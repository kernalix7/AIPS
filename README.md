<div align="center">

# ai-project-setup

### Drop one file. Tell your AI to read it. Done.

<p>A single 7,000-line markdown bootstrap that turns <b>Claude Code, ChatGPT Codex CLI, Cursor, and GitHub Copilot</b> into a disciplined teammate — 13-section rules, 5 safety hooks, session-resume, dual-write memory, and bilingual GitHub files. <b>Zero install. One source of truth.</b></p>

<pre><code># Fetch the bootstrap file
curl -fsSL https://raw.githubusercontent.com/kernalix7/ai-project-setup/main/AI_PROJECT_SETUP.md > AI_PROJECT_SETUP.md

# Open your AI tool, then say:
#   "Read AI_PROJECT_SETUP.md and execute it."
#   "AI_PROJECT_SETUP.md 읽고 실행해줘"

# 1–3 minutes later, verify:
./tmp-igbkp/verify-setup.sh   # → Pass: 83  Fail: 0  Warn: 0
</code></pre>

[![Stable](https://img.shields.io/badge/status-stable-2EA44F?style=for-the-badge)](#-status-v52-stable)
[![Latest](https://img.shields.io/badge/latest-v5.2-2962FF?style=for-the-badge)](AI_PROJECT_SETUP.md)

[![license](https://img.shields.io/github/license/kernalix7/ai-project-setup?style=flat-square&color=blue)](LICENSE)
[![markdown](https://img.shields.io/badge/markdown-CommonMark-083FA1?style=flat-square&logo=markdown&logoColor=white)](AI_PROJECT_SETUP.md)
[![checks](https://img.shields.io/badge/checks-83%2B-2EA44F?style=flat-square)](AI_PROJECT_SETUP.md)
[![scripts](https://img.shields.io/badge/scripts-9-blue?style=flat-square)](AI_PROJECT_SETUP.md)
[![stars](https://img.shields.io/github/stars/kernalix7/ai-project-setup?style=flat-square&color=FFD93D&logo=github&logoColor=white)](https://github.com/kernalix7/ai-project-setup/stargazers)
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

<sub>**English** &nbsp;·&nbsp; [한국어](docs/README.ko.md) &nbsp;·&nbsp; [Setup file](AI_PROJECT_SETUP.md) &nbsp;·&nbsp; [Contributing](CONTRIBUTING.md) &nbsp;·&nbsp; [Security](SECURITY.md) &nbsp;·&nbsp; [Changelog](CHANGELOG.md)</sub>

</div>

---

### 📌 Status: v5.2 stable

> ai-project-setup ships a **single-file bootstrap** (`AI_PROJECT_SETUP.md`, ~7,600 lines) that any AI coding assistant reads and executes to produce a complete, multi-tool, gitignored AI tooling layout. v5.2 is the first polished GitHub repository release: expanded README, bilingual standard docs, issue/PR templates, and stricter no-footprint `.gitignore`. v5.1 moved the self-update source from a gist to this repository, so projects on v5.0 or earlier fetch v5.1 once from the legacy gist (frozen as a migration bridge), then all subsequent updates come from here. The artifact is **idempotent and self-healing** — re-running setup on an existing project repairs drift, force-overwrites stale shipped scripts with `.bak` backups, and preserves user content (`CLAUDE.md` sections 1–7 and 11, memory files, project agents).

**One file, every AI tool.** Drop [`AI_PROJECT_SETUP.md`](AI_PROJECT_SETUP.md) at your project root, tell the AI to read it, and in 1–3 minutes you have rules, hooks, session-resume, slash commands, default agents, a backup toolkit, and bilingual GitHub standard files — all gitignored so your project git history stays clean. **Absolute Rule #19**: AI tooling leaves zero footprint in your project's git history.

---

## 📑 Table of contents

- [Why this exists](#-why-this-exists)
- [Quick start](#-quick-start)
- [What gets created](#-what-gets-created)
- [Lifecycle](#-lifecycle)
- [Key features](#-key-features)
- [Supported AI tools](#-supported-ai-tools)
- [Comparison](#%EF%B8%8F-comparison)
- [Documentation](#-documentation)
- [Self-update](#-self-update)
- [Forking](#-forking)
- [FAQ](#-faq)
- [Roadmap](#%EF%B8%8F-roadmap)
- [Star history](#-star-history)
- [Support](#-support)
- [License](#-license)

---

## 🎯 Why this exists

Every new project, you re-do the same AI setup. This file does it **once, deterministically**, across multiple AI tools:

| What you used to do every time | What this file does automatically |
|---|---|
| Write `CLAUDE.md` / `AGENTS.md` / `.cursorrules` by hand | ✅ 13 sections generated + 3-tool symlink sync |
| Block dangerous commands (`rm -rf /`, force push, secret leaks) | ✅ Kernel-level `PreToolUse` hook |
| Set up session resume for `/clear` · crash · rate-limit | ✅ 3-tier auto-save (current/handoff/recovery) |
| Configure memory · slash commands · default agents | ✅ 10+ commands + 4 agents installed |
| Create README / SECURITY / CONTRIBUTING / CHANGELOG | ✅ Bilingual EN/KO generation |
| Stop AI tool files from leaking into git history | ✅ 22 `.gitignore` entries auto-applied |

---

## ⚡ Quick start

One-liner (any git repository):

```bash
curl -fsSL https://raw.githubusercontent.com/kernalix7/ai-project-setup/main/AI_PROJECT_SETUP.md \
  > AI_PROJECT_SETUP.md
```

Then open your AI tool and tell it to execute the file:

```bash
claude       # or: codex, cursor ., or VS Code with Copilot
```

Tell the AI (English or Korean both work):

> Read `AI_PROJECT_SETUP.md` and execute it.
>
> `AI_PROJECT_SETUP.md 읽고 실행해줘`

Wait 1–3 minutes, then verify:

```bash
./tmp-igbkp/verify-setup.sh
# → Pass: 83  Fail: 0  Warn: 0 — All required checks passed
```

That's it. Everything created is gitignored — your project's git history stays clean.

---

## 📦 What gets created

```text
your-project/
|-- CLAUDE.md              -> symlink to .priv-storage/CLAUDE.md
|-- AGENTS.md              -> symlink to .priv-storage/CLAUDE.md   # Codex / Copilot
|-- .cursorrules           -> symlink to .priv-storage/CLAUDE.md   # Cursor
|-- WORK_STATUS.md         -> current work state (project content)
|
|-- .priv-storage/         [gitignored] all AI tooling lives here
|   |-- CLAUDE.md                   # 13-section project rules (~10kB cap)
|   |-- CLAUDE.local.md             # per-developer overrides
|   |-- POST_SETUP_INDEX.md         # 50-line pointer (saves ~25k tokens/session)
|   |-- AI_PROJECT_SETUP.md         # archived, never re-read
|   |-- memory/                     # dual-written to ~/.claude/projects/ (cross-machine sync)
|   |-- sessions/                   # current.md, handoff-{date}.md, recovery.md, read-log.tsv
|   `-- .claude/
|       |-- settings.json           # statusLine + 5 hooks + outputStyle
|       |-- hooks/                  # PreToolUse / PostToolUse / SessionStart / PreCompact / Stop
|       |-- agents/                 # tech-lead, explorer, code-reviewer, log-analyzer
|       |-- commands/               # 10+ slash commands
|       |-- skills/ and rules/      # on-demand knowledge
|       |-- output-styles/terse.md
|       `-- statusline              # context percent / rate-limit ETA
|
|-- tmp-igbkp/             [gitignored] backup and verification toolkit (9 scripts)
|   |-- verify-setup.sh             # one-command health check (83+ assertions)
|   |-- smoke-test-hooks.sh         # mock-payload hook validation
|   |-- secret-guard.sh             # 14-pattern pre-commit scanner
|   |-- archive.sh / restore.sh     # AES-256-CBC + PBKDF2 600k iterations
|   |-- purge-history.sh            # git-filter-repo wrapper
|   |-- setup-worktree.sh           # bridges worktrees to main .priv-storage/
|   |-- codex-relay-{check,run}.sh  # Claude <-> Codex parallel lanes
|   `-- uninstall.sh                # safe rollback with backup
|
|-- .mcp.json              [gitignored] MCP server registry (env-var refs only)
|
|-- README.md, SECURITY.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md, CHANGELOG.md
|-- docs/{README,SECURITY,CONTRIBUTING,CODE_OF_CONDUCT,CHANGELOG}.ko.md
`-- .github/{ISSUE_TEMPLATE/,PULL_REQUEST_TEMPLATE.md}
```

> Only `WORK_STATUS.md`, GitHub standard files, the `docs/` Korean mirrors, and `.github/` get committed. Everything inside `.priv-storage/` and `tmp-igbkp/` is gitignored by design.

---

## 🔄 Lifecycle

```text
[1. INITIAL SETUP]
  Prompt: "Read AI_PROJECT_SETUP.md and execute it."
  - Auto-detects Scenario A/B/C
  - Creates everything above, then runs STEP 6
  - Archives AI_PROJECT_SETUP.md into .priv-storage/
  - Prints "Setup Complete" only if automode-validate.sh passes

        |
        v

[2. NORMAL SESSIONS]
  - SessionStart hook injects last handoff + current.md tail
  - AI reads CLAUDE.md (~200 lines) + POST_SETUP_INDEX.md (~50)
  - Does not re-read the 7000-line setup file, saving ~25k tokens/session
  - PreToolUse blocks dangerous commands + oversized Reads
  - PostToolUse appends to current.md + dual-writes memory
  - Stop hook writes handoff-{date}.md
  - PreCompact hook writes recovery.md (best-effort)

        |
        v

[3. CRASH / RATE-LIMIT / /clear]
  - Next session: SessionStart auto-loads handoff + recovery
  - AI resumes without "where were we?" questions

        |
        v

[4. SELF-UPDATE]
  Trigger: "update setup" or Korean "AI_PROJECT_SETUP 업데이트해"
  - Fetches latest from GitHub raw URL
  - Replaces archived setup file
  - Force-overwrites all 30+ shipped scripts with .bak backup
  - Re-runs automode-validate gate
  - Reports: "Updated: vOLD -> vNEW. Recommend /clear."
```

### Three setup scenarios

| Scenario | When | What the AI does |
|----------|------|------------------|
| **A — existing** | `.priv-storage/` exists or real `CLAUDE.md` at root | Update/repair in place. Force-overwrite shipped scripts (with `.bak`), preserve user content. |
| **B — empty/new** | No `.priv-storage/`, no `CLAUDE.md` at root | Full setup from scratch — STEP 0 detection → STEPs 1–12 → archive. |
| **C — broken** | Files at root that look like CLAUDE.md but aren't, or partial leftover state | Detect, classify, convert to canonical layout, then bridge into A's STEPs 4–12. |

---

## ✨ Key features

<table>
<tr><td width="50%">

**🛡️ Safety hooks** *(Claude Code)*
- `PreToolUse` blocks `rm -rf /`, force push, `git add` of gitignored AI files, `eval`, `base64 | sh`, `curl http://`, `~/.ssh` reads, fork bombs
- Blocks oversized `Read` (>1000 lines without `offset`/`limit`)
- Blocks commit messages mentioning AI tooling
- `PostToolUse` appends to `sessions/current.md` + dual-writes memory
- `SessionStart` auto-loads last handoff + current.md tail + recovery
- `PreCompact` writes recovery.md snapshot (best-effort)
- `Stop` writes `handoff-{date}.md` + archives old handoffs

</td><td width="50%">

**🔄 Resilience**
- 3-tier session log: `current.md` (every call) → `handoff-{date}.md` (session end) → `recovery.md` (pre-compact)
- Memory dual-write: every memory file mirrors to `~/.claude/projects/{path-encoded}/memory/` → new laptop restores instantly
- Idempotent setup: SHA256 markers in `.priv-storage/.setup-step-{N}.done`
- Force-overwrite of shipped scripts on every update (with `.bak`) — stale bugs auto-resolve
- 83+ assertion `verify-setup.sh` — single-command health check
- `smoke-test-hooks.sh` fires each hook with mock payload

</td></tr>
<tr><td width="50%">

**🤖 Default agents** *(token-efficient)*
- **`tech-lead`** — auto-evaluates complexity, forms teams (modules ≥ 2 OR files ≥ 5 OR cross-module work)
- **`explorer`** — read-only codebase search, returns summaries, preserves main context window
- **`code-reviewer`** — security/correctness/style review
- **`log-analyzer`** — parses crash logs / hook-error logs
- Subagent delegation **MANDATORY** above thresholds (>3 files, >500 lines, codebase-wide search)

</td><td width="50%">

**⚡ Slash commands**
- **`/status`** — current task + recent activity summary
- **`/health`** — runs verify-setup.sh + smoke-test-hooks.sh
- **`/recover`** — load latest handoff + recovery into context
- **`/ship`** — pre-commit secret-guard + clean check
- **`/save`** — manual snapshot to current.md
- **`/clean`** — rotate old handoffs, prune sessions
- **`/codex-{brief,review,fix,relay-status}`** — Claude ↔ Codex parallel lanes

</td></tr>
<tr><td width="50%">

**💰 Token discipline** *(Absolute Rule #20)*
- `CLAUDE.md` hard-capped at 16k chars (WARN) / 32k (FAIL)
- `PreToolUse` **BLOCKS** `Read` of >1000-line files without `offset`/`limit`
- Subagent delegation MANDATORY above thresholds
- `read-log.tsv` flags duplicate Reads within a session
- Auto-extends from terse → verbose only when reasoning is requested
- **Expected: 30–60% token reduction vs naive AI-pair-programming**

</td><td width="50%">

**🔐 Secret guard**
- 14 regex patterns: `AKIA…`, `ASIA…`, `sk-…`, `sk-proj-…`, `ghp_…`, `ghs_…`, `gho_…`, `glpat-…`, `xox[abprs]-…`, `sk_live_…`, `rk_live_…`, `AIza…`, JWTs, `-----BEGIN PRIVATE KEY-----`
- Special `.mcp.json` rule — env-var references only
- Per-line `# secret-guard:ignore` allow-list for false positives
- `--install-hook` mode wires into git pre-commit
- AES-256-CBC + PBKDF2 600k for archived backups

</td></tr>
<tr><td width="50%">

**🌏 Multi-tool parity**
- Same `CLAUDE.md` drives Claude Code, Codex CLI, Cursor, Copilot via symlinks
- All three rule files (`CLAUDE.md` / `AGENTS.md` / `.cursorrules`) point to the same target — atomic updates
- MCP servers registered via gitignored `.mcp.json` (env-var refs only)
- VS Code settings symlinked for Copilot integration
- Hooks are Claude Code-specific; other tools get policy-only enforcement

</td><td width="50%">

**🔀 Cross-AI Codex relay** *(v4.9+, Claude Code only)*
- When `codex` CLI is on `PATH`, Claude offloads implementation to Codex while keeping planning/review authority
- Flow: Claude *(plan)* → `/codex-brief` → Codex *(implement)* → Claude *(`/codex-review`)* → Codex *(`/codex-fix`)*
- v5.0+ parallel per-agent relay lanes for TeamCreate work
- Conflict prevention: disjoint allowed-paths per lane via `paths_overlap` check
- Lockfiles in `.priv-storage/sessions/codex-relay/locks/` + `active.tsv` ledger

</td></tr>
</table>

---

## 🤝 Supported AI tools

| Tool | Min version | Reads | Hook support |
|------|-------------|-------|--------------|
| **Claude Code** | 2.0+ | `CLAUDE.md` | ✅ Full (5 hook events) |
| **ChatGPT Codex CLI** | 0.10+ | `AGENTS.md` → `CLAUDE.md` | ❌ Policy-only |
| **Cursor** | 0.40+ | `.cursorrules` → `CLAUDE.md` | ❌ Policy-only |
| **GitHub Copilot** | 1.150+ | `AGENTS.md` | ❌ Policy-only |
| **claude.ai (web)** | current | upload `CLAUDE.md` | ❌ Policy-only |
| **Any MCP-aware tool** | — | depends | ❌ Policy-only |

> *Policy-only* = rules enforced via prompt content. No kernel-level block, but the AI follows them because they're in the rules file it reads.

---

## ⚖️ Comparison

| | This file | `.cursorrules` only | Custom CLAUDE.md | Per-tool CLI tool |
|---|:---:|:---:|:---:|:---:|
| Single source of truth across tools | ✅ | ❌ Cursor only | ❌ Claude only | ❌ |
| Zero install | ✅ | ✅ | ✅ | ❌ |
| Safety hooks (kernel-level) | ✅ | ❌ | manual | maybe |
| Session resume on crash | ✅ | ❌ | manual | maybe |
| Token discipline enforcement | ✅ | ❌ | manual | ❌ |
| Self-update from upstream | ✅ | ❌ | ❌ | ✅ |
| Bilingual GitHub files | ✅ | ❌ | ❌ | ❌ |
| AI-tooling leak prevention | ✅ | ❌ | manual | ❌ |
| Cross-AI relay (Claude ↔ Codex) | ✅ | ❌ | ❌ | ❌ |
| Works on Linux / macOS / Windows | ✅ | ✅ | ✅ | depends |

---

## 📚 Documentation

| Document | What's inside |
|----------|---------------|
| [AI_PROJECT_SETUP.md](AI_PROJECT_SETUP.md) | The artifact — 7,600-line bootstrap that creates everything |
| [docs/README.ko.md](docs/README.ko.md) | This README in Korean |
| [CONTRIBUTING.md](CONTRIBUTING.md) · [한국어](docs/CONTRIBUTING.ko.md) | Development setup, version-bump checklist, PR conventions |
| [SECURITY.md](SECURITY.md) · [한국어](docs/SECURITY.ko.md) | Security disclosure process, secret-guard patterns |
| [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) · [한국어](docs/CODE_OF_CONDUCT.ko.md) | Contributor Covenant v2.1 |
| [CHANGELOG.md](CHANGELOG.md) · [한국어](docs/CHANGELOG.ko.md) | Full version history |

---

## 🔁 Self-update

Trigger via natural language: `"AI_PROJECT_SETUP 업데이트해"` / `"update AI_PROJECT_SETUP"` / `"fetch latest setup"`.

The AI:

1. Fetches `https://raw.githubusercontent.com/kernalix7/ai-project-setup/main/AI_PROJECT_SETUP.md`
2. Compares `Last Updated` line and version against local copy
3. If newer: replaces `.priv-storage/AI_PROJECT_SETUP.md`, force-overwrites all 30+ shipped scripts with `.bak` backup
4. Merges template sections of `CLAUDE.md` (§8/9/10/12/13) while preserving project content (§1–7, §11)
5. Re-runs the validator gate
6. Reports `Updated: vOLD → vNEW. Force-patched N shipped scripts. Recommend /clear.`

**Single command, no re-run prompt** (since v4.6+).

> **v5.0 → v5.1 migration**: v5.1 moved the update source from a gist to this repository. Projects on v5.0 or earlier fetch v5.1 once from the legacy gist (frozen at v5.1 as a migration bridge), then all subsequent updates come from this repository.

---

## 🍴 Forking

To point forks at your own repo for self-update:

1. Edit [`AI_PROJECT_SETUP.md`](AI_PROJECT_SETUP.md) — replace both occurrences of `kernalix7/ai-project-setup` with `{your-user}/{your-repo}`:
   - The repo URL in the **Source of Truth** block
   - The raw URL in the same block and in the self-update protocol Step 2
2. Optionally remove the legacy gist URL block (only needed when migrating users from pre-v5.1).
3. Commit and push to your fork's `main` branch.

For downstream project customization, edit the generated `.priv-storage/CLAUDE.md` directly — sections 1–7 and 11 are preserved across self-updates.

---

## ❓ FAQ

<details>
<summary><b>Why a single 7,000-line markdown file instead of a CLI tool?</b></summary>

AI coding assistants natively read markdown. A CLI tool needs installation, version management, and platform support. A markdown file works everywhere any AI works — Linux, macOS, Windows, containers, browser-based agents — with zero install.
</details>

<details>
<summary><b>Doesn't 7,000 lines blow up my context window?</b></summary>

Only on initial setup (~25k tokens, one time). After setup, the file is archived and a 50-line `POST_SETUP_INDEX.md` becomes the entry point. Normal sessions consume ~200 lines of `CLAUDE.md` + the index — about 4k tokens.
</details>

<details>
<summary><b>Is it safe that nothing gets committed? My CI/CD doesn't see hooks/agents.</b></summary>

Correct, and intentional. AI tooling is per-developer ergonomics; CI/CD runs against your code, not your AI config. Teammates who don't use AI see no change. Those who do run setup themselves and get the same config from this same source.
</details>

<details>
<summary><b>Will this work with [some new AI tool that doesn't exist yet]?</b></summary>

If the tool reads markdown rules files (`CLAUDE.md` / `AGENTS.md` / `.cursorrules` / similar), yes — point it at any of the three symlinks. If it supports MCP, it'll find `.mcp.json` automatically. Hooks are Claude Code-specific.
</details>

<details>
<summary><b>How do I uninstall?</b></summary>

```bash
./tmp-igbkp/uninstall.sh
```
Backs up everything to `tmp-igbkp/uninstall-backup-{ts}/` before removing. Add `--clean-gitignore` to also remove the AI-tooling block from `.gitignore`.
</details>

<details>
<summary><b>What about Windows?</b></summary>

Works on Git Bash, WSL, and MSYS2. Native PowerShell is not supported for hooks (they're bash scripts), but the rules file itself is plain markdown and works with any AI tool on Windows.
</details>

<details>
<summary><b>Can I use this with multiple AI tools simultaneously in the same project?</b></summary>

Yes — that's the design. Claude Code reads `CLAUDE.md`, Codex/Copilot read `AGENTS.md`, Cursor reads `.cursorrules`. All three are symlinks to the same `.priv-storage/CLAUDE.md` so updates are atomic.
</details>

<details>
<summary><b>I found a bug / want a feature.</b></summary>

Open an issue or PR at <https://github.com/kernalix7/ai-project-setup>. See [CONTRIBUTING.md](CONTRIBUTING.md).
</details>

---

## 🗺️ Roadmap

- **v5.3** — `.devcontainer/` template, GitHub Actions workflow for setup verification
- **v5.4** — Native Windows PowerShell hooks (experimental)
- **v6.0** — Pluggable rule modules (`.priv-storage/.claude/rules/<lang>/`)

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## ⭐ Star history

<a href="https://star-history.com/#kernalix7/ai-project-setup&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=kernalix7/ai-project-setup&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=kernalix7/ai-project-setup&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=kernalix7/ai-project-setup&type=Date" />
  </picture>
</a>

---

## 💛 Support

If ai-project-setup saved you setup time:

[![Ko-fi](https://img.shields.io/badge/Ko--fi-F16061?logo=ko-fi&logoColor=white&style=for-the-badge)](https://ko-fi.com/kernalix7)
[![Fairy](https://img.shields.io/badge/🧚_Fairy-EE6E73?style=for-the-badge&logoColor=white)](https://fairy.hada.io/@kernalix7)

Ko-fi handles international cards and PayPal; fairy.hada.io is a Korean tipping platform. Bug reports, PRs, and ⭐ stars on the repo are equally appreciated and free.

---

## 📄 License

[MIT](LICENSE) — Kim DaeHyun ([kernalix7@kodenet.io](mailto:kernalix7@kodenet.io))

<div align="center">

[Report bug](https://github.com/kernalix7/ai-project-setup/issues/new?template=bug_report.md) &nbsp;·&nbsp; [Request feature](https://github.com/kernalix7/ai-project-setup/issues/new?template=feature_request.md) &nbsp;·&nbsp; [한국어 README](docs/README.ko.md)

</div>
