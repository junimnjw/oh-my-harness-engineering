# CLAUDE.md

## 이 프로젝트는 무엇인가

나만의 하네스 엔지니어링 노하우를 집대성한 저장소.
Claude Code가 공식 지원하는 확장 기능들을 한 곳에 모아두고, `install.sh`를 통해 다른 프로젝트에 이식한다.

포함하는 확장 기능:

- **Skills** — 슬래시 커맨드로 호출하는 재사용 워크플로우 (`/worktree` 등)
- **Hooks** — Claude Code 생명주기 이벤트에 자동 실행되는 스크립트
- **Subagents** — 특정 작업에 특화된 커스텀 에이전트
- **Rules** — 코드 스타일, 보안 등 프로젝트 규칙 모음
- **MCP Configs** — 외부 도구/서비스 연결 설정

## 디렉토리 구조

```
skills/<name>/SKILL.md      → .claude/skills/<name>/SKILL.md
hooks/                      → settings.json의 hooks 섹션에 반영
agents/<name>/AGENT.md      → .claude/agents/<name>/AGENT.md
rules/*.md                  → .claude/rules/*.md
mcp-configs/                → .claude/.mcp.json에 반영
install.sh                  → 이식 스크립트
```

## 작업 규칙

### 공통
- 모든 지시문은 **한국어**로 작성한다.
- 모호한 표현을 쓰지 않는다. 실행할 명령어, 분기 조건, 중단 조건을 구체적으로 명시한다.

### Skill 작성 시
- `skills/<name>/SKILL.md` 경로에 YAML frontmatter + Markdown 본문으로 작성한다.
- 각 액션의 단계를 순서대로 정의하고, 단계를 건너뛰지 않도록 지시한다.

### Subagent 작성 시
- `agents/<name>/AGENT.md` 경로에 YAML frontmatter + 시스템 프롬프트 본문으로 작성한다.

### install.sh 수정 시
- 새로운 컴포넌트 디렉토리를 추가하면 `COMPONENTS` 배열에 반드시 함께 추가한다.

### 커밋 메시지
- 한국어로 작성한다.
- `feat:`, `fix:`, `refactor:`, `docs:` 접두사를 사용한다.
