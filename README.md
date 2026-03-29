# oh-my-harness-engineering

Claude Code에서 사용하는 commands, hooks, agents 모음.
프로젝트 단위로 이식하거나 전역으로 설치할 수 있다.

## 구조

```
commands/      → .claude/commands/   (슬래시 커맨드)
hooks/         → .claude/hooks/      (자동 실행 훅)
agents/        → .claude/agents/     (에이전트 정의)
install.sh     → 설치 스크립트
```

## 설치

### 특정 프로젝트에 설치

```bash
# 전체 설치
./install.sh ~/source/my-project

# commands만 설치
./install.sh ~/source/my-project --commands

# hooks만 설치
./install.sh ~/source/my-project --hooks
```

### 전역 설치 (모든 프로젝트에서 사용)

```bash
./install.sh --global
```

## 포함된 Commands

| 커맨드 | 설명 |
|--------|------|
| `/worktree` | git worktree 생성, 목록 조회, 정리 |

## 포함된 Hooks

(준비 중)

## 포함된 Agents

(준비 중)
