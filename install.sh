#!/usr/bin/env zsh
#
# oh-my-harness-engineering 설치 스크립트
#
# 사용법:
#   ./install.sh <대상_프로젝트_경로> [옵션]
#
# 옵션:
#   --skills [이름,...]    skills 설치 (이름 지정 시 해당 항목만)
#   --hooks [이름,...]     hooks 설치
#   --agents [이름,...]    agents 설치
#   --rules [이름,...]     rules 설치
#   --mcp [이름,...]       mcp-configs 설치
#   --global               ~/.claude/에 전역 설치
#   --list                 설치 가능한 항목 목록 출력
#   (옵션 없으면 전체 설치)
#
# 예시:
#   ./install.sh ~/source/my-project
#   ./install.sh ~/source/my-project --skills worktree,deploy
#   ./install.sh ~/source/my-project --skills worktree --agents code-reviewer
#   ./install.sh --global --skills worktree
#   ./install.sh --list

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CATEGORIES=("skills" "hooks" "agents" "rules" "mcp-configs")

print_usage() {
    echo "사용법: ./install.sh <대상_프로젝트_경로> [옵션]"
    echo "       ./install.sh --global [옵션]"
    echo "       ./install.sh --list"
    echo ""
    echo "옵션:"
    echo "  --skills [이름,...]    skills 설치 (이름 생략 시 전체)"
    echo "  --hooks [이름,...]     hooks 설치"
    echo "  --agents [이름,...]    agents 설치"
    echo "  --rules [이름,...]     rules 설치"
    echo "  --mcp [이름,...]       mcp-configs 설치"
    echo "  --global               ~/.claude/에 전역 설치"
    echo "  --list                 설치 가능한 항목 목록 출력"
    echo ""
    echo "예시:"
    echo "  ./install.sh ~/source/my-project                          # 전체 설치"
    echo "  ./install.sh ~/source/my-project --skills worktree        # worktree skill만"
    echo "  ./install.sh ~/source/my-project --skills worktree,deploy # 여러 개 지정"
    echo "  ./install.sh --global --skills worktree                   # 전역에 worktree만"
}

# 카테고리 내 사용 가능한 항목 목록을 출력한다.
list_available() {
    for category in "${CATEGORIES[@]}"; do
        local dir="${SCRIPT_DIR}/${category}"
        [[ ! -d "$dir" ]] && continue

        local items=()
        # 하위 디렉토리 기준
        for entry in "$dir"/*(N/); do
            items+=("$(basename "$entry")")
        done
        # 하위 디렉토리가 없으면 파일 기준
        if [[ ${#items[@]} -eq 0 ]]; then
            for entry in "$dir"/*(N.); do
                items+=("$(basename "$entry" .md)")
            done
        fi

        if [[ ${#items[@]} -gt 0 ]]; then
            echo "[${category}]"
            for item in "${items[@]}"; do
                echo "  - ${item}"
            done
            echo ""
        fi
    done
}

# 개별 항목을 설치한다.
install_item() {
    local category="$1"
    local name="$2"
    local target_base="$3"
    local source_path="${SCRIPT_DIR}/${category}/${name}"

    if [[ -d "$source_path" ]]; then
        mkdir -p "${target_base}/${name}"
        cp -r "${source_path}/"* "${target_base}/${name}/"
        echo "  >>  ${category}/${name} -> ${target_base}/${name}/"
    elif [[ -f "$source_path" ]]; then
        mkdir -p "$target_base"
        cp "$source_path" "${target_base}/"
        echo "  >>  ${category}/${name} -> ${target_base}/${name}"
    elif [[ -f "${source_path}.md" ]]; then
        mkdir -p "$target_base"
        cp "${source_path}.md" "${target_base}/"
        echo "  >>  ${category}/${name}.md -> ${target_base}/${name}.md"
    else
        echo "  !!  ${category}/${name}: 존재하지 않음"
        return 1
    fi
}

# 카테고리 전체를 설치한다.
install_category() {
    local category="$1"
    local target_base="$2"
    local source_dir="${SCRIPT_DIR}/${category}"

    if [[ ! -d "$source_dir" ]] || [[ -z "$(find "$source_dir" -type f 2>/dev/null)" ]]; then
        echo "  --  ${category}: 설치할 파일 없음"
        return
    fi

    mkdir -p "$target_base"
    cp -r "${source_dir}/"* "$target_base/"
    local count
    count=$(find "$source_dir" -type f | wc -l | tr -d ' ')
    echo "  >>  ${category}: ${count}개 파일 -> ${target_base}/"
}

# --- 인자 파싱 ---

TARGET=""
GLOBAL=false
LIST=false

typeset -a SELECTED_CATEGORIES=()
typeset -A SELECTED_ITEMS=()

current_category=""

# 인자가 없으면 사용법 출력 후 종료
if [[ $# -eq 0 ]]; then
    print_usage
    exit 1
fi

for arg in "$@"; do
    case "$arg" in
        --skills|--hooks|--agents|--rules|--mcp)
            current_category="${arg#--}"
            [[ "$current_category" == "mcp" ]] && current_category="mcp-configs"
            SELECTED_CATEGORIES+=("$current_category")
            ;;
        --global)
            GLOBAL=true
            current_category=""
            ;;
        --list)
            LIST=true
            current_category=""
            ;;
        --help|-h)
            print_usage
            exit 0
            ;;
        *)
            if [[ -n "$current_category" ]]; then
                SELECTED_ITEMS[$current_category]="$arg"
                current_category=""
            else
                TARGET="$arg"
            fi
            ;;
    esac
done

# --list: 목록 출력 후 종료
if [[ "$LIST" == true ]]; then
    echo "설치 가능한 항목:"
    echo ""
    list_available
    exit 0
fi

# 설치 대상 경로 결정
if [[ "$GLOBAL" == true ]]; then
    INSTALL_BASE="$HOME/.claude"
    echo "[전역 설치] -> ${INSTALL_BASE}/"
else
    if [[ -z "$TARGET" ]]; then
        print_usage
        exit 1
    fi
    TARGET="$(cd "$TARGET" 2>/dev/null && pwd)" || {
        echo "오류: '${TARGET}' 경로가 존재하지 않습니다."
        exit 1
    }
    INSTALL_BASE="${TARGET}/.claude"
    echo "[프로젝트 설치] -> ${INSTALL_BASE}/"
fi
echo ""

# 카테고리 선택이 없으면 전체 설치
if [[ ${#SELECTED_CATEGORIES[@]} -eq 0 ]]; then
    SELECTED_CATEGORIES=("skills" "hooks" "agents" "rules" "mcp-configs")
fi

# 설치 실행
for category in "${SELECTED_CATEGORIES[@]}"; do
    target_dir="${INSTALL_BASE}/${category}"

    if [[ -n "${SELECTED_ITEMS[$category]:-}" ]]; then
        # 개별 항목 설치: 쉼표로 분리하여 각각 설치
        IFS=',' read -rA items <<< "${SELECTED_ITEMS[$category]}"
        for item in "${items[@]}"; do
            install_item "$category" "$item" "$target_dir"
        done
    else
        # 카테고리 전체 설치
        install_category "$category" "$target_dir"
    fi
done

echo ""
echo "완료."
