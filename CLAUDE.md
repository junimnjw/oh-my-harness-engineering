# CLAUDE.md

## 이 프로젝트는 무엇인가

Claude Code에서 사용하는 commands, hooks, agents를 모아둔 저장소.
`install.sh`를 통해 다른 프로젝트의 `.claude/` 디렉토리에 이식하거나 `~/.claude/`에 전역 설치한다.

## 디렉토리 구조와 역할

- `commands/` — Claude Code 슬래시 커맨드 (`/커맨드명`으로 호출). 설치 시 `.claude/commands/`에 복사된다.
- `hooks/` — Claude Code 훅 스크립트. 설치 시 `.claude/hooks/`에 복사된다.
- `agents/` — Claude Code 에이전트 정의. 설치 시 `.claude/agents/`에 복사된다.
- `install.sh` — 위 컴포넌트를 대상 프로젝트 또는 전역에 설치하는 스크립트.

## 작업 규칙

### 스킬(커맨드) 작성 시
- 모든 지시문은 **한국어**로 작성한다.
- 모호한 표현을 쓰지 않는다. 실행할 명령어, 분기 조건, 중단 조건을 구체적으로 명시한다.
- 각 액션의 단계를 순서대로 정의하고, 단계를 건너뛰지 않도록 지시한다.

### install.sh 수정 시
- 새로운 컴포넌트 디렉토리를 추가하면 `COMPONENTS` 배열에 반드시 함께 추가한다.
- 설치 대상 디렉토리에 동일 파일이 있을 경우 덮어쓴다 (최신 버전 우선).

### 커밋 메시지
- 한국어로 작성한다.
- `feat:`, `fix:`, `refactor:`, `docs:` 접두사를 사용한다.
