# Security Policy

**English** | [한국어](docs/SECURITY.ko.md)

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| v6.x    | :white_check_mark: |
| < v6.0  | :x:                |

v6.0 migrated from single-file bootstrap to Claude Code plugin distribution. Older versions are unsupported.

## Reporting a Vulnerability

**Do NOT report security vulnerabilities through public GitHub issues.**

Report via [GitHub Security Advisories](https://github.com/kernalix7/AIPS/security/advisories/new).

Include: description, reproduction steps, affected versions, potential impact. Acknowledge ≤7 days, status ≤30 days.

## Install-Time Risks

### `curl | bash` pipeline

The recommended install is:
```bash
curl -fsSL https://raw.githubusercontent.com/kernalix7/AIPS/main/install.sh | bash
```
This trusts the network and the repo HEAD at fetch time. For hardened environments:
1. Download first: `curl -fsSL .../install.sh -o install.sh`
2. Verify SHA256 against the value published on the GitHub Release page.
3. Read the script, then `bash install.sh`.

### Plugin marketplace trust

`install.sh` registers 4 external Claude Code marketplaces:
- `kernalix7/AIPS`
- `openai/codex-plugin-cc`
- `JuliusBrussee/caveman`
- `rohitg00/agentmemory`

Each ships a `marketplace.json` describing plugins and their entry points. Review the file at `~/.claude/plugins/marketplaces/<owner>-<repo>/marketplace.json` before running `/plugin install`. Marketplaces can be removed with `/plugin marketplace remove <name>`.

## Runtime Surface

### agentmemory (systemd user service)

Runs as a user-scope service (no sudo) and exposes:
- `127.0.0.1:3111` — REST API consumed by Claude Code hooks
- `127.0.0.1:3113` — local web viewer

It records every Claude Code tool-use observation. For sensitive projects:
- Configure `BLOCKLIST` in `~/.claude/plugins/cache/agentmemory/agentmemory/.env`
- Or stop for the session: `systemctl --user stop agentmemory.service`
- Full removal: `systemctl --user disable --now agentmemory.service`

Linux only. Bound to loopback; do not expose either port to a network.

### MCP server credentials

`.mcp.json` MUST reference environment variables (`${VAR}`), never inline secrets. Project-level `.mcp.json` is gitignored by the template — keep it that way.

### codex-plugin-cc auth token

`openai/codex-plugin-cc` stores its auth token in `~/.codex/config.toml`. Treat this file as a credential: `chmod 600`, never commit, rotate on suspected compromise.

## Defensive Tooling

- `secret-guard.sh` — 14 regex patterns blocking common secret formats in staged diffs (AWS keys, GitHub tokens, private keys, etc.). Runs in the pre-commit hook chain.
- `tmp-igbkp/archive.sh` — encrypted snapshots use AES-256-CBC with PBKDF2 600k iterations. Password is interactive only (never CLI arg), preventing shell-history leak.

## Compromise Containment

1. `systemctl --user disable --now agentmemory.service` — kill the memory service.
2. `/plugin marketplace remove <name>` for each suspect marketplace.
3. `rm -rf ~/.claude/plugins/cache/<plugin>` to wipe cached plugin code.
4. Rotate any credentials present in `~/.codex/config.toml` or referenced by `.mcp.json`.
5. Re-install from a verified SHA256 of `install.sh`.

## Out of Scope

- Upstream vulnerabilities in third-party plugins (report to their respective repos).
- Claude Code or MCP runtime bugs (report to Anthropic / MCP maintainers).
