# Git Worktree 관리 스킬

사용자의 인자를 파싱하여 아래 정의된 액션 중 하나를 실행한다.

## 사용법: `/worktree <액션> [인자]`

## 사전 조건 (모든 액션 공통)

1. `git rev-parse --git-dir` 실행하여 현재 디렉토리가 git 저장소인지 확인한다.
2. git 저장소가 아닌 경우: "git 저장소가 아닙니다. git 프로젝트 디렉토리에서 실행해 주세요." 출력 후 **즉시 중단**한다.

## 액션 정의

### `create <브랜치명>` (액션 키워드 없이 브랜치명만 입력해도 create로 간주)

1. `git worktree list`를 실행하여 해당 브랜치가 이미 체크아웃된 worktree가 있는지 확인한다.
   - 이미 존재하면: "이 브랜치는 이미 <경로>에서 체크아웃되어 있습니다." 출력 후 **중단**.
2. 저장소 루트 디렉토리의 폴더명을 `<repo명>`으로 사용한다. (`basename $(git rev-parse --show-toplevel)`)
3. 브랜치명에서 `/`를 `-`로 치환한 값을 `<정제된_브랜치명>`으로 사용한다.
4. worktree 생성 경로: `../<repo명>-wt-<정제된_브랜치명>`
5. 브랜치 존재 여부를 확인한다:
   - `git show-ref --verify refs/heads/<브랜치명>` 또는 `git show-ref --verify refs/remotes/origin/<브랜치명>`이 성공하면: `git worktree add <경로> <브랜치명>`
   - 존재하지 않으면: `git worktree add -b <브랜치명> <경로> HEAD`로 새 브랜치를 생성한다.
6. 완료 후 출력:
   ```
   worktree 생성 완료: <절대 경로>
   브랜치: <브랜치명>
   진입하려면: cd <절대 경로>
   ```

### `list` (별칭: `ls`)

1. `git worktree list --porcelain`을 실행한다.
2. 결과를 아래 형식의 테이블로 출력한다:
   ```
   경로                          브랜치           유형
   /Users/.../my-project         main             주 worktree
   /Users/.../my-project-wt-fix  hotfix/login     연결된 worktree
   ```
3. 연결된 worktree가 없으면: "연결된 worktree가 없습니다." 출력.

### `clean` (별칭: `rm`, `remove`)

**인자가 있는 경우** (`/worktree clean <이름 또는 경로>`):
1. 입력값이 절대 경로이면 그대로 사용. 아니면 `git worktree list`에서 경로에 입력값이 포함된 항목을 찾는다.
2. 일치하는 worktree가 없으면: "일치하는 worktree를 찾을 수 없습니다." 출력 후 중단.
3. 주 worktree(bare: 또는 첫 번째 항목)인 경우: "주 worktree는 제거할 수 없습니다." 출력 후 중단.
4. `git worktree remove <경로>`를 실행한다.
5. `git worktree prune`을 실행하여 잔여 참조를 정리한다.

**인자가 없는 경우** (`/worktree clean`):
1. `git worktree list`로 연결된 worktree 목록을 표시한다.
2. 연결된 worktree가 없으면: "정리할 worktree가 없습니다." 출력 후 중단.
3. 사용자에게 제거할 worktree를 선택하도록 질문한다.
4. 선택된 항목에 대해 위 제거 절차를 수행한다.

### `help` (인자가 없을 때도 help로 간주)

아래 내용을 그대로 출력한다:
```
/worktree create <브랜치>  — 해당 브랜치의 worktree를 생성
/worktree list             — 모든 worktree 목록 출력
/worktree clean [이름]     — worktree 제거 및 잔여 참조 정리
/worktree help             — 이 도움말 출력
```

## 제약 사항

- worktree 디렉토리 명명 규칙은 반드시 `../<repo명>-wt-<정제된_브랜치명>` 형식을 따른다.
- 사용자의 언어(한국어/영어)에 맞춰 응답한다.
- 각 액션은 위에 정의된 단계를 순서대로 실행하며, 단계를 건너뛰지 않는다.
