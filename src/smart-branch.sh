#!/bin/bash

# Unified Smart Branch - Git Branch Creation Tool
# Usage: ./smart-branch.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.json"

# Variables
HELP=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            HELP=true
            shift
            ;;
        *)
            if [[ -z "$PREFIX" ]]; then
                PREFIX="$1"
            elif [[ -z "$TICKET_NUMBER" ]]; then
                TICKET_NUMBER="$1"
            elif [[ -z "$DESCRIPTION" ]]; then
                DESCRIPTION="$1"
            fi
            shift
            ;;
    esac
done

# Function to show usage
show_usage() {
    echo -e "${CYAN}🚀 === Smart Branch Creator ===${NC}"
    echo ""
    echo -e "${YELLOW}Sử dụng:${NC}"
    echo "  ./smart-branch.sh                              # Interactive mode với menu chọn"
    echo "  ./smart-branch.sh [prefix] [ticket] [desc]     # Command line mode với ticket"
    echo "  ./smart-branch.sh [prefix] [desc]              # Command line mode không ticket"
    echo ""
    echo -e "${YELLOW}Ví dụ:${NC}"
    echo "  ./smart-branch.sh"
    echo "  ./smart-branch.sh feat 123 \"implement user authentication\""
    echo "  ./smart-branch.sh feat \"add new dashboard\""
    echo ""
    echo -e "${YELLOW}Branch format:${NC}"
    echo "  Với ticket: feat/username-123_description"
    echo "  Không ticket: feat/username_description"
    echo ""
    echo -e "${YELLOW}Prefix được hỗ trợ:${NC}"
    echo "  feat, bug, hotfix, sync, refactor, docs, test, chore"
}

# Function to show mode selection menu
show_mode_selection() {
    echo -e "${GREEN}🚀 === Smart Branch Creator ===${NC}"
    echo ""
    echo -e "${CYAN}Chọn mode:${NC}"
    echo -e "  [1] ${WHITE}🤖 AI Mode - Smart suggestions với Google Gemini${NC}"
    echo -e "  [2] ${WHITE}⚡ Traditional Mode - Classic naming${NC}"
    echo -e "  [3] ${WHITE}❌ Thoát${NC}"
    echo ""

    while true; do
        read -p "Lựa chọn (1-3): " choice
        if [[ "$choice" =~ ^[1-3]$ ]]; then
            echo "$choice"
            return
        fi
        echo -e "${RED}❌ Lựa chọn không hợp lệ. Vui lòng chọn từ 1 đến 3${NC}"
    done
}

# Function to validate prefix
validate_prefix() {
    local prefix=$1
    local valid_prefixes=("feat" "bug" "hotfix" "sync" "refactor" "docs" "test" "chore")

    for valid in "${valid_prefixes[@]}"; do
        if [[ "$prefix" == "$valid" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to get git username
get_git_username() {
    local username=$(git config user.name)
    if [[ -z "$username" ]]; then
        echo -e "${RED}❌ Lỗi: Không tìm thấy git username. Vui lòng cấu hình git config user.name${NC}"
        exit 1
    fi
    # Convert to lowercase and replace spaces
    echo "$username" | tr '[:upper:]' '[:lower:]' | tr ' ' ''
}

# Function to sanitize description
sanitize_description() {
    local desc=$1
    # Convert to lowercase, replace spaces and special chars with hyphens
    echo "$desc" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g'
}

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux" ;;
        Darwin*)    echo "mac" ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *)          echo "unknown" ;;
    esac
}

