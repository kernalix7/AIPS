# 기여 가이드

[English](../CONTRIBUTING.md) | **한국어**

AIPS (Claude Code 플러그인, v6.0+) 기여에 감사드립니다.

## 환경 설정

```bash
git clone https://github.com/kernalix7/AIPS.git
cd AIPS
```

빌드 단계 없음. 플러그인은 소스 그대로 배포: `commands/`, `hooks/`, `agents/`, `skills/`, `lib/`, `templates/`, `statusline`.

## 워크플로

1. 브랜치: `git checkout -b feature/my-change`
2. 해당 영역 수정:
   - 슬래시 커맨드 → `commands/aips-*.md`
   - 라이프사이클 훅 → `hooks/`
   - 서브에이전트 템플릿 → `agents/`
   - 프로젝트 초기화 페이로드 → `templates/`
   - 헬퍼 → `lib/` (`detect-project.sh`, `render-claude-md.sh`, `verify-init.sh`, `migrate-from-md.sh`, `setup-agentmemory-service.sh`)
   - 스테이터스라인 / 출력 스타일 → `statusline`, `output-styles/terse.md`
3. 작업 트리에서 설치: `bash install.sh --local-source "$(pwd)"`
4. 도그푸딩: `mkdir -p /tmp/test-project && cd /tmp/test-project && git init && claude`, 이후 `/aips:init`.
5. 검증: `bash lib/verify-init.sh /tmp/test-project`
6. 컨벤션 prefix로 커밋 (아래 참조).
7. `main`으로 PR. 현재 단일 메인테이너 (사소한 수정은 직접 push); 외부 기여자 합류 시 PR 워크플로 전환. CI 없음 — 로컬 검증 필수.

## 버전 업 체크리스트 (v6.0+)

- `.claude-plugin/plugin.json` → `version` 갱신
- `README.md` → 상태 배지 갱신
- `CHANGELOG.md` → 항목 추가
- 태그: `git tag v6.x.y`

## 커밋 컨벤션

`feat:` / `fix:` / `refactor:` / `docs:` / `chore:`

예시: `feat(commands): add /aips:repair for broken installs`

## 문서 동기화

영문/한국어 문서는 항상 함께 업데이트. `README.md`, `CONTRIBUTING.md`, `docs/ARCHITECTURE.md`, `docs/MIGRATION-FROM-MD.md` 수정 시 같은 PR에서 `docs/ko/` (또는 `docs/CONTRIBUTING.ko.md`) 대응 파일도 갱신.

## 기타

- [행동 강령](CODE_OF_CONDUCT.ko.md)
- 라이선스: 기여는 [MIT](../LICENSE).
