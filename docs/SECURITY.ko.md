# 보안 정책

[English](../SECURITY.md) | **한국어**

## 지원 버전

| 버전 | 지원 |
|------|------|
| v6.x   | :white_check_mark: |
| < v6.0 | :x: |

v6.0에서 단일 파일 부트스트랩에서 Claude Code plugin 배포 방식으로 전환되었습니다. 이전 버전은 지원하지 않습니다.

## 취약점 신고

**공개 GitHub 이슈로 취약점을 신고하지 마세요.**

[GitHub Security Advisories](https://github.com/kernalix7/AIPS/security/advisories/new)로 신고해 주세요.

포함 내용: 설명, 재현 단계, 영향받는 버전, 잠재적 영향. 7일 내 접수 확인, 30일 내 상태 업데이트.

## 설치 시점 위험

### `curl | bash` 파이프라인

권장 설치 명령:
```bash
curl -fsSL https://raw.githubusercontent.com/kernalix7/AIPS/main/install.sh | bash
```
이 방식은 네트워크와 fetch 시점의 repo HEAD를 신뢰합니다. 강화된 환경에서는:
1. 먼저 다운로드: `curl -fsSL .../install.sh -o install.sh`
2. GitHub Release 페이지에 게시된 SHA256 값과 대조 검증.
3. 스크립트를 직접 읽은 뒤 `bash install.sh` 실행.

### Plugin marketplace 신뢰

`install.sh`는 4개의 외부 Claude Code marketplace를 등록합니다:
- `kernalix7/AIPS`
- `openai/codex-plugin-cc`
- `JuliusBrussee/caveman`
- `rohitg00/agentmemory`

각 marketplace는 plugin 목록과 entry point를 기술한 `marketplace.json`을 제공합니다. `/plugin install` 실행 전 `~/.claude/plugins/marketplaces/<owner>-<repo>/marketplace.json` 파일을 검토하세요. 제거는 `/plugin marketplace remove <name>`.

## 런타임 표면

### agentmemory (systemd user service)

user-scope service로 실행되며 (sudo 불필요) 다음 포트를 노출합니다:
- `127.0.0.1:3111` — Claude Code hook이 사용하는 REST API
- `127.0.0.1:3113` — 로컬 web viewer

모든 Claude Code tool-use observation을 기록합니다. 민감한 프로젝트의 경우:
- `~/.claude/plugins/cache/agentmemory/agentmemory/.env`에 `BLOCKLIST` 설정
- 또는 세션 중 중지: `systemctl --user stop agentmemory.service`
- 완전 제거: `systemctl --user disable --now agentmemory.service`

Linux 전용. loopback에 바인딩되어 있으며 두 포트를 외부 네트워크에 노출하지 마세요.

### MCP server credential

`.mcp.json`은 반드시 환경 변수(`${VAR}`)만 참조해야 하며 secret을 인라인으로 두지 마세요. 프로젝트 레벨 `.mcp.json`은 템플릿에서 gitignore 처리되어 있으니 그대로 유지하세요.

### codex-plugin-cc auth token

`openai/codex-plugin-cc`는 auth token을 `~/.codex/config.toml`에 저장합니다. credential로 취급: `chmod 600`, commit 금지, 유출 의심 시 rotate.

## 방어 도구

- `secret-guard.sh` — staged diff에서 공통 secret 패턴 14개를 차단하는 정규식 (AWS key, GitHub token, private key 등). pre-commit hook 체인에서 실행.
- `tmp-igbkp/archive.sh` — 암호화 snapshot은 AES-256-CBC + PBKDF2 600k iteration 사용. 비밀번호는 interactive 입력 전용 (CLI 인자 불가) — shell history 유출 방지.

## 침해 대응 (Containment)

1. `systemctl --user disable --now agentmemory.service` — memory service 중지.
2. `/plugin marketplace remove <name>` — 의심되는 marketplace 모두 제거.
3. `rm -rf ~/.claude/plugins/cache/<plugin>` — 캐시된 plugin 코드 삭제.
4. `~/.codex/config.toml` 또는 `.mcp.json`이 참조하는 credential rotate.
5. 검증된 SHA256의 `install.sh`로 재설치.

## 범위 외 (Out of Scope)

- 서드파티 plugin의 upstream 취약점은 해당 repo로 신고.
- Claude Code 또는 MCP runtime 버그는 Anthropic / MCP maintainer에게 신고.