# Function to check dependencies
check_dependencies() {
    local missing_deps=()

    # Check curl
    if ! command -v curl >/dev/null 2>&1; then
        missing_deps+=("curl")
    fi

    # Check jq (optional)
    if ! command -v jq >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  jq không được cài đặt (optional cho AI features)${NC}"
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  Thiếu dependencies: ${missing_deps[*]}${NC}"
        echo -e "${CYAN}💡 Trên Linux, chạy: ./setup-linux.sh để tự động cài đặt${NC}"

        local os=$(detect_os)
        case "$os" in
            "linux")
                echo -e "${CYAN}💡 Hoặc cài đặt thủ công:${NC}"
                if command -v pacman >/dev/null 2>&1; then
                    echo "  sudo pacman -S ${missing_deps[*]}"
                elif command -v apt >/dev/null 2>&1; then
                    echo "  sudo apt install ${missing_deps[*]}"
                elif command -v dnf >/dev/null 2>&1; then
                    echo "  sudo dnf install ${missing_deps[*]}"
                elif command -v yum >/dev/null 2>&1; then
                    echo "  sudo yum install ${missing_deps[*]}"
                fi
                ;;
            "mac")
                echo -e "${CYAN}💡 Trên macOS:${NC}"
                echo "  brew install ${missing_deps[*]}"
                ;;
        esac
        return 1
    fi
    return 0
}

# Function to load configuration
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo -e "${YELLOW}⚠️  Không tìm thấy file config.json. Tạo file mặc định...${NC}"
        cat > "$CONFIG_FILE" << 'EOF'
{
  "ai_provider": "gemini",
  "api_key": "",
  "model": "gemini-2.0-flash-exp",
  "endpoint": "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent",
  "max_tokens": 150,
  "temperature": 0.7,
  "enabled": true
}
EOF
        echo -e "${GREEN}📁 Đã tạo file config.json. Vui lòng cập nhật API key trong file này.${NC}"
    fi
}

# Function to get config value
get_config_value() {
    local key=$1
    if command -v jq >/dev/null 2>&1; then
        jq -r ".$key // empty" "$CONFIG_FILE" 2>/dev/null
    else
        # Fallback parser for systems without jq
        grep "\"$key\"" "$CONFIG_FILE" | sed 's/.*"'$key'": *"\([^"]*\)".*/\1/' | head -1
    fi
}

