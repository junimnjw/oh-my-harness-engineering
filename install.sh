#!/bin/bash
#
# oh-my-harness-engineering 설치 스크립트
#
# 사용법:
#   ./install.sh <대상_프로젝트_경로> [옵션]
#
# 옵션:
#   --skills      skills만 설치
#   --hooks       hooks만 설치
#   --agents      agents만 설치
#   --rules       rules만 설치
#   --mcp         mcp-configs만 설치
#   --global      ~/.claude/에 전역 설치 (skills, agents만 해당)
#   (옵션 없으면 전체 설치)
#
# 예시:
#   ./install.sh ~/source/my-project
#   ./install.sh ~/source/my-project --skills
#   ./install.sh --global

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

print_usage() {
    echo "사용법: ./install.sh <대상_프로젝트_경로> [옵션]"
    echo "       ./install.sh --global"
    echo ""
    echo "옵션:"
    echo "  --skills      skills만 설치"
    echo "  --hooks       hooks만 설치"
    echo "  --agents      agents만 설치"
    echo "  --rules       rules만 설치"
    echo "  --mcp         mcp-configs만 설치"
    echo "  --global      ~/.claude/에 전역 설치 (skills, agents)"
    echo "  (옵션 없으면 전체 설치)"
}

# 디렉토리 내 파일을 재귀 복사. 빈 디렉토리는 건너뛴다.
install_component() {
    local label="$1"
    local source_dir="$2"
    local target_dir="$3"

    if [ ! -d "$source_dir" ] || [ -z "$(find "$source_dir" -type f 2>/dev/null)" ]; then
        echo "  --  ${label}: 설치할 파일 없음"
        return
    fi

    mkdir -p "$target_dir"
    cp -r "${source_dir}/"* "$target_dir/"
    local count
    count=$(find "$source_dir" -type f | wc -l | tr -d ' ')
    echo "  >>  ${label}: ${count}개 파일 -> ${target_dir}"
}

# 인자 파싱
TARGET=""
SELECTED=()
GLOBAL=false

for arg in "$@"; do
    case "$arg" in
        --skills|--hooks|--agents|--rules|--mcp)
            SELECTED+=("${arg#--}")
            ;;
        --global)
            GLOBAL=true
            ;;
        --help|-h)
            print_usage
            exit 0
            ;;
        *)
            TARGET="$arg"
            ;;
    esac
done

# 전역 설치
if [ "$GLOBAL" = true ]; then
    echo "[전역 설치] -> ~/.claude/"
    echo ""
    install_component "skills" "${SCRIPT_DIR}/skills" "$HOME/.claude/skills"
    install_component "agents" "${SCRIPT_DIR}/agents" "$HOME/.claude/agents"
    echo ""
    echo "완료. 모든 프로젝트에서 사용 가능합니다."
    exit 0
fi

# 프로젝트 경로 확인
if [ -z "$TARGET" ]; then
    print_usage
    exit 1
fi

TARGET="$(cd "$TARGET" 2>/dev/null && pwd)" || {
    echo "오류: '${TARGET}' 경로가 존재하지 않습니다."
    exit 1
}

# 선택된 컴포넌트가 없으면 전체 설치
if [ ${#SELECTED[@]} -eq 0 ]; then
    SELECTED=("skills" "hooks" "agents" "rules" "mcp")
fi

CLAUDE_DIR="${TARGET}/.claude"
echo "[프로젝트 설치] -> ${CLAUDE_DIR}/"
echo ""

for component in "${SELECTED[@]}"; do
    case "$component" in
        skills)
            install_component "skills" "${SCRIPT_DIR}/skills" "${CLAUDE_DIR}/skills"
            ;;
        hooks)
            install_component "hooks" "${SCRIPT_DIR}/hooks" "${CLAUDE_DIR}/hooks"
            ;;
        agents)
            install_component "agents" "${SCRIPT_DIR}/agents" "${CLAUDE_DIR}/agents"
            ;;
        rules)
            install_component "rules" "${SCRIPT_DIR}/rules" "${CLAUDE_DIR}/rules"
            ;;
        mcp)
            install_component "mcp-configs" "${SCRIPT_DIR}/mcp-configs" "${CLAUDE_DIR}/mcp-configs"
            ;;
    esac
done

echo ""
echo "완료. ${TARGET} 프로젝트에서 사용 가능합니다."
