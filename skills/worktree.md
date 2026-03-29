# Git Worktree 스킬

## 설치 위치
`~/.claude/commands/worktree.md` (글로벌 — 모든 프로젝트에서 사용 가능)

## 사용법
```
/worktree create <브랜치>  — 해당 브랜치의 worktree를 생성
/worktree list             — 모든 worktree 목록 출력
/worktree clean [이름]     — worktree 제거 및 잔여 참조 정리
/worktree help             — 도움말 출력
```

## 예시
```bash
# hotfix 브랜치용 worktree 생성
/worktree create hotfix/login-bug
# → ../<repo명>-wt-hotfix-login-bug 디렉토리에 생성됨

# 현재 worktree 목록 확인
/worktree list

# 특정 worktree 제거
/worktree clean hotfix-login-bug

# 대화형으로 정리할 worktree 선택
/worktree clean
```

## 디렉토리 명명 규칙
`../<repo명>-wt-<브랜치명>` (브랜치의 `/`는 `-`로 치환)

예: `my-project` 저장소에서 `feature/auth` 브랜치 → `../my-project-wt-feature-auth`
