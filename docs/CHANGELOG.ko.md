# 변경 이력

[English](../CHANGELOG.md) | **한국어**

이 파일은 프로젝트의 주요 변경 사항을 기록합니다.

형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/)를 따르며, [Semantic Versioning](https://semver.org/lang/ko/)을 준수합니다.

## [v6.0 — Unreleased] — 2026-05-19

**BREAKING: AIPS가 Claude Code plugin으로 전환됩니다.**

### 추가
- 원라이너 글로벌 설치: `curl -fsSL https://raw.githubusercontent.com/kernalix7/AIPS/main/install.sh | bash`
- 9개 slash commands: `/aips:{init,update,health,uninstall,status,migrate-from-md,upgrade,repair,reset}`
- install.sh가 설치하는 4개 번들 의존 plugin:
  - `codex-plugin-cc` (openai/codex-plugin-cc) — Claude ↔ Codex 공식 통합
  - `caveman` (JuliusBrussee/caveman) — 초압축 커뮤니케이션 모드
  - `agentmemory` (rohitg00/agentmemory) — 영속 tool-use 메모리 + 웹 뷰어 (port 3113)
  - `RTK` (rtk-ai/rtk) — 토큰 절약 CLI 프록시
- `agentmemory.service` — systemd user service (Linux), npx 서버를 127.0.0.1:3111+3113에서 실행
- agentmemory 최초 설치 시 한/영 이중언어 셋업 가이드 (1회 표시, 마커 `.first-install-shown`)
- Statusline v6.0 (3줄 레이아웃):
  - Line 1: `project [branch*N] wip:M | model | ctx:X%(used/max) | cache:Y%`
  - Line 2: `5h:X% ↻reset_eta ∅empty_eta | wk:X% ↻reset_eta ∅empty_eta`
  - Line 3: `🦴cv:S%/level | 🧠am:S%/N | 💰rtk:S% | 🤖cdx:S%/Nruns | 💯Σ:S%`
- `/aips:init` 4-way 자동 감지: fresh / v5.x 마이그레이션 / re-init / repair
- `/aips:migrate-from-md` — v5.x 흔적 클린 제거, `tmp-igbkp/migrate-backup-{ts}/`로 백업

### 변경
- 저장소 이름 변경: `kernalix7/ai-project-setup` → `kernalix7/AIPS`. GitHub 리다이렉트로 기존 URL은 그대로 유지.
- 글로벌 vs 프로젝트별 분리:
  - GLOBAL `~/.claude/`: hooks, agents (3 템플릿), commands (기본 6개 + 신규 aips-* 9개), skills, output-styles, statusline, plugin 의존성
  - PER-PROJECT `.priv-storage/`: CLAUDE.md (Section 1-7+11만, 기존 13섹션 ~600줄에서 ~150줄로), WORK_STATUS.md, memory/, sessions/, tech-lead.md, team agents, .mcp.json, tmp-igbkp/ (toolkit script 9개, codex-relay-* 제거)
- 프로젝트별 셋업: ~3분 (7600줄 md 읽기+실행)에서 ~30초 (`/aips:init`)로 단축
- CLAUDE.md Sections 8/9/10/12/13 (템플릿 보일러플레이트) → 프로젝트별 CLAUDE.md에서 1줄 글로벌 참조로
- v5.x → v6.0 업데이트 경로: `/aips:init`을 실행하는 모든 프로젝트가 v5.x 설치를 자동 감지하고 1회 확인 마이그레이션 제공

### 지원 매트릭스
- **Tier 1 — 주 지원 / 완전**: Claude Code (CLI) — 플러그인 전체, 9개 `/aips:*` 슬래시 명령, 5개 hooks, statusline, 4개 dep plugin (codex-plugin-cc, caveman, agentmemory, RTK).
- **Tier 2 — 부분 지원 (정책만)**: ChatGPT Codex CLI, Cursor, GitHub Copilot, claude.ai (웹), MCP 지원 도구 — CLAUDE.md / AGENTS.md / .cursorrules 규칙만 읽음; hooks, 슬래시 명령, statusline 없음.
- **Tier 3 — 완전 지원 예정 (TBD)**: Codex / Cursor / Copilot 대상 플러그인 동급 패리티는 로드맵, ETA 미정.

### 제거
- `AI_PROJECT_SETUP.md` (7,600줄 부트스트랩) → 30줄 DEPRECATED 리다이렉트 페이지로 축소
- Custom Codex Implementation Relay (v4.9 / v5.0):
  - Slash commands: `/codex-brief`, `/codex-review`, `/codex-fix`, `/codex-relay-status`
  - Scripts: `tmp-igbkp/codex-relay-check.sh`, `tmp-igbkp/codex-relay-run.sh`
  - CLAUDE.md Section 11 Path A-2, A-3
  - CLAUDE.md Section 13 Codex Implementation Relay 단락
  - 런타임 산출물: `.priv-storage/sessions/{codex-brief,codex-report,claude-review}.md`, `codex-relay/`
- codex-plugin-cc의 `/codex:exec`, `/codex:review`, `/codex:status`로 대체

### 마이그레이션
- v5.x에서: v6.0을 글로벌 설치 (`curl install.sh | bash`), 각 프로젝트에서 `/aips:init` 실행 — v5.x 설치를 자동 감지, 1회 확인을 요청, `tmp-igbkp/migrate-backup-{date}/`로 백업 후 정리 + 글로벌화.
- v5.x `/codex-*` 워크플로: `/codex:exec`, `/codex:review` (codex-plugin-cc)로 전환.
- 커스텀 statusline: v6.0 3줄 레이아웃으로 강제 덮어쓰기. 백업 자동 저장.

### v6.0이 breaking인 이유
- 7,600줄 markdown → AI 실행 모델 폐기
- 프로젝트별 셋업 명령 전면 변경
- Codex relay 워크플로 제거 (대체됨)
- 파일 레이아웃: 프로젝트별 파일 대거 제거

## [v5.2] - 2026-05-15

### 추가
- 초기 CHANGELOG.md, SECURITY.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md
- `.github/` 이슈/PR 템플릿
- 배지, 라이프사이클, 기능 매트릭스, FAQ, 로드맵, 후원 링크를 포함한 README.md 확장
- `docs/` 아래 한국어 문서 미러

### 비고
- `AI_PROJECT_SETUP.md` 자체의 버전 이력은 산출물 내 Version History 표에 있습니다. 이 changelog는 산출물 외부의 저장소 수준 변경을 추적합니다.
