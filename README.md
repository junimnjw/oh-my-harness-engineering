# oh-my-harness-engineering

나만의 하네스 엔지니어링 노하우를 집대성한 저장소.
Claude Code 공식 확장 기능(Skills, Hooks, Subagents, Rules, MCP Configs)을 모아두고 프로젝트 단위로 이식한다.

## 구조

```
skills/<name>/SKILL.md      → .claude/skills/<name>/SKILL.md   (슬래시 커맨드)
hooks/                      → settings.json hooks 섹션          (생명주기 자동화)
agents/<name>/AGENT.md      → .claude/agents/<name>/AGENT.md   (커스텀 에이전트)
rules/*.md                  → .claude/rules/*.md               (프로젝트 규칙)
mcp-configs/                → .claude/.mcp.json                (외부 도구 연결)
install.sh                  → 이식 스크립트
```

## 설치

### 특정 프로젝트에 설치

```bash
# 전체 설치
./install.sh ~/source/my-project

# 원하는 것만 골라서 설치
./install.sh ~/source/my-project --skills
./install.sh ~/source/my-project --agents --rules
```

### 전역 설치 (모든 프로젝트에서 사용)

```bash
./install.sh --global
```

## 포함된 Skills

| 커맨드 | 설명 |
|--------|------|
| `/worktree` | git worktree 생성, 목록 조회, 정리 |

## 포함된 Hooks

(준비 중)

## 포함된 Subagents

| 이름 | 설명 |
|------|------|
| `weekly-report` | 주간 업무 메모를 정해진 포맷으로 정리하여 GitHub Enterprise Discussion에 게시 |

## 포함된 Rules

(준비 중)
