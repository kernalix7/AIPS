<div align="center">

# ai-project-setup

### 파일 하나 던지고, AI한테 읽으라고 시키면 끝.

<p>마크다운 7,000줄짜리 단일 부트스트랩이 <b>Claude Code, ChatGPT Codex CLI, Cursor, GitHub Copilot</b>을 규율 있는 팀원으로 바꿔줍니다 — 13-섹션 규칙, 5개 안전 훅, 세션 복원, 듀얼 라이트 메모리, 이중 언어 GitHub 파일. <b>설치 불필요. 단일 진실 공급원.</b></p>

<pre><code># 부트스트랩 파일 다운로드
curl -fsSL https://raw.githubusercontent.com/kernalix7/ai-project-setup/main/AI_PROJECT_SETUP.md > AI_PROJECT_SETUP.md

# AI 도구 열고 이렇게 말하기:
#   "AI_PROJECT_SETUP.md 읽고 실행해줘"
#   "Read AI_PROJECT_SETUP.md and execute it."

# 1~3분 후 검증:
./tmp-igbkp/verify-setup.sh   # → Pass: 83  Fail: 0  Warn: 0
</code></pre>

[![Stable](https://img.shields.io/badge/status-stable-2EA44F?style=for-the-badge)](#-상태-v52-안정)
[![Latest](https://img.shields.io/badge/latest-v5.2-2962FF?style=for-the-badge)](../AI_PROJECT_SETUP.md)

[![license](https://img.shields.io/github/license/kernalix7/ai-project-setup?style=flat-square&color=blue)](../LICENSE)
[![markdown](https://img.shields.io/badge/markdown-CommonMark-083FA1?style=flat-square&logo=markdown&logoColor=white)](../AI_PROJECT_SETUP.md)
[![checks](https://img.shields.io/badge/checks-83%2B-2EA44F?style=flat-square)](../AI_PROJECT_SETUP.md)
[![scripts](https://img.shields.io/badge/scripts-9-blue?style=flat-square)](../AI_PROJECT_SETUP.md)
[![stars](https://img.shields.io/github/stars/kernalix7/ai-project-setup?style=flat-square&color=FFD93D&logo=github&logoColor=white)](https://github.com/kernalix7/ai-project-setup/stargazers)
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

<sub>[English](../README.md) &nbsp;·&nbsp; **한국어** &nbsp;·&nbsp; [부트스트랩 파일](../AI_PROJECT_SETUP.md) &nbsp;·&nbsp; [기여](../CONTRIBUTING.md) &nbsp;·&nbsp; [보안](../SECURITY.md) &nbsp;·&nbsp; [체인지로그](../CHANGELOG.md)</sub>

</div>

---

### 📌 상태: v5.2 안정

> ai-project-setup은 **단일 파일 부트스트랩**(`AI_PROJECT_SETUP.md`, ~7,600줄)을 제공하며, 모든 AI 코딩 어시스턴트가 이를 읽고 실행하면 완전한 멀티 도구 · gitignore된 AI 도구 레이아웃이 생성됩니다. v5.2는 첫 정식 GitHub 저장소 릴리즈입니다. 확장된 README, 이중 언어 표준 문서, 이슈/PR 템플릿, 더 엄격한 no-footprint `.gitignore`를 포함합니다. v5.1부터 자가 업데이트 소스가 gist에서 이 저장소로 이동했습니다. v5.0 이하 프로젝트는 레거시 gist에서 v5.1을 한 번 페치(마이그레이션 다리로 고정)한 뒤, 이후 모든 업데이트는 이곳에서 가져옵니다. 산출물은 **멱등적이고 자가 치유적**입니다 — 기존 프로젝트에서 setup을 다시 실행하면 drift를 복구하고, 스테일한 출하 스크립트를 `.bak` 백업과 함께 강제 덮어쓰며, 사용자 콘텐츠(`CLAUDE.md` 1–7 및 11 섹션, 메모리, 프로젝트 에이전트)는 보존합니다.

**파일 하나, 모든 AI 도구.** [`AI_PROJECT_SETUP.md`](../AI_PROJECT_SETUP.md)를 프로젝트 루트에 놓고 AI에게 읽으라고 시키면 1~3분 안에 규칙 · 훅 · 세션 복원 · 슬래시 커맨드 · 기본 에이전트 · 백업 툴킷 · 이중 언어 GitHub 표준 파일이 갖춰집니다. 모두 gitignore 처리되어 프로젝트 git 히스토리는 깨끗합니다. **절대 규칙 #19**: AI 도구는 프로젝트 git 히스토리에 흔적을 남기지 않습니다.

---

## 📑 목차

- [왜 만들었나](#-왜-만들었나)
- [빠른 시작](#-빠른-시작)
- [생성되는 것](#-생성되는-것)
- [라이프사이클](#-라이프사이클)
- [주요 기능](#-주요-기능)
- [지원 AI 도구](#-지원-ai-도구)
- [비교](#%EF%B8%8F-비교)
- [문서](#-문서)
- [자가 업데이트](#-자가-업데이트)
- [Fork](#-fork)
- [자주 묻는 질문](#-자주-묻는-질문)
- [로드맵](#%EF%B8%8F-로드맵)
- [Star history](#-star-history)
- [후원](#-후원)
- [라이선스](#-라이선스)

---

## 🎯 왜 만들었나

새 프로젝트마다 매번 반복하는 AI 설정 작업을 여러 AI 도구에 걸쳐 **한 번에, 결정론적으로** 끝냅니다:

| 매번 반복하던 일 | 이 파일이 자동으로 |
|---|---|
| `CLAUDE.md` / `AGENTS.md` / `.cursorrules` 직접 작성 | ✅ 13개 섹션 생성 + 3개 도구 심볼릭링크 동기화 |
| 위험 명령(`rm -rf /`, force push, secret 유출) 차단 | ✅ 커널 레벨 `PreToolUse` 훅 |
| `/clear` · 크래시 · rate-limit 대비 세션 복원 | ✅ 3-tier 자동 저장 (current/handoff/recovery) |
| 메모리 · 슬래시 커맨드 · 기본 에이전트 셋업 | ✅ 10+ 커맨드 + 4개 에이전트 자동 설치 |
| README / SECURITY / CONTRIBUTING / CHANGELOG | ✅ EN/KO 이중 언어 생성 |
| AI 도구 파일이 git 히스토리에 새지 않도록 | ✅ `.gitignore` 22개 항목 자동 적용 |

---

## ⚡ 빠른 시작

원라이너 (모든 git 저장소에서):

```bash
curl -fsSL https://raw.githubusercontent.com/kernalix7/ai-project-setup/main/AI_PROJECT_SETUP.md \
  > AI_PROJECT_SETUP.md
```

그런 다음 AI 도구를 열고 파일을 실행하도록 지시:

```bash
claude       # 또는: codex, cursor ., VS Code + Copilot
```

AI에게 (한국어/영어 모두 가능):

> `AI_PROJECT_SETUP.md 읽고 실행해줘`
>
> Read `AI_PROJECT_SETUP.md` and execute it.

1~3분 기다린 후 검증:

```bash
./tmp-igbkp/verify-setup.sh
# → Pass: 83  Fail: 0  Warn: 0 — All required checks passed
```

끝. 생성된 모든 항목은 gitignore 처리되어 프로젝트 git 히스토리는 깨끗하게 유지됩니다.

---

## 📦 생성되는 것

```text
your-project/
|-- CLAUDE.md              -> .priv-storage/CLAUDE.md 심볼릭링크
|-- AGENTS.md              -> .priv-storage/CLAUDE.md 심볼릭링크  # Codex / Copilot
|-- .cursorrules           -> .priv-storage/CLAUDE.md 심볼릭링크  # Cursor
|-- WORK_STATUS.md         -> 현재 작업 상태 (프로젝트 콘텐츠)
|
|-- .priv-storage/         [gitignored] 모든 AI 도구 파일
|   |-- CLAUDE.md                   # 13-섹션 프로젝트 규칙 (~10kB 한도)
|   |-- CLAUDE.local.md             # 개발자별 오버라이드
|   |-- POST_SETUP_INDEX.md         # 50줄 포인터 (세션당 ~25k 토큰 절약)
|   |-- AI_PROJECT_SETUP.md         # 아카이브, 재읽기 안 함
|   |-- memory/                     # ~/.claude/projects/ 듀얼 라이트 (장비 간 동기화)
|   |-- sessions/                   # current.md, handoff-{date}.md, recovery.md, read-log.tsv
|   `-- .claude/
|       |-- settings.json           # statusLine + 5개 훅 + outputStyle
|       |-- hooks/                  # PreToolUse / PostToolUse / SessionStart / PreCompact / Stop
|       |-- agents/                 # tech-lead, explorer, code-reviewer, log-analyzer
|       |-- commands/               # 10+ 슬래시 커맨드
|       |-- skills/ and rules/      # 온디맨드 지식 파일
|       |-- output-styles/terse.md
|       `-- statusline              # 컨텍스트 사용률 / rate-limit ETA
|
|-- tmp-igbkp/             [gitignored] 백업 및 검증 툴킷 (9개 스크립트)
|   |-- verify-setup.sh             # 원커맨드 헬스 체크 (83+ 항목)
|   |-- smoke-test-hooks.sh         # mock 페이로드로 훅 검증
|   |-- secret-guard.sh             # 14-패턴 pre-commit 스캐너
|   |-- archive.sh / restore.sh     # AES-256-CBC + PBKDF2 60만 반복
|   |-- purge-history.sh            # git-filter-repo 래퍼
|   |-- setup-worktree.sh           # worktree를 메인 .priv-storage/에 연결
|   |-- codex-relay-{check,run}.sh  # Claude <-> Codex 병렬 레인
|   `-- uninstall.sh                # 백업 후 안전 롤백
|
|-- .mcp.json              [gitignored] MCP 서버 레지스트리 (env-var 참조만)
|
|-- README.md, SECURITY.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md, CHANGELOG.md
|-- docs/{README,SECURITY,CONTRIBUTING,CODE_OF_CONDUCT,CHANGELOG}.ko.md
`-- .github/{ISSUE_TEMPLATE/,PULL_REQUEST_TEMPLATE.md}
```

> `WORK_STATUS.md`, GitHub 표준 파일, `docs/` 한국어 미러, `.github/`만 커밋됩니다. `.priv-storage/`와 `tmp-igbkp/` 안의 모든 것은 의도적으로 gitignore 처리됩니다.

---

## 🔄 라이프사이클

```text
[1. 초기 설정]
  프롬프트: "AI_PROJECT_SETUP.md 읽고 실행해줘"
  - 시나리오 A/B/C 자동 감지
  - 위 항목을 생성한 뒤 STEP 6 실행
  - AI_PROJECT_SETUP.md를 .priv-storage/로 아카이브
  - automode-validate.sh 통과 시에만 "Setup Complete" 출력

        |
        v

[2. 일반 세션]
  - SessionStart 훅이 직전 handoff + current.md 꼬리 자동 주입
  - AI는 CLAUDE.md (~200줄) + POST_SETUP_INDEX.md (~50줄)만 읽음
  - 7000줄짜리 부트스트랩 파일은 다시 읽지 않아 세션당 ~25k 토큰 절약
  - PreToolUse가 위험 명령 + 과대 Read 차단
  - PostToolUse가 current.md에 추가 + 메모리 듀얼 라이트
  - Stop 훅이 handoff-{date}.md 기록
  - PreCompact 훅이 recovery.md 기록 (best-effort)

        |
        v

[3. 크래시 / rate-limit / /clear]
  - 다음 세션 시작 시 SessionStart가 handoff + recovery 자동 로드
  - AI가 "어디까지 했죠?" 물어보지 않고 이전 상태에서 이어서 작업

        |
        v

[4. 자가 업데이트]
  트리거: "AI_PROJECT_SETUP 업데이트해" 또는 "update setup"
  - GitHub raw URL에서 최신 페치
  - 아카이브된 setup 파일 교체
  - 30+ 출하 스크립트를 .bak 백업과 함께 강제 덮어쓰기
  - automode-validate 게이트 재실행
  - 보고: "Updated: vOLD -> vNEW. Recommend /clear."
```

### 3가지 설정 시나리오

| 시나리오 | 적용 조건 | AI가 하는 일 |
|----------|-----------|--------------|
| **A — 기존** | `.priv-storage/` 존재 또는 루트에 실제 `CLAUDE.md` | 인플레이스 업데이트/복구. 출하 스크립트는 `.bak`과 함께 강제 덮어쓰기, 사용자 콘텐츠 보존. |
| **B — 빈/신규** | `.priv-storage/`도 없고 루트에 `CLAUDE.md`도 없음 | 처음부터 전체 설정 — STEP 0 감지 → STEP 1–12 → 아카이브. |
| **C — 깨진** | `CLAUDE.md`처럼 보이지만 아닌 파일 또는 부분적 잔재 | 감지 → 분류 → 정식 레이아웃으로 변환 → 시나리오 A의 STEP 4–12에 연결. |

---

## ✨ 주요 기능

<table>
<tr><td width="50%">

**🛡️ 안전 훅** *(Claude Code)*
- `PreToolUse`가 `rm -rf /`, force push, gitignore된 AI 파일의 `git add`, `eval`, `base64 | sh`, `curl http://`, `~/.ssh` 읽기, fork bomb 차단
- 과대 `Read` 차단 (`offset`/`limit` 없는 >1000줄)
- AI 도구 언급 커밋 메시지 차단
- `PostToolUse`가 `sessions/current.md`에 추가 + 메모리 듀얼 라이트
- `SessionStart`가 직전 handoff + current.md 꼬리 + recovery 자동 로드
- `PreCompact`가 recovery.md 스냅샷 기록 (best-effort)
- `Stop`이 `handoff-{date}.md` 기록 + 오래된 handoff 아카이브

</td><td width="50%">

**🔄 회복성**
- 3-tier 세션 로그: `current.md` (매 호출) → `handoff-{date}.md` (세션 종료) → `recovery.md` (compact 전)
- 메모리 듀얼 라이트: 모든 메모리 파일을 `~/.claude/projects/{path-encoded}/memory/`에 미러링 → 새 노트북에서 즉시 복원
- 멱등 설정: `.priv-storage/.setup-step-{N}.done`에 SHA256 마커
- 업데이트마다 출하 스크립트 강제 덮어쓰기 (`.bak`과 함께) — 스테일 버그 자동 해결
- 83+ 항목 `verify-setup.sh` — 원커맨드 헬스 체크
- `smoke-test-hooks.sh`가 mock 페이로드로 각 훅 검증

</td></tr>
<tr><td width="50%">

**🤖 기본 에이전트** *(토큰 효율)*
- **`tech-lead`** — 복잡도 자동 평가, 팀 구성 (모듈 ≥ 2 OR 파일 ≥ 5 OR 크로스 모듈 작업)
- **`explorer`** — 읽기 전용 코드베이스 검색, 요약 반환, 메인 컨텍스트 보존
- **`code-reviewer`** — 보안/정확성/스타일 리뷰
- **`log-analyzer`** — 크래시 로그 / 훅 에러 로그 파싱
- 서브에이전트 위임 **필수** (>3 파일, >500줄, 코드베이스 전체 검색)

</td><td width="50%">

**⚡ 슬래시 커맨드**
- **`/status`** — 현재 작업 + 최근 활동 요약
- **`/health`** — verify-setup.sh + smoke-test-hooks.sh 실행
- **`/recover`** — 최신 handoff + recovery를 컨텍스트로 로드
- **`/ship`** — pre-commit secret-guard + clean 체크
- **`/save`** — current.md에 수동 스냅샷
- **`/clean`** — 오래된 handoff 로테이션, 세션 prune
- **`/codex-{brief,review,fix,relay-status}`** — Claude ↔ Codex 병렬 레인

</td></tr>
<tr><td width="50%">

**💰 토큰 규율** *(절대 규칙 #20)*
- `CLAUDE.md`는 16k 문자 (WARN) / 32k (FAIL) 하드캡
- `PreToolUse`가 `offset`/`limit` 없는 >1000줄 파일 `Read`를 **차단**
- 서브에이전트 위임 필수
- `read-log.tsv`가 세션 내 중복 Read 경고
- 추론이 요청될 때만 terse → verbose 자동 확장
- **예상 효과: naive AI-pair-programming 대비 30~60% 토큰 절감**

</td><td width="50%">

**🔐 시크릿 가드**
- 14개 정규식 패턴: `AKIA…`, `ASIA…`, `sk-…`, `sk-proj-…`, `ghp_…`, `ghs_…`, `gho_…`, `glpat-…`, `xox[abprs]-…`, `sk_live_…`, `rk_live_…`, `AIza…`, JWT, `-----BEGIN PRIVATE KEY-----`
- 특수 `.mcp.json` 규칙 — env-var 참조만 허용
- false positive용 라인별 `# secret-guard:ignore` allow-list
- `--install-hook` 모드로 git pre-commit에 연결
- 아카이브 백업용 AES-256-CBC + PBKDF2 60만 반복

</td></tr>
<tr><td width="50%">

**🌏 멀티 도구 패리티**
- 동일한 `CLAUDE.md`가 Claude Code, Codex CLI, Cursor, Copilot을 심볼릭링크로 구동
- 3개 규칙 파일(`CLAUDE.md` / `AGENTS.md` / `.cursorrules`)이 같은 타깃을 가리킴 — 원자적 업데이트
- MCP 서버는 gitignore된 `.mcp.json`에 등록 (env-var 참조만)
- VS Code 설정도 Copilot 통합을 위해 심볼릭링크
- 훅은 Claude Code 전용; 다른 도구는 정책 기반 적용

</td><td width="50%">

**🔀 Cross-AI Codex 릴레이** *(v4.9+, Claude Code 전용)*
- `codex` CLI가 `PATH`에 있으면 Claude가 구현을 Codex에 위임하고 자신은 계획/리뷰 권한 유지
- 흐름: Claude *(계획)* → `/codex-brief` → Codex *(구현)* → Claude *(`/codex-review`)* → Codex *(`/codex-fix`)*
- v5.0+는 TeamCreate 작업을 위한 에이전트별 병렬 릴레이 레인
- 충돌 방지: `paths_overlap` 검사로 레인당 disjoint allowed-paths
- `.priv-storage/sessions/codex-relay/locks/`의 락파일 + `active.tsv` 원장

</td></tr>
</table>

---

## 🤝 지원 AI 도구

| 도구 | 최소 버전 | 읽는 파일 | 훅 지원 |
|------|-----------|----------|---------|
| **Claude Code** | 2.0+ | `CLAUDE.md` | ✅ 전체 (5개 훅 이벤트) |
| **ChatGPT Codex CLI** | 0.10+ | `AGENTS.md` → `CLAUDE.md` | ❌ 정책만 |
| **Cursor** | 0.40+ | `.cursorrules` → `CLAUDE.md` | ❌ 정책만 |
| **GitHub Copilot** | 1.150+ | `AGENTS.md` | ❌ 정책만 |
| **claude.ai (웹)** | 현재 버전 | `CLAUDE.md` 수동 업로드 | ❌ 정책만 |
| **모든 MCP 지원 도구** | — | 도구별 상이 | ❌ 정책만 |

> *정책만* = 규칙이 프롬프트 콘텐츠로 시행됨. 커널 레벨 차단은 없지만, AI가 읽는 규칙 파일에 명시되어 있으므로 따름.

---

## ⚖️ 비교

| | 이 파일 | `.cursorrules`만 | 직접 작성한 CLAUDE.md | 도구별 CLI 툴 |
|---|:---:|:---:|:---:|:---:|
| 도구 간 단일 진실 공급원 | ✅ | ❌ Cursor만 | ❌ Claude만 | ❌ |
| 설치 불필요 | ✅ | ✅ | ✅ | ❌ |
| 안전 훅 (커널 레벨) | ✅ | ❌ | 수동 | maybe |
| 크래시 시 세션 복원 | ✅ | ❌ | 수동 | maybe |
| 토큰 규율 시행 | ✅ | ❌ | 수동 | ❌ |
| 업스트림 자가 업데이트 | ✅ | ❌ | ❌ | ✅ |
| 이중 언어 GitHub 파일 | ✅ | ❌ | ❌ | ❌ |
| AI 도구 누출 방지 | ✅ | ❌ | 수동 | ❌ |
| Cross-AI 릴레이 (Claude ↔ Codex) | ✅ | ❌ | ❌ | ❌ |
| Linux / macOS / Windows 호환 | ✅ | ✅ | ✅ | 도구별 상이 |

---

## 📚 문서

| 문서 | 내용 |
|------|------|
| [AI_PROJECT_SETUP.md](../AI_PROJECT_SETUP.md) | 산출물 — 모든 것을 생성하는 7,600줄 부트스트랩 |
| [README.md](../README.md) | 영문 README |
| [CONTRIBUTING.md](../CONTRIBUTING.md) · [한국어](CONTRIBUTING.ko.md) | 개발 환경, 버전 bump 체크리스트, PR 규약 |
| [SECURITY.md](../SECURITY.md) · [한국어](SECURITY.ko.md) | 보안 공개 프로세스, secret-guard 패턴 |
| [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md) · [한국어](CODE_OF_CONDUCT.ko.md) | Contributor Covenant v2.1 |
| [CHANGELOG.md](../CHANGELOG.md) · [한국어](CHANGELOG.ko.md) | 전체 버전 히스토리 |

---

## 🔁 자가 업데이트

자연어로 트리거: `"AI_PROJECT_SETUP 업데이트해"` / `"update AI_PROJECT_SETUP"` / `"fetch latest setup"`.

AI는:

1. `https://raw.githubusercontent.com/kernalix7/ai-project-setup/main/AI_PROJECT_SETUP.md` 페치
2. `Last Updated` 라인과 버전을 로컬 사본과 비교
3. 더 새로우면: `.priv-storage/AI_PROJECT_SETUP.md` 교체, 30+ 출하 스크립트를 `.bak` 백업과 함께 강제 덮어쓰기
4. `CLAUDE.md`의 템플릿 섹션 병합 (§8/9/10/12/13)하면서 프로젝트 콘텐츠 보존 (§1–7, §11)
5. 검증 게이트 재실행
6. `Updated: vOLD → vNEW. Force-patched N shipped scripts. Recommend /clear.` 보고

**단일 명령, 재실행 프롬프트 없음** (v4.6+).

> **v5.0 → v5.1 마이그레이션**: v5.1은 업데이트 소스를 gist에서 이 저장소로 이동했습니다. v5.0 이하 프로젝트는 레거시 gist에서 v5.1을 한 번 페치(마이그레이션 다리로 v5.1에 고정됨)한 뒤, 이후 모든 업데이트는 이 저장소에서 가져옵니다.

---

## 🍴 Fork

Fork가 자신의 저장소에서 자가 업데이트되도록 하려면:

1. [`AI_PROJECT_SETUP.md`](../AI_PROJECT_SETUP.md) 편집 — `kernalix7/ai-project-setup` 2회 모두 `{your-user}/{your-repo}`로 변경:
   - **Source of Truth** 블록의 저장소 URL
   - 동일 블록 및 자가 업데이트 프로토콜 Step 2의 raw URL
2. 선택적으로 레거시 gist URL 블록 제거 (pre-v5.1 사용자 마이그레이션 시에만 필요)
3. Fork의 `main` 브랜치에 커밋 & 푸시

다운스트림 프로젝트별 커스터마이징은 생성된 `.priv-storage/CLAUDE.md`를 직접 편집 — 섹션 1–7과 11은 자가 업데이트를 거쳐도 보존됩니다.

---

## ❓ 자주 묻는 질문

<details>
<summary><b>왜 CLI 툴이 아니라 7,000줄 마크다운 파일 하나인가요?</b></summary>

AI 코딩 어시스턴트는 마크다운을 네이티브로 읽습니다. CLI 툴은 설치, 버전 관리, 플랫폼 지원이 필요합니다. 마크다운 파일은 AI가 동작하는 모든 곳에서 — Linux, macOS, Windows, 컨테이너, 브라우저 기반 에이전트 — 설치 없이 동작합니다.
</details>

<details>
<summary><b>7,000줄이 컨텍스트 윈도우를 폭파시키지 않나요?</b></summary>

초기 설정에서만 그렇습니다 (~25k 토큰, 일회성). 설정 후엔 파일이 아카이브되고 50줄짜리 `POST_SETUP_INDEX.md`가 진입점이 됩니다. 일반 세션은 `CLAUDE.md` ~200줄 + 인덱스만 소비 — 약 4k 토큰.
</details>

<details>
<summary><b>아무것도 커밋되지 않아도 안전한가요? CI/CD가 훅/에이전트를 못 보는데.</b></summary>

맞고, 의도된 것입니다. AI 도구는 개발자별 편의 기능이고, CI/CD는 코드를 대상으로 실행되지 AI 설정을 대상으로 하지 않습니다. AI를 안 쓰는 팀원은 영향 없고, 쓰는 팀원은 같은 소스 파일에서 본인이 직접 설정하면 동일한 설정을 얻습니다.
</details>

<details>
<summary><b>아직 없는 새 AI 도구에서도 동작할까요?</b></summary>

마크다운 규칙 파일을 읽는 도구라면 (`CLAUDE.md` / `AGENTS.md` / `.cursorrules` / 유사한 것), 네 — 3개 심볼릭링크 중 아무거나 가리키면 됩니다. MCP 지원이면 `.mcp.json`을 자동으로 찾습니다. 훅은 Claude Code 전용입니다.
</details>

<details>
<summary><b>제거는 어떻게 하나요?</b></summary>

```bash
./tmp-igbkp/uninstall.sh
```
모든 항목을 `tmp-igbkp/uninstall-backup-{ts}/`에 백업한 뒤 제거합니다. `--clean-gitignore` 추가 시 `.gitignore`의 AI 도구 블록도 제거합니다.
</details>

<details>
<summary><b>Windows는 어떤가요?</b></summary>

Git Bash, WSL, MSYS2에서 동작합니다. 네이티브 PowerShell은 훅에 미지원(bash 스크립트라서)이지만, 규칙 파일 자체는 평범한 마크다운이므로 Windows의 모든 AI 도구에서 동작합니다.
</details>

<details>
<summary><b>같은 프로젝트에서 여러 AI 도구를 동시에 쓸 수 있나요?</b></summary>

네 — 그것이 설계 의도입니다. Claude Code는 `CLAUDE.md`, Codex/Copilot은 `AGENTS.md`, Cursor는 `.cursorrules`를 읽습니다. 세 파일 모두 동일한 `.priv-storage/CLAUDE.md` 심볼릭링크라서 업데이트가 원자적입니다.
</details>

<details>
<summary><b>버그를 찾았거나 기능을 원해요.</b></summary>

<https://github.com/kernalix7/ai-project-setup>에서 이슈나 PR을 열어주세요. [CONTRIBUTING.md](../CONTRIBUTING.md) 참조.
</details>

---

## 🗺️ 로드맵

- **v5.3** — `.devcontainer/` 템플릿, 설정 검증용 GitHub Actions 워크플로우
- **v5.4** — 네이티브 Windows PowerShell 훅 (실험적)
- **v6.0** — 플러그 가능한 규칙 모듈 (`.priv-storage/.claude/rules/<lang>/`)

버전 히스토리는 [CHANGELOG.md](../CHANGELOG.md) 참조.

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

## 💛 후원

ai-project-setup이 설정 시간을 절약해줬다면:

[![Ko-fi](https://img.shields.io/badge/Ko--fi-F16061?logo=ko-fi&logoColor=white&style=for-the-badge)](https://ko-fi.com/kernalix7)
[![Fairy](https://img.shields.io/badge/🧚_Fairy-EE6E73?style=for-the-badge&logoColor=white)](https://fairy.hada.io/@kernalix7)

Ko-fi는 해외 카드와 PayPal을 처리하고, fairy.hada.io는 한국 팁 플랫폼입니다. 버그 신고, PR, 그리고 ⭐ 스타도 똑같이 감사하고 무료입니다.

---

## 📄 라이선스

[MIT](../LICENSE) — Kim DaeHyun ([kernalix7@kodenet.io](mailto:kernalix7@kodenet.io))

<div align="center">

[버그 신고](https://github.com/kernalix7/ai-project-setup/issues/new?template=bug_report.md) &nbsp;·&nbsp; [기능 요청](https://github.com/kernalix7/ai-project-setup/issues/new?template=feature_request.md) &nbsp;·&nbsp; [English README](../README.md)

</div>
