#!/bin/bash
#
# oh-my-harness-engineering 설치 스크립트
#
# 사용법:
#   ./install.sh <대상_프로젝트_경로> [옵션]
#
# 옵션:
#   --commands    commands만 설치
#   --hooks       hooks만 설치
#   --agents      agents만 설치
#   --global      ~/.claude/commands에 전역 설치
#   (옵션 없으면 전체 설치)
#
# 예시:
#   ./install.sh ~/source/my-project
#   ./install.sh ~/source/my-project --commands
#   ./install.sh --global

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPONENTS=("commands" "hooks" "agents")

print_usage() {
    echo "사용법: ./install.sh <대상_프로젝트_경로> [--commands] [--hooks] [--agents]"
    echo "       ./install.sh --global"
    echo ""
    echo "옵션:"
    echo "  --commands    commands만 설치"
    echo "  --hooks       hooks만 설치"
    echo "  --agents      agents만 설치"
    echo "  --global      ~/.claude/commands에 전역 설치"
    echo "  (옵션 없으면 전체 설치)"
}

install_component() {
    local component="$1"
    local target_dir="$2"
    local source_dir="${SCRIPT_DIR}/${component}"

    if [ ! -d "$source_dir" ] || [ -z "$(ls -A "$source_dir" 2>/dev/null)" ]; then
        echo "  ⏭  ${component}: 설치할 파일 없음"
        return
    fi

    mkdir -p "$target_dir"
    cp -r "${source_dir}/"* "$target_dir/"
    local count
    count=$(find "$source_dir" -type f | wc -l | tr -d ' ')
    echo "  ✅ ${component}: ${count}개 파일 → ${target_dir}"
}

# 인자 파싱
TARGET=""
SELECTED=()
GLOBAL=false

for arg in "$@"; do
    case "$arg" in
        --commands|--hooks|--agents)
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
    echo "🔧 전역 설치 (commands → ~/.claude/commands)"
    install_component "commands" "$HOME/.claude/commands"
    echo ""
    echo "완료! 모든 프로젝트에서 사용 가능합니다."
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
    SELECTED=("${COMPONENTS[@]}")
fi

echo "🔧 설치 대상: ${TARGET}/.claude/"
echo ""

for component in "${SELECTED[@]}"; do
    install_component "$component" "${TARGET}/.claude/${component}"
done

echo ""
echo "완료! ${TARGET} 프로젝트에서 사용 가능합니다."