# Function to call Gemini API for branch name suggestions
get_ai_suggestions() {
    local prefix=$1
    local ticket=$2
    local description=$3
    local username=$4

    local api_key=$(get_config_value "api_key")
    local enabled=$(get_config_value "enabled")
    local endpoint=$(get_config_value "endpoint")
    local temperature=$(get_config_value "temperature")
    local max_tokens=$(get_config_value "max_tokens")

    if [[ -z "$api_key" || "$enabled" != "true" ]]; then
        echo -e "${YELLOW}⚠️  AI không được cấu hình hoặc tắt. Sử dụng tên nhánh truyền thống.${NC}"
        return 1
    fi

    echo -e "${CYAN}🤖 Đang gọi AI để tạo gợi ý tên nhánh...${NC}"

    # Create prompt based on whether ticket number exists
    local branch_format
    local example_formats
    local ticket_info

    if [[ -z "$ticket" ]]; then
        branch_format="{prefix}/{username}_{description}"
        example_formats="feat/username_add-user-auth
feat/username_implement-login-system
feat/username_create-auth-module"
        ticket_info="- Ticket: Không có (optional)"
    else
        branch_format="{prefix}/{username}-{ticket}_{description}"
        example_formats="feat/username-123_add-user-auth
feat/username-123_implement-login-system
feat/username-123_create-auth-module"
        ticket_info="- Ticket: $ticket"
    fi

    local prompt="Bạn là chuyên gia Git branch naming. Dựa vào thông tin sau:
- Prefix: $prefix
$ticket_info
- Mô tả task: $description
- Username: $username

Tạo CHÍNH XÁC 3 tên nhánh theo format: $branch_format

Yêu cầu:
- Mô tả phần description ngắn gọn, rõ ràng, thể hiện đúng mục đích
- Sử dụng kebab-case cho description
- Tối đa 50 ký tự cho toàn bộ tên nhánh
- Mỗi option phải khác nhau về cách diễn đạt
- Chỉ trả về 3 dòng, mỗi dòng 1 tên nhánh, không có text khác

Ví dụ format:
$example_formats"

    local json_payload=$(cat << EOF
{
  "contents": [
    {
      "parts": [
        {
          "text": "$prompt"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": ${temperature:-0.7},
    "maxOutputTokens": ${max_tokens:-150}
  }
}
EOF
)

    local response
    if command -v curl >/dev/null 2>&1; then
        response=$(curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "$json_payload" \
            "$endpoint?key=$api_key" 2>/dev/null)
    else
        echo -e "${RED}❌ curl không được cài đặt. Không thể gọi AI API.${NC}"
        return 1
    fi

    if [[ $? -ne 0 || -z "$response" ]]; then
        echo -e "${RED}❌ Lỗi khi gọi AI API${NC}"
        return 1
    fi

    # Parse response and extract suggestions
    local suggestions
    if command -v jq >/dev/null 2>&1; then
        suggestions=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text // empty' 2>/dev/null)
    else
        # Simple fallback parsing
        suggestions=$(echo "$response" | grep -o '"text"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"text"[[:space:]]*:[[:space:]]*"\(.*\)"/\1/' | head -1)
    fi

    if [[ -n "$suggestions" ]]; then
        # Save suggestions to temporary file
        echo "$suggestions" | grep -E '^[a-z]+\/[a-z0-9\-_]+$' | head -3 > /tmp/ai_suggestions.txt

        local count=$(wc -l < /tmp/ai_suggestions.txt)
        if [[ $count -eq 3 ]]; then
            return 0
        else
            echo -e "${YELLOW}⚠️  AI trả về số lượng gợi ý không đúng ($count/3). Fallback về tên truyền thống.${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  AI không trả về kết quả hợp lệ. Fallback về tên truyền thống.${NC}"
        return 1
    fi
}

# Function to display and select branch option
select_branch_option() {
    local traditional_name=$1

    echo ""
    echo -e "${GREEN}🎯 Chọn tên nhánh:${NC}"
    echo ""

    local options=()
    local index=1

    # Add AI suggestions if available
    if [[ -f /tmp/ai_suggestions.txt ]]; then
        while IFS= read -r suggestion; do
            echo -e "  [$index] ${WHITE}$suggestion${NC}"
            options+=("$suggestion")
            ((index++))
        done < /tmp/ai_suggestions.txt
    fi

    # Add traditional option
    echo -e "  [$index] ${YELLOW}$traditional_name (truyền thống)${NC}"
    options+=("$traditional_name")
    ((index++))

    # Add manual input option
    echo -e "  [$index] ${CYAN}Nhập tên nhánh khác${NC}"
    echo ""

    local choice
    while true; do
        read -p "Lựa chọn (1-$index): " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le $index ]]; then
            if [[ $choice -eq $index ]]; then
                # Manual input
                while true; do
                    read -p "Nhập tên nhánh: " custom_name
                    if [[ -n "$custom_name" ]]; then
                        echo "$custom_name"
                        return
                    fi
                    echo -e "${RED}❌ Tên nhánh không được để trống${NC}"
                done
            else
                # Selected from options
                echo "${options[$((choice-1))]}"
                return
            fi
        fi
        echo -e "${RED}❌ Lựa chọn không hợp lệ. Vui lòng chọn từ 1 đến $index${NC}"
    done
}

# Function to get input interactively
get_interactive_input() {
    echo -e "${YELLOW}📝 Nhập thông tin nhánh:${NC}"

    # Get prefix
    while true; do
        read -p "Prefix (feat/bug/hotfix/sync/refactor/docs/test/chore): " PREFIX
        if validate_prefix "$PREFIX"; then
            break
        else
            echo -e "${RED}❌ Prefix không hợp lệ. Vui lòng chọn: feat, bug, hotfix, sync, refactor, docs, test, chore${NC}"
        fi
    done

    # Get ticket number (optional)
    read -p "Ticket number (optional, nhấn Enter để skip): " TICKET_NUMBER
    # Remove validation - ticket number is now optional

    # Get description
    while true; do
        read -p "Mô tả chi tiết task (VD: implement user authentication system): " DESCRIPTION
        if [[ -n "$DESCRIPTION" ]]; then
            break
        else
            echo -e "${RED}❌ Mô tả không được để trống${NC}"
        fi
    done
}

# Function to run AI mode
run_ai_mode() {
    local prefix=$1
    local ticket=$2
    local description=$3
    local username=$4

    echo ""
    echo -e "${GREEN}🤖 AI Mode được chọn!${NC}"
    echo ""

    # Load configuration
    load_config

    # Create traditional branch name as fallback
    local sanitized_desc=$(sanitize_description "$description")
    local traditional_branch_name
    if [[ -z "$ticket" ]]; then
        traditional_branch_name="${prefix}/${username}_${sanitized_desc}"
    else
        traditional_branch_name="${prefix}/${username}-${ticket}_${sanitized_desc}"
    fi
    local selected_branch_name="$traditional_branch_name"

    # Get AI suggestions if enabled
    local enabled=$(get_config_value "enabled")
    if [[ "$enabled" == "true" ]]; then
        if get_ai_suggestions "$prefix" "$ticket" "$description" "$username"; then
            selected_branch_name=$(select_branch_option "$traditional_branch_name")
        else
            echo -e "${YELLOW}💡 Sử dụng tên nhánh truyền thống: $traditional_branch_name${NC}"
        fi
    else
        echo -e "${YELLOW}💡 Tên nhánh truyền thống: $traditional_branch_name${NC}"
    fi

    echo "$selected_branch_name"
}

# Function to run traditional mode
run_traditional_mode() {
    local prefix=$1
    local ticket=$2
    local description=$3
    local username=$4

    echo ""
    echo -e "${GREEN}⚡ Traditional Mode được chọn!${NC}"
    echo ""

    # Sanitize description
    local sanitized_desc=$(sanitize_description "$description")
    local branch_name
    if [[ -z "$ticket" ]]; then
        branch_name="${prefix}/${username}_${sanitized_desc}"
    else
        branch_name="${prefix}/${username}-${ticket}_${sanitized_desc}"
    fi

    echo -e "${YELLOW}💡 Tên nhánh truyền thống: $branch_name${NC}"

    echo "$branch_name"
}

# Function to create branch
create_git_branch() {
    local branch_name=$1

    echo ""
    echo -e "${GREEN}🎯 Tên nhánh được chọn:${NC} ${WHITE}$branch_name${NC}"
    echo ""

    # Confirm before creating
    read -p "✅ Xác nhận tạo nhánh? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "${YELLOW}❌ Đã hủy tạo nhánh${NC}"
        return
    fi

    # Check if branch already exists
    if git show-ref --verify --quiet refs/heads/"$branch_name"; then
        echo -e "${RED}❌ Lỗi: Nhánh '$branch_name' đã tồn tại${NC}"
        exit 1
    fi

    # Create and checkout new branch
    echo -e "${GREEN}🔄 Đang tạo nhánh...${NC}"
    if git checkout -b "$branch_name"; then
        echo ""
        echo -e "${GREEN}✅ Đã tạo và chuyển sang nhánh '$branch_name' thành công!${NC}"
        echo ""
        echo -e "${YELLOW}📋 Lưu ý:${NC}"
        echo "- Một PR chỉ làm đúng 1 việc của 1 ticket duy nhất"
        echo "- Sử dụng git rebase khi merge code từ staging/master"
        echo "- File không được quá 400 dòng code"
        echo "- Folder name phải ở dạng số nhiều (trừ app/pages)"
        echo ""
        echo -e "${MAGENTA}🎉 Happy coding!${NC}"
    else
        echo -e "${RED}❌ Lỗi: Không thể tạo nhánh '$branch_name'${NC}"
        exit 1
    fi

    # Cleanup
    [[ -f /tmp/ai_suggestions.txt ]] && rm -f /tmp/ai_suggestions.txt
}

# Main script logic
main() {
    # Show help if requested
    if [[ "$HELP" == true ]]; then
        show_usage
        return
    fi

    # Check dependencies
    if ! check_dependencies; then
        echo -e "${YELLOW}⚠️  Một số dependencies thiếu, nhưng script vẫn có thể hoạt động${NC}"
        echo ""
    fi

    # Get git username
    local username=$(get_git_username)
    echo -e "${GREEN}👤 Git username:${NC} $username"
    echo ""

    # Auto-detect command line arguments format
    if [[ -n "$PREFIX" && -n "$TICKET_NUMBER" ]]; then
        # Check if second param is actually a ticket number (numeric) or description
        if [[ "$TICKET_NUMBER" =~ ^[0-9]+$ ]]; then
            # Format: sb feat 123 "description"
            # TICKET_NUMBER is actually a ticket number
            if [[ -z "$DESCRIPTION" ]]; then
                echo -e "${RED}❌ Lỗi: Thiếu description khi sử dụng format có ticket number${NC}"
                show_usage
                exit 1
            fi
        else
            # Format: sb feat "description" (no ticket)
            # TICKET_NUMBER is actually description, shift parameters
            DESCRIPTION="$TICKET_NUMBER"
            TICKET_NUMBER=""
        fi
    fi

    # Check if arguments provided
    if [[ -z "$PREFIX" || -z "$DESCRIPTION" ]]; then
        # Interactive mode - show mode selection
        local mode_choice=$(show_mode_selection)

        if [[ $mode_choice -eq 3 ]]; then
            echo -e "${CYAN}👋 Tạm biệt!${NC}"
            return
        fi

        # Get input interactively
        get_interactive_input
    else
        # Command line mode - ask for mode selection
        echo -e "${GREEN}🚀 === Smart Branch Creator ===${NC}"
        echo ""
        echo -e "${CYAN}Chọn mode cho thông tin đã nhập:${NC}"
        echo -e "  Prefix: ${WHITE}$PREFIX${NC}"

        if [[ -z "$TICKET_NUMBER" ]]; then
            echo -e "  Ticket: ${WHITE}Không có${NC}"
        else
            echo -e "  Ticket: ${WHITE}$TICKET_NUMBER${NC}"
        fi

        echo -e "  Description: ${WHITE}$DESCRIPTION${NC}"
        echo ""
        echo -e "  [1] ${WHITE}🤖 AI Mode - Smart suggestions${NC}"
        echo -e "  [2] ${WHITE}⚡ Traditional Mode - Classic naming${NC}"
        echo -e "  [3] ${WHITE}❌ Thoát${NC}"
        echo ""

        while true; do
            read -p "Lựa chọn (1-3): " mode_choice
            if [[ "$mode_choice" =~ ^[1-3]$ ]]; then
                break
            fi
            echo -e "${RED}❌ Lựa chọn không hợp lệ. Vui lòng chọn từ 1 đến 3${NC}"
        done

        if [[ $mode_choice -eq 3 ]]; then
            echo -e "${CYAN}👋 Tạm biệt!${NC}"
            return
        fi

        # Validate prefix when using command line arguments
        if ! validate_prefix "$PREFIX"; then
            echo -e "${RED}❌ Lỗi: Prefix '$PREFIX' không hợp lệ${NC}"
            show_usage
            exit 1
        fi
    fi

    # Execute based on mode choice
    local selected_branch_name=""
    if [[ $mode_choice -eq 1 ]]; then
        # AI Mode
        selected_branch_name=$(run_ai_mode "$PREFIX" "$TICKET_NUMBER" "$DESCRIPTION" "$username")
    elif [[ $mode_choice -eq 2 ]]; then
        # Traditional Mode
        selected_branch_name=$(run_traditional_mode "$PREFIX" "$TICKET_NUMBER" "$DESCRIPTION" "$username")
    fi

    # Create the branch
    create_git_branch "$selected_branch_name"
}

# Run main function
main "$@"