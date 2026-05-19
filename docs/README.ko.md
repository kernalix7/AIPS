<div align="center">

# AIPS

### 매 프로젝트마다 AI 셋업 다시 하기, 이제 그만.

<p><b>AIPS v7.0</b>은 <b>hybrid global-first</b> 아키텍처의 Claude Code plugin입니다. install 한 번으로 <code>~/.claude/</code>에 똑똑한 global들이 깔리고, 각 프로젝트에서 <code>/aips:init</code>이 팀 공유에 꼭 필요한 만큼만 — agent rule, work state, MCP config, 암호화 백업 — per-project로 심어줍니다. Hook은 크래시를 살아남고, memory는 <code>/clear</code>를 살아남고, sessions는 프로젝트 이름 변경까지 살아남습니다.</p>

<pre><code># 머신당 1회
curl -fsSL https://raw.githubusercontent.com/kernalix7/AIPS/main/install.sh | bash

# 프로젝트당 1회
cd my-project && claude
&gt; /aips:init
</code></pre>

[![Status](https://img.shields.io/badge/v7.0.0-stable-2EA44F?style=for-the-badge)](../CHANGELOG.md)
[![Released](https://img.shields.io/badge/released-2026--05--19-2962FF?style=for-the-badge)](../CHANGELOG.md)

[![license](https://img.shields.io/github/license/kernalix7/AIPS?style=flat-square&color=blue)](../LICENSE)
[![plugin](https://img.shields.io/badge/Claude%20Code-plugin-7C3AED?style=flat-square&logo=anthropic&logoColor=white)](https://claude.com/claude-code)
[![commands](https://img.shields.io/badge/slash%20commands-11-2EA44F?style=flat-square)](#슬래시-명령)
[![deps](https://img.shields.io/badge/bundled%20plugins-4-blue?style=flat-square)](#무엇이-어디에-깔리나)
[![stars](https://img.shields.io/github/stars/kernalix7/AIPS?style=flat-square&color=FFD93D&logo=github&logoColor=white)](https://github.com/kernalix7/AIPS/stargazers)
[![PRs](https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square)](../CONTRIBUTING.md)

###### 호환 도구

[![Claude Code](https://img.shields.io/badge/Claude%20Code-2.0%2B-7C3AED?style=flat-square&logo=anthropic&logoColor=white)](https://claude.com/claude-code)
[![Codex CLI](https://img.shields.io/badge/Codex%20CLI-0.10%2B-10B981?style=flat-square&logo=openai&logoColor=white)](https://github.com/openai/codex)
[![Cursor](https://img.shields.io/badge/Cursor-0.40%2B-000000?style=flat-square&logo=cursor&logoColor=white)](https://cursor.sh)
[![GitHub Copilot](https://img.shields.io/badge/Copilot-1.150%2B-24292F?style=flat-square&logo=githubcopilot&logoColor=white)](https://github.com/features/copilot)
[![MCP](https://img.shields.io/badge/MCP-aware-FF6B6B?style=flat-square)](https://modelcontextprotocol.io)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](#)
[![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white)](#)
[![Windows](https://img.shields.io/badge/Windows-Git%20Bash-0078D6?style=flat-square&logo=windows&logoColor=white)](#)

<sub>[English](../README.md) &nbsp;·&nbsp; **한국어** &nbsp;·&nbsp; [install.sh](../install.sh) &nbsp;·&nbsp; [기여](../CONTRIBUTING.md) &nbsp;·&nbsp; [보안](../SECURITY.md) &nbsp;·&nbsp; [체인지로그](../CHANGELOG.md)</sub>

</div>

---

### 상태: v7.0.0 stable — 2026-05-19 릴리스

AIPS v7.0이 현재 지원되는 stable 릴리스입니다. 11개 `/aips:*` slash command, hybrid global-first 레이아웃, 4개 bundled plugin, 3줄 statusline 모두 자리잡았고 Linux, macOS, Git Bash / WSL에서 검증되었습니다. v6.0을 쓰고 있다면 마이그레이션은 단일 명령(`/aips:upgrade --to v7.0`)이고, strict 모드 결과는 fresh v7.0 install과 바이트 단위로 동일합니다.

---

## 목차

- [왜 이것이 존재하나](#왜-이것이-존재하나)
- [빠른 시작](#빠른-시작)
- [무엇이 어디에 깔리나](#무엇이-어디에-깔리나)
- [라이프사이클](#라이프사이클)
- [Statusline](#statusline)
- [슬래시 명령](#슬래시-명령)
- [마이그레이션](#마이그레이션)
- [지원 AI 도구](#지원-ai-도구)
- [비교](#비교)
- [문서](#문서)
- [자주 묻는 질문](#자주-묻는-질문)
- [로드맵](#로드맵)
- [Star history](#star-history)
- [후원](#후원)
- [라이선스](#라이선스)

---

## 왜 이것이 존재하나

이런 경험 있죠:

- 새 repo clone하고 한 시간 동안 `CLAUDE.md`, `.cursorrules`, `AGENTS.md`, 같은 hook 4개, 같은 backup script 9개를 다시 배선.
- 2시간짜리 세션이 `/clear` 한 번으로 사라짐 — handoff 작성한 사람 아무도 없음.
- 새 노트북에 RTK와 caveman을 다시 설치하면서 어떤 순서가 맞는지 까먹음.
- 실제 작업 들어가기 전에 AI가 setup 문서 읽느라 25k 토큰 태우는 걸 멍하니 바라봄.
- 프로젝트 디렉터리 이름 바꿨다가 session 히스토리가 증발.

AIPS v7.0은 한 가지 원칙으로 이 모두를 해결합니다: **global이어야 하는 state는 global에 살고, local이어야 하는 state는 local에 산다. 어떤 것도 중복되지 않는다.**

| AIPS 없이 | AIPS v7과 함께 |
|---|---|
| CLAUDE.md를 매번 처음부터 손으로 작성 — 시간 단위 | `/aips:init` — ~30초 |
| Hook, agent, statusline을 프로젝트마다 복사 | 머신당 한 번 `~/.claude/`에 깔리고 모든 프로젝트가 상속 |
| Crash / compact / `/clear`에 세션 분실 | 3단계 autosave (current / handoff / recovery) — 다음 시작 시 자동 로드 |
| Memory가 한 repo 경로에 묶임 | `~/.claude/projects/`에 path-hash 키로 저장 — `/aips:rebind`로 이름 변경에도 생존 |
| 모든 repo에 22줄짜리 `.gitignore` 블록 | `~/.config/git/ignore` 한 블록이면 모든 repo가 공짜로 받음 |
| 매 세션 AI가 7,600줄 setup 문서를 읽음 | AI는 ~150줄 CLAUDE.md만 읽음, 나머지는 shell 레벨에서 결정론적 |

---

## 빠른 시작

**머신당 1회** — 앞으로 열 모든 프로젝트에 적용:

```bash
curl -fsSL https://raw.githubusercontent.com/kernalix7/AIPS/main/install.sh | bash
```

`install.sh`가 하는 일:

1. AIPS marketplace를 `~/.claude/`에 등록
2. **4개 bundled plugin** install / update:
   - **codex-plugin-cc** — `/codex:*` 명령 (Claude ↔ Codex relay)
   - **caveman** — ultra-terse output style + `/caveman*` 명령
   - **agentmemory** + systemd unit — file-backed memory + 자동 백업
   - **RTK** (Rust Token Killer) — 60–90% 토큰 절감 CLI 프록시
3. hook / agent / command / skill / output-style / statusline을 `~/.claude/`에 배치
4. Toolkit script (`~/.local/bin/aips-*`)와 AIPS gitignore 블록(`~/.config/git/ignore`) globalize

**프로젝트당**:

```bash
cd my-project
claude
> /aips:init
```

`/aips:init`이 4개 케이스를 자동 감지:

| 케이스 | 트리거 | 동작 |
|---|---|---|
| **A. 신규** | `.priv-storage/` 없음, v5.x `.md`도 없음 | fresh init (~30초) |
| **B. v5.x 마이그레이션** | 루트에 `AI_PROJECT_SETUP.md` 감지 | 확인 → 백업 → 정리 → v7.0 init |
| **C. 재init (idempotent)** | `.priv-storage/` v7.0 marker 존재 | drift 복구, destructive 동작 없음 |
| **D. 복구** | 손상된 부분 상태 감지 | 선택적 재구성 repair 모드 |

끝. 모든 산출물은 gitignore 처리 — git 히스토리는 깨끗합니다. 언제든 `/aips:health`로 검증 가능.

---

## 무엇이 어디에 깔리나

v7.0은 깔끔한 분리를 유지합니다: 머신당 한 번 깔리는 똑똑한 global, 각 repo에는 최소 필요량의 per-project state. 어떤 것도 중복되지 않음.

### Global — `~/.claude/` + `~/.local/bin/` + `~/.config/git/ignore`

`install.sh`로 한 번에 설치. 모든 프로젝트가 상속.

| 카테고리 | 내용 |
|---|---|
| Plugins | 4개 bundled: `codex-plugin-cc`, `caveman`, `agentmemory` (+ systemd unit), `RTK` |
| Hooks | 5개: `PreToolUse`, `PostToolUse`, `SessionStart`, `PreCompact`, `Stop` |
| Agents | 3개 템플릿: `tech-lead`, `explorer`, `code-reviewer` |
| Commands | 15개: 11개 `/aips:*` + bundled plugin 명령 |
| Skills | on-demand 지식 모듈 (caveman, codex 등) |
| Output styles | `terse` (기본), `caveman/full`, `caveman/ultra` 등 |
| Statusline | 3줄 멀티 라인 (아래 미리보기) |
| Binaries | RTK Rust 바이너리 (`~/.local/bin/rtk`), aips-* toolkit symlinks |
| Daemons | agentmemory systemd unit (사용자 단위) |
| Sessions mirror | `~/.claude/sessions/{path-hash}/` — 프로젝트 이름 변경에도 생존 |
| Memory store | `~/.claude/projects/{path-encoded}/memory/` — single source of truth |
| Gitignore 블록 | `~/.config/git/ignore` — 22개 항목, repo별 노이즈 0 |

### Per-project — `.priv-storage/` (`/aips:init`)

```text
your-project/
|-- CLAUDE.md              -> .priv-storage/CLAUDE.md  (symlink)
|-- AGENTS.md              -> .priv-storage/CLAUDE.md  (symlink, Codex / Copilot)
|-- .cursorrules           -> .priv-storage/CLAUDE.md  (symlink, Cursor)
|-- WORK_STATUS.md         -> .priv-storage/WORK_STATUS.md
|
|-- .priv-storage/         [gitignored] 프로젝트별 AI state
|   |-- CLAUDE.md                   # 섹션 1-7 + 11만, ~150줄
|   |-- CLAUDE.local.md             # 개발자별 오버라이드
|   |-- WORK_STATUS.md              # 팀 공유 작업 상태
|   |-- sessions/                   # fast-write buffer; global mirror로 미러링
|   |-- agents/                     # tech-lead.md + 팀별 agent
|   `-- .mcp.json                   # 프로젝트별 MCP server registry
|
`-- tmp-igbkp/             [gitignored] 암호화 백업 산출물만
    `-- (aips-archive, aips-restore, aips-purge-history가 만든 archive)
```

> `WORK_STATUS.md`, GitHub 표준 파일, `docs/` 한국어 미러, `.github/`만 커밋됩니다. `.priv-storage/`와 `tmp-igbkp/`의 모든 것은 의도적으로 gitignore. `CLAUDE.md`는 섹션 **1–7 + 11** (~150줄)만 유지 — 8/9/10/12/13은 global plugin / skill / hook 레이어로 이전.

### 왜 이 분할인가

| 항목 | 위치 | 이유 |
|---|---|---|
| Toolkit script (`aips-archive`, `aips-restore` 등) | global | 단일 canonical 카피, 프로젝트별 drift 없음, PATH 한 번 lookup |
| Sessions mirror | global (프로젝트는 fast-write buffer 유지) | 프로젝트 디렉터리 이름 변경에도 생존, 단일 디렉터리로 머신 간 sync |
| Memory store | global only | single source of truth, dual-write drift 없음 |
| `.gitignore` AIPS 블록 | global | repo gitignore 노이즈 0, 모든 repo에 자동 적용 |
| `CLAUDE.md` 섹션 1–7 + 11 | per-project | 팀 공유 프로젝트 rule + 멀티 도구 보장 |
| `WORK_STATUS.md` | per-project | 팀 공유 작업 상태 — repo에 있어야 함 |
| `.mcp.json` | per-project | 프로젝트별 MCP server registry |
| `tech-lead.md` + team agents | per-project | 프로젝트별 팀 구성 |
| `tmp-igbkp/` 백업 산출물 | per-project | 암호화 archive는 백업 대상 프로젝트와 함께 있어야 함 |

---

## 라이프사이클

```text
[1. Global install] (머신당 1회)
  curl ... | bash
  - AIPS marketplace 등록 → ~/.claude/
  - 4개 bundled plugin install/update
  - hook/agent/command/skill/output-style/statusline 배치
  - Toolkit globalize (~/.local/bin/aips-*) + gitignore 블록
  - RTK 바이너리, agentmemory systemd unit 설치
        |
        v
[2. Project init] (프로젝트당 1회, ~30초)
  cd project && claude → /aips:init
  - 케이스 A/B/C/D 자동 분기
  - .priv-storage/ 생성, 심볼릭링크 3개 배치
  - CLAUDE.md 섹션 1-7 + 11 (~150줄)
  - global sessions mirror + memory store에 프로젝트 등록
        |
        v
[3. 일반 세션]
  - SessionStart hook이 직전 handoff + current.md 꼬리 자동 주입
  - AI는 CLAUDE.md (~150줄)만 읽음 — 7,600줄 .md 없음
  - PreToolUse가 위험 명령 + 과대 Read 차단
  - PostToolUse가 current.md 추가 + agentmemory dual-write
  - Stop hook이 handoff-{date}.md 기록
  - PreCompact hook이 recovery.md 기록 (best-effort)
  - 3줄 statusline 실시간 업데이트: project / window / savings
        |
        v
[4. Crash / rate-limit / /clear / rename]
  - 다음 세션 시작 시 SessionStart가 handoff + recovery 자동 로드
  - AI는 "어디까지 했죠?" 묻지 않고 이전 상태에서 이어감
  - 프로젝트 이름 바꿨나? `/aips:rebind <old-path>`로 global 재배선
        |
        v
[5. 업데이트] (트리거: /aips:update)
  - marketplace pull → 4개 bundled plugin update
  - global hook/command 자동 sync
  - 프로젝트는 손대지 않음 (재init 필요시 /aips:init)
```

---

## Statusline

3줄 멀티 라인. 세 번 슬쩍 보면 다 압니다: 뭘 하고 있는지, 예산이 얼마 남았는지, 얼마나 아꼈는지.

```
project [main*3] wip:2 | opus-4.7 | ctx:8%(15.5k/200k) | cache:71%
5h:8% ↻2h11m ∅1h23m | wk:12% ↻4d18h ∅2d4h
🦴cv:75%/full | 🧠am:40%/127 | 💰rtk:34% | 🤖cdx:55%/3runs | 💯Σ:95%
```

| 줄 | 표시 |
|---|---|
| 1 | 프로젝트명, git 브랜치 [지난 커밋 수], `wip` 카운트, 모델, 컨텍스트 사용률, prompt cache 히트율 |
| 2 | 5시간 윈도우 사용률 + reset까지 남은 시간(`↻`) + burn rate 기준 예상 소진 시간(`∅`); 주간 윈도우 동일 |
| 3 | caveman 절감률·강도, agentmemory 사용률·observation 수, RTK 절감률, codex 위임률·실행 수, 누적 절감률(`Σ`) |

`↻` = reset까지 남은 시간 · `∅` = burn rate 기준 예상 소진 시간 · `Σ` = 누적 절감률 (`Σ = 1 − Π(1 − SAVED_i / 100)`).

---

## 슬래시 명령

### AIPS 네이티브 — 11개

| | 명령 | 동작 |
|---|---|---|
| ⚙️ | `/aips:init` | 자동 분기 init (신규 / 마이그 / 재init / 복구) |
| 🔄 | `/aips:update` | marketplace pull + bundled plugin update |
| 🩺 | `/aips:health` | `verify-setup.sh` + `smoke-test-hooks.sh` |
| 🗑️ | `/aips:uninstall` | global + project 안전 제거 |
| 📊 | `/aips:status` | 현재 작업 + 최근 활동 요약 |
| 📜 | `/aips:migrate-from-md` | v5.x `.md` 명시적 마이그레이션 (B 케이스 수동 트리거) |
| ⬆️ | `/aips:upgrade` | 버전 업그레이드 — `--to v7.0` 플래그로 v6.0 → v7.0 hybrid 마이그레이션 |
| 🔧 | `/aips:repair` | 손상 상태 복구 (D 케이스 수동 트리거) |
| ♻️ | `/aips:reset` | 프로젝트 init 초기화 (백업 후) |
| 🔗 | `/aips:rebind <old-path>` | 프로젝트가 이동/이름 변경되었을 때 globalize state rebind |
| 🔍 | `/aips:scope` | global vs per-project 진단; drift / orphan 표시 |

### Bundled plugin 명령

| Plugin | 명령 |
|---|---|
| codex-plugin-cc | `/codex:brief`, `/codex:review`, `/codex:fix`, `/codex:relay-status` |
| caveman | `/caveman`, `/caveman:lite`, `/caveman:ultra`, `/caveman:wenyan-*` |
| agentmemory | `/am:save`, `/am:recall`, `/am:reflect`, `/am:consolidate`, `/am:sessions` |
| RTK | hook 기반 자동 — 명시 명령 없음 (`rtk gain`은 shell에서) |

> v5.x의 레거시 커스텀 `/codex-brief`, `/codex-review`, `/codex-fix`, `/codex-relay-status`는 v6.0에서 폐지. 공식 `codex-plugin-cc`의 `/codex:*`를 사용하세요.

---

## 마이그레이션

### v5.x에서 — `/aips:init`이 처리

```bash
cd existing-v5-project
claude
> /aips:init
# → 루트 AI_PROJECT_SETUP.md (v5.x) 감지
# → "v5.x 설치 감지. v7.0으로 마이그레이션할까요? [y/N]"
# → y 입력 시:
#   1. .priv-storage/v5-backup/ 에 전체 백업
#   2. 7,600줄 AI_PROJECT_SETUP.md → 30줄 DEPRECATED redirect로 축소
#   3. 커스텀 /codex-* 4개 제거 — codex-plugin-cc가 대체
#   4. CLAUDE.md를 섹션 1-7 + 11만 남기고 축소 (~150줄)
#   5. global sessions mirror + memory store에 등록
#   6. v7.0 marker 기록
```

명시적으로 트리거하려면: `/aips:migrate-from-md`.

### v6.0에서 — `/aips:upgrade --to v7.0`

```bash
cd existing-v6-project
claude
> /aips:upgrade --to v7.0
# → Strict 모드 (기본): 결과는 fresh v7.0 install과 동일.
#   per-project tmp-igbkp/*.sh + sessions/*.md는 global 카운터파트
#   검증 후 삭제. 전체 백업은 항상 tmp-igbkp/upgrade-v7-backup-{ts}/
#   에 먼저 저장.
# → --keep-local-fallback 전달 시 fallback 유지 (lenient).
```

### v7.0이 v6.0 대비 바꾼 것

| 항목 | v6.0 | v7.0 |
|---|---|---|
| Toolkit script | `tmp-igbkp/*.sh` 프로젝트별 복사 | `~/.local/bin/aips-*` symlink (단일 canonical 카피) |
| Sessions | `.priv-storage/sessions/`만 | 프로젝트 buffer + `~/.claude/sessions/{path-hash}/` mirror |
| Memory | 프로젝트별 + global (dual-write) | global only — `~/.claude/projects/{path-encoded}/memory/` |
| Gitignore | 모든 `.gitignore`에 22개 항목 | `~/.config/git/ignore`에 한 블록 |
| 새 명령 | — | `/aips:rebind`, `/aips:scope`, `/aips:upgrade --to v7.0` |

---

## 지원 AI 도구

**AIPS는 Claude Code를 1순위로 만들어졌습니다.** 그 외 도구는 `CLAUDE.md` / `AGENTS.md` / `.cursorrules`를 통한 정책 전용 지원이며, 동급 플러그인 패리티는 로드맵입니다.

### Tier 1 — 주 지원 / 완전

| 도구 | 최소 버전 | 읽는 파일 | 기능 |
|---|---|---|---|
| **Claude Code (CLI)** | 2.0+ | `CLAUDE.md` | 전체 플러그인 설치, 11개 `/aips:*` 명령, 5개 hook, 3줄 statusline, output style, 4개 bundled plugin |

### Tier 2 — 부분 지원 (정책만)

| 도구 | 최소 버전 | 읽는 파일 | 기능 |
|---|---|---|---|
| **ChatGPT Codex CLI** | 0.10+ | `AGENTS.md` → `CLAUDE.md` | 규칙만 (hook / slash / statusline 없음) |
| **Cursor** | 0.40+ | `.cursorrules` → `CLAUDE.md` | 규칙만 |
| **GitHub Copilot** | 1.150+ | `AGENTS.md` | 규칙만 |
| **claude.ai (웹)** | 현재 | `CLAUDE.md` 수동 업로드 | 규칙만 |
| **모든 MCP 지원 도구** | — | 도구별 상이 | `.mcp.json`만 |

> *정책만* = 규칙이 프롬프트 콘텐츠로 시행됨. 커널 레벨 차단도, hook도, slash 명령도, statusline도 없지만 AI가 읽는 규칙 파일에 명시되므로 따름.

### Tier 3 — 완전 지원 예정 (TBD)

Codex / Cursor / Copilot 대상 plugin 동급 패리티(hook, slash 명령, statusline, bundled-plugin 스택)는 로드맵입니다. [로드맵](#로드맵)에서 진행 상황 확인 또는 이슈로 업보트해 주세요.

---

## 비교

| | AIPS v7.0 | `.cursorrules`만 | 직접 작성한 CLAUDE.md | 아무것도 안 함 |
|---|:---:|:---:|:---:|:---:|
| 프로젝트당 setup 시간 | ~30초 | 즉시 | 시간 단위 | 0 |
| 결정론적 (AI 해석 없음) | yes | yes | yes | n/a |
| 도구 간 single source of truth | yes | Cursor만 | Claude만 | no |
| 1줄 global install | yes | no | no | n/a |
| 안전 hook (커널 레벨) | yes | no | 수동 | no |
| Crash / `/clear` 세션 복원 | yes (3단계) | no | 수동 | no |
| 3줄 statusline (절감률 포함) | yes | no | no | no |
| Cross-AI relay (Claude ↔ Codex) | yes (plugin) | no | no | no |
| 토큰 절감 (RTK + caveman + agentmemory) | yes | no | no | no |
| 업스트림 자가 업데이트 | yes (`/aips:update`) | no | no | n/a |
| 프로젝트 이름 변경 생존 | yes (`/aips:rebind`) | no | 수동 | no |
| Repo별 gitignore 노이즈 0 | yes (global ignore) | yes | no | yes |
| Linux / macOS / Windows | yes | yes | yes | n/a |

---

## 문서

| 문서 | 내용 |
|---|---|
| [install.sh](../install.sh) | 글로벌 install script |
| [README.md](../README.md) | 영문 README |
| [AI_PROJECT_SETUP.md](../AI_PROJECT_SETUP.md) | v5.2 아카이브 (다운스트림 raw-URL 호환용 30줄 DEPRECATED stub) |
| [CONTRIBUTING.md](../CONTRIBUTING.md) · [한국어](CONTRIBUTING.ko.md) | 개발 환경, 버전 bump 체크리스트, PR 규약 |
| [SECURITY.md](../SECURITY.md) · [한국어](SECURITY.ko.md) | 보안 공개 프로세스, secret-guard 패턴 |
| [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md) · [한국어](CODE_OF_CONDUCT.ko.md) | Contributor Covenant v2.1 |
| [CHANGELOG.md](../CHANGELOG.md) · [한국어](CHANGELOG.ko.md) | 전체 버전 히스토리 |

---

## 자주 묻는 질문

<details>
<summary><b>왜 CLAUDE.md를 150줄로 줄였나? 다 때려넣지 않고?</b></summary>

매 세션 AI가 로드하니까요. 토큰 절제 = 당신의 지갑. 나머지 12개 정책 섹션은 global hook, skill, output-style에 살고 — AI가 다시 읽지 않아도 결정론적으로 실행됩니다.
</details>

<details>
<summary><b>v6.0에서 강제로 옮겨야 하나요?</b></summary>

아니요, v6.0은 계속 동작합니다. v7.0은 opt-in, non-breaking. 단일 canonical toolkit, sessions mirror, global gitignore, single-source memory가 필요할 때 `/aips:upgrade --to v7.0` 실행하세요.
</details>

<details>
<summary><b>v7.0 init 이후 프로젝트 이름을 바꾸거나 이동했어요.</b></summary>

새 위치의 프로젝트 안에서 `/aips:rebind <old-path>`. path-hash 키 global(`~/.claude/sessions/{path-hash}/`, memory 매핑)을 다시 작성해서 sessions와 memory가 동일 프로젝트로 계속 해석되게 합니다.
</details>

<details>
<summary><b>무엇이 global이고 무엇이 per-project인지 어떻게 확인하나요?</b></summary>

`/aips:scope`. 현재 프로젝트 산출물이 어디 사는지 출력하고, drift(per-project sessions buffer가 global mirror보다 앞섬)나 orphan(존재하지 않는 프로젝트 디렉터리에 대한 global state)을 표시합니다.
</details>

<details>
<summary><b>install.sh가 시스템 어디를 건드리나요?</b></summary>

`~/.claude/`, `~/.local/bin/`, `~/.config/git/ignore`, 사용자 단위 systemd unit (agentmemory). 시스템 전역 디렉터리(`/usr/local/`, `/etc/`)는 건드리지 않습니다. uninstall은 `/aips:uninstall`.
</details>

<details>
<summary><b>왜 plugin 4개를 묶었나? 골라서 쓰면 안 되나?</b></summary>

각각 직교 가치 — codex-plugin-cc (relay), caveman (출력 압축), agentmemory (영구 memory), RTK (CLI 토큰 절감). 따로 설치하면 hook 순서와 statusline fallback 처리가 복잡해집니다. 묶음으로 cross-plugin 동기화 보장; 그래도 Claude Code plugin 설정으로 개별 비활성화는 가능합니다.
</details>

<details>
<summary><b>오프라인에서 동작하나요?</b></summary>

install / update는 네트워크 필요 (marketplace pull, RTK 바이너리 페치). 일반 세션과 `/aips:init`은 오프라인 동작 — 모든 산출물은 로컬 plugin store에서 읽음.
</details>

<details>
<summary><b>여러 머신에서 동기화하려면?</b></summary>

agentmemory가 프로젝트 memory를 `~/.claude/projects/{path-encoded}/memory/`에 기록합니다. 새 머신에서: `install.sh` → 프로젝트에서 `/aips:init` → memory dir만 rsync. Sessions mirror도 `~/.claude/sessions/` 아래에서 동일하게 동작.
</details>

<details>
<summary><b>Windows는?</b></summary>

Git Bash, WSL, MSYS2 동작. install.sh는 bash, hook도 bash이므로 네이티브 PowerShell은 미지원. WSL 권장.
</details>

<details>
<summary><b>같은 프로젝트에서 여러 AI 도구?</b></summary>

네. Claude Code는 `CLAUDE.md`, Codex / Copilot은 `AGENTS.md`, Cursor는 `.cursorrules` — 세 파일 모두 동일한 `.priv-storage/CLAUDE.md` 심볼릭링크라서 업데이트가 원자적입니다. 다만 hook, statusline, slash 명령은 Claude Code 전용.
</details>

<details>
<summary><b>marketplace 안 쓰고 그냥 clone해도?</b></summary>

가능. repo clone 후 로컬 경로로 `install.sh` 실행 — marketplace 등록 단계가 로컬 경로로 fallback. fork 환경과 air-gapped 환경에서 유용.
</details>

<details>
<summary><b>버그 / 기능 요청.</b></summary>

<https://github.com/kernalix7/AIPS>에서 이슈나 PR을 열어주세요. [CONTRIBUTING.md](../CONTRIBUTING.md) 참조.
</details>

---

## 로드맵

- **v7.0.0** *(stable, 2026-05-19)* — Hybrid global-first: toolkit / sessions / memory / gitignore globalize, 새 `/aips:*` 명령 3개 (`upgrade --to v7.0`, `rebind`, `scope`), strict-by-default non-breaking 마이그레이션
- **v7.1** — agentmemory 심화 통합: cross-project workflow 추천, `/am:recall`에 공유 lesson surface 노출
- **v7.2** — `/aips:rebind` UX: path-hash heuristic으로 이동된 프로젝트 auto-detect; `<old-path>` 명시 없이 1-command 복구
- **v7.3** — Tier 2 → Tier 1 승격 실험: wrapper shim으로 Codex CLI에 hook / statusline 지원 프로토타입
- **v8.0 (candidate)** — opt-in cloud sync 기반 team-shared global, 또는 third-party AIPS 확장용 full plugin marketplace 퍼블리싱

버전 히스토리는 [CHANGELOG.md](../CHANGELOG.md) 참조.

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

## 후원

AIPS가 설정 시간을 절약해줬다면:

[![Ko-fi](https://img.shields.io/badge/Ko--fi-F16061?logo=ko-fi&logoColor=white&style=for-the-badge)](https://ko-fi.com/kernalix7)
[![Fairy](https://img.shields.io/badge/Fairy-EE6E73?style=for-the-badge&logoColor=white)](https://fairy.hada.io/@kernalix7)

Ko-fi는 해외 카드와 PayPal을 처리하고, fairy.hada.io는 한국 팁 플랫폼입니다. 버그 신고, PR, 스타도 똑같이 감사하고 무료입니다.

---

## 라이선스

[MIT](../LICENSE) — Kim DaeHyun ([kernalix7@kodenet.io](mailto:kernalix7@kodenet.io))

<div align="center">

[버그 신고](https://github.com/kernalix7/AIPS/issues/new?template=bug_report.md) &nbsp;·&nbsp; [기능 요청](https://github.com/kernalix7/AIPS/issues/new?template=feature_request.md) &nbsp;·&nbsp; [English README](../README.md)

</div>
