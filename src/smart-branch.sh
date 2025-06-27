#!/bin/bash

# Unified Smart Branch - Git Branch Creation Tool
# ===============================================

# --- Configuration ---
# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.json"
LANG_DIR="$(cd "$SCRIPT_DIR/.." && pwd)/lang"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# --- Language Setup ---
LANG="vi" # Default language

# Function to get translated string
_t() {
    local key=$1
    if [[ "$LANG" == "vi" ]]; then
        echo -n "${T_VI[$key]}"
    else
        echo -n "${T_EN[$key]}"
    fi
}

# --- Functions ---

# Function to show usage
show_usage() {
    echo -e "${CYAN}$(_t smart_branch_creator)${NC}"
    echo ""
    echo -e "${YELLOW}$(_t usage):${NC}"
    echo "  ./smart-branch.sh                              # $(_t interactive_mode)"
    echo "  ./smart-branch.sh [prefix] [ticket] [desc]     # $(_t cli_mode_ticket)"
    echo "  ./smart-branch.sh [prefix] [desc]              # $(_t cli_mode_no_ticket)"
    echo ""
    echo -e "${YELLOW}$(_t examples):${NC}"
    echo "  ./smart-branch.sh"
    echo "  ./smart-branch.sh feat 123 \"implement user authentication\""
    echo "  ./smart-branch.sh feat \"add new dashboard\""
    echo ""
    echo -e "${YELLOW}$(_t branch_format):${NC}"
    echo "  $(_t with_ticket): feat/username-123_description"
    echo "  $(_t no_ticket): feat/username_description"
    echo ""
    echo -e "${YELLOW}$(_t suggested_prefixes):${NC}"
    echo "  feat, fix, hotfix, docs, style, refactor, test, chore"
}

# Function to show mode selection menu
show_mode_selection() {
    echo -e "${GREEN}$(_t smart_branch_creator)${NC}" >&2
    echo "" >&2
    echo -e "${CYAN}$(_t select_mode):${NC}" >&2
    echo -e "  [1] ${WHITE}$(_t ai_mode)${NC}" >&2
    echo -e "  [2] ${WHITE}$(_t traditional_mode)${NC}" >&2
    echo -e "  [3] ${WHITE}$(_t exit)${NC}" >&2
    echo "" >&2

    while true; do
        read -p "$(_t choice) (1-3): " choice >&2
        if [[ "$choice" =~ ^[1-3]$ ]]; then
            echo "$choice"
            return
        fi
        echo -e "${RED}❌ $(_t invalid_choice)${NC}" >&2
    done
}

# Function to get git username
get_git_username() {
    local username=$(git config user.name)
    if [[ -z "$username" ]]; then
        echo -e "${RED}❌ $(_t git_user_error)${NC}" >&2
        exit 1
    fi
    echo "$username" | tr '[:upper:]' '[:lower:]' | tr -d ' '
}

# Function to sanitize description
sanitize_description() {
    local desc=$1
    echo "$desc" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g'
}

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux" ;;
        Darwin*)    echo "mac" ;;
        *)          echo "unknown" ;;
    esac
}

# Function to check dependencies
check_dependencies() {
    local missing_deps=()
    if ! command -v curl >/dev/null 2>&1; then missing_deps+=("curl"); fi
    if ! command -v jq >/dev/null 2>&1; then echo -e "${YELLOW}⚠️  $(_t jq_not_installed)${NC}" >&2; fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  $(_t missing_deps): ${missing_deps[*]}${NC}" >&2
        echo -e "${CYAN}💡 $(_t run_install)${NC}" >&2
        local os=$(detect_os)
        if [[ "$os" == "linux" ]]; then
            echo -e "${CYAN}💡 $(_t manual_install):${NC}" >&2
            if command -v pacman >/dev/null 2>&1; then echo "  sudo pacman -S ${missing_deps[*]}" >&2
            elif command -v apt >/dev/null 2>&1; then echo "  sudo apt install ${missing_deps[*]}" >&2
            elif command -v dnf >/dev/null 2>&1; then echo "  sudo dnf install ${missing_deps[*]}" >&2
            elif command -v yum >/dev/null 2>&1; then echo "  sudo yum install ${missing_deps[*]}" >&2
            fi
        elif [[ "$os" == "mac" ]]; then
            echo -e "${CYAN}💡 $(_t on_macos):${NC}" >&2
            echo "  brew install ${missing_deps[*]}" >&2
        fi
        return 1
    fi
    return 0
}

# Function to load configuration
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo -e "${YELLOW}⚠️  $(_t config_not_found)${NC}" >&2
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
        echo -e "${GREEN}📁 $(_t config_created)${NC}" >&2
    fi
}

# Function to get config value
get_config_value() {
    local key=$1
    if command -v jq >/dev/null 2>&1; then
        jq -r ".$key // empty" "$CONFIG_FILE" 2>/dev/null
    else
        grep "\"$key\"" "$CONFIG_FILE" | sed 's/.*"'$key'": *"\([^"]*\)".*/\1/' | head -1
    fi
}

# Function to call Gemini API
get_ai_suggestions() {
    local prefix=$1 ticket=$2 description=$3 username=$4
    local api_key=$(get_config_value "api_key")
    local enabled=$(get_config_value "enabled")
    local endpoint=$(get_config_value "endpoint")
    local temperature=$(get_config_value "temperature")
    local max_tokens=$(get_config_value "max_tokens")

    if [[ -z "$api_key" || "$enabled" != "true" ]]; then
        echo -e "${YELLOW}⚠️  $(_t ai_disabled)${NC}" >&2
        return 1
    fi

    echo -e "${CYAN}$(_t calling_ai)${NC}" >&2

    local branch_format ticket_info example_formats
    if [[ -z "$ticket" ]]; then
        branch_format="{prefix}/{username}_{description}"
        example_formats="feat/username_add-user-auth"
        ticket_info="- Ticket: $(_t no_ticket) (optional)"
    else
        branch_format="{prefix}/{username}-{ticket}_{description}"
        example_formats="feat/username-123_add-user-auth"
        ticket_info="- Ticket: $ticket"
    fi

    local prompt="Bạn là AI chuyên gia đặt tên nhánh Git. Hãy tạo CHÍNH XÁC 5 tên nhánh phù hợp với thông tin sau, mỗi dòng 1 tên, KHÔNG thêm bất kỳ giải thích, text hoặc ký tự nào khác ngoài 5 tên nhánh:
- Prefix: $prefix
$ticket_info
- Mô tả task: $description
- Username: $username

Định dạng: $branch_format

Ví dụ:
$example_formats"

    local json_payload
    json_payload=$(printf '{"contents":[{"parts":[{"text":"%s"}]}],"generationConfig":{"temperature":%s,"maxOutputTokens":%s}}' "$prompt" "${temperature:-0.7}" "${max_tokens:-150}")

    local response
    if command -v curl >/dev/null 2>&1; then
        response=$(curl -s -X POST -H "Content-Type: application/json" -d "$json_payload" "$endpoint?key=$api_key" 2>/dev/null)
    else
        echo -e "${RED}❌ $(_t curl_not_installed)${NC}" >&2
        return 1
    fi

    if [[ $? -ne 0 || -z "$response" ]]; then
        echo -e "${RED}❌ $(_t ai_api_error)${NC}" >&2
        return 1
    fi

    local suggestions
    if command -v jq >/dev/null 2>&1; then
        suggestions=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text // empty' 2>/dev/null)
    else
        suggestions=$(echo "$response" | grep -o '"text"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"text"[[:space:]]*:[[:space:]]*"\(.*\)"/\1/' | head -1)
    fi

    if [[ -n "$suggestions" ]]; then
        echo "$suggestions" | grep -E '^[a-z]+/[a-z0-9_-]+$' | head -5 > /tmp/ai_suggestions.txt
        local count=$(wc -l < /tmp/ai_suggestions.txt)
        if [[ $count -eq 5 ]]; then
            return 0
        else
            echo -e "${YELLOW}⚠️  $(_t ai_suggestion_count_error) ($count/5). $(_t ai_fallback)${NC}" >&2
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  $(_t ai_invalid_result)${NC}" >&2
        return 1
    fi
}

# Function to display and select branch option
select_branch_option() {
    local traditional_name=$1
    echo "" >&2
    echo -e "${GREEN}$(_t select_branch_name):${NC}" >&2
    echo "" >&2

    local options=() index=1
    if [[ -f /tmp/ai_suggestions.txt ]]; then
        while IFS= read -r suggestion; do
            echo -e "  [$index] ${WHITE}$suggestion${NC}" >&2
            options+=("$suggestion")
            ((index++))
        done < /tmp/ai_suggestions.txt
    fi

    echo -e "  [$index] ${YELLOW}$traditional_name ($(_t traditional_option))${NC}" >&2
    options+=("$traditional_name")
    ((index++))
    echo -e "  [$index] ${CYAN}$(_t other_branch_name)${NC}" >&2
    echo "" >&2

    local max_choice=$index
    local choice
    while true; do
        read -p "$(_t choice) (1-$max_choice): " choice >&2
        if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le $max_choice ]]; then
            if [[ $choice -eq $max_choice ]]; then
                while true; do
                    read -p "$(_t enter_branch_name): " custom_name >&2
                    if [[ -n "$custom_name" ]]; then echo "$custom_name"; return; fi
                    echo -e "${RED}❌ $(_t branch_name_empty)${NC}" >&2
                done
            else
                echo "${options[$((choice-1))]}"; return
            fi
        fi
        echo -e "${RED}❌ $(_t invalid_choice)${NC}" >&2
    done
}

# Function to get input interactively
get_interactive_input() {
    echo -e "${YELLOW}$(_t enter_branch_info):${NC}" >&2
    echo -e "${CYAN}$(_t prefix_suggestions): feat, bug, hotfix, docs, style, refactor, test, chore${NC}" >&2
    read -p "$(_t prefix_prompt): " PREFIX >&2
    read -p "$(_t ticket_prompt): " TICKET_NUMBER >&2
    while true; do
        read -p "$(_t desc_prompt): " DESCRIPTION >&2
        if [[ -n "$DESCRIPTION" ]]; then break; fi
        echo -e "${RED}❌ $(_t desc_empty)${NC}" >&2
    done
}

# Function to run AI mode
run_ai_mode() {
    local prefix=$1 ticket=$2 description=$3 username=$4
    echo "" >&2; echo -e "${GREEN}$(_t ai_mode_selected)${NC}" >&2; echo "" >&2
    load_config
    local sanitized_desc=$(sanitize_description "$description")
    local traditional_branch_name
    if [[ -z "$ticket" ]]; then traditional_branch_name="${prefix}/${username}_${sanitized_desc}"; else traditional_branch_name="${prefix}/${username}-${ticket}_${sanitized_desc}"; fi
    local selected_branch_name="$traditional_branch_name"
    local enabled=$(get_config_value "enabled")
    if [[ "$enabled" == "true" ]]; then
        if get_ai_suggestions "$prefix" "$ticket" "$description" "$username"; then
            selected_branch_name=$(select_branch_option "$traditional_branch_name")
        else
            echo -e "${YELLOW}💡 $(_t using_traditional_branch_name): $traditional_branch_name${NC}" >&2
        fi
    else
        echo -e "${YELLOW}💡 $(_t using_traditional_branch_name): $traditional_branch_name${NC}" >&2
    fi
    echo "$selected_branch_name"
}

# Function to run traditional mode
run_traditional_mode() {
    local prefix=$1 ticket=$2 description=$3 username=$4
    echo "" >&2; echo -e "${GREEN}$(_t traditional_mode_selected)${NC}" >&2; echo "" >&2
    local sanitized_desc=$(sanitize_description "$description")
    local branch_name
    if [[ -z "$ticket" ]]; then branch_name="${prefix}/${username}_${sanitized_desc}"; else branch_name="${prefix}/${username}-${ticket}_${sanitized_desc}"; fi
    echo -e "${YELLOW}💡 $(_t using_traditional_branch_name): $branch_name${NC}" >&2
    echo "$branch_name"
}

# Function to create branch
create_git_branch() {
    local branch_name=$1
    echo ""; echo -e "${GREEN}$(_t branch_name_selected):${NC} ${WHITE}$branch_name${NC}"; echo ""
    local confirm
    read -p "$(_t confirm_creation) " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "${YELLOW}$(_t creation_cancelled)${NC}"; return
    fi
    if git show-ref --verify --quiet refs/heads/"$branch_name"; then
        echo -e "${RED}❌ $(_t branch_exists_error) '$branch_name' $(_t branch_exists_error2)${NC}"; exit 1
    fi
    echo -e "${GREEN}$(_t creating_branch)${NC}"
    if git checkout -b "$branch_name"; then
        echo ""; echo -e "${GREEN}✅ $(_t branch_created_success) '$branch_name' $(_t branch_created_success2)${NC}"; echo ""
        echo -e "${YELLOW}$(_t notes):${NC}"; echo "$(_t note1)"; echo "$(_t note2)"; echo "$(_t note3)"; echo "$(_t note4)"; echo ""
        echo -e "${MAGENTA}$(_t happy_coding)${NC}"
    else
        echo -e "${RED}❌ $(_t creation_failed) '$branch_name'${NC}"; exit 1
    fi
    [[ -f /tmp/ai_suggestions.txt ]] && rm -f /tmp/ai_suggestions.txt
}

# --- Main Script Logic ---
main() {
    # --- Language Selection ---
    if [[ -z "$SB_LANG" ]]; then
        echo "Please select a language / Vui lòng chọn ngôn ngữ:"
        echo "  [1] English"
        echo "  [2] Vietnamese"
        local lang_choice
        while true; do
            read -p "Choice (1-2): " lang_choice
            if [[ "$lang_choice" == "1" ]]; then LANG="en"; break;
            elif [[ "$lang_choice" == "2" ]]; then LANG="vi"; break;
            else echo "Invalid choice. Please enter 1 or 2."; fi
        done
    else
        LANG="$SB_LANG"
    fi

    # Source the language file
    if [ -f "$LANG_DIR/$LANG.sh" ]; then
        source "$LANG_DIR/$LANG.sh"
    else
        echo "Error: Language file $LANG_DIR/$LANG.sh not found."
        exit 1
    fi
    echo ""

    # Parse command line arguments
    local PREFIX TICKET_NUMBER DESCRIPTION HELP=false
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help) HELP=true; shift ;;
            *)
                if [[ -z "$PREFIX" ]]; then PREFIX="$1"
                elif [[ -z "$TICKET_NUMBER" ]]; then TICKET_NUMBER="$1"
                elif [[ -z "$DESCRIPTION" ]]; then DESCRIPTION="$1"
                fi; shift ;;
        esac
    done

    if [[ "$HELP" == true ]]; then show_usage; return; fi
    if ! check_dependencies; then echo -e "${YELLOW}⚠️  $(_t deps_missing_warning)${NC}" >&2; echo "" >&2; fi

    local username=$(get_git_username)
    echo -e "${GREEN}$(_t git_username):${NC} $username" >&2; echo "" >&2

    if [[ -n "$PREFIX" && -n "$TICKET_NUMBER" ]]; then
        if ! [[ "$TICKET_NUMBER" =~ ^[0-9]+$ ]]; then
            DESCRIPTION="$TICKET_NUMBER"; TICKET_NUMBER=""
        elif [[ -z "$DESCRIPTION" ]]; then
            echo -e "${RED}❌ $(_t desc_missing_error)${NC}" >&2; show_usage; exit 1
        fi
    fi

    local mode_choice
    if [[ -z "$PREFIX" || -z "$DESCRIPTION" ]]; then
        mode_choice=$(show_mode_selection)
        if [[ $mode_choice -eq 3 ]]; then echo -e "${CYAN}$(_t goodbye)${NC}" >&2; return; fi
        get_interactive_input
    else
        echo -e "${GREEN}$(_t smart_branch_creator)${NC}" >&2; echo "" >&2
        echo -e "${CYAN}$(_t mode_for_info):${NC}" >&2
        echo -e "  Prefix: ${WHITE}$PREFIX${NC}" >&2
        if [[ -z "$TICKET_NUMBER" ]]; then echo -e "  Ticket: ${WHITE}$(_t no_ticket)${NC}" >&2; else echo -e "  Ticket: ${WHITE}$TICKET_NUMBER${NC}" >&2; fi
        echo -e "  Description: ${WHITE}$DESCRIPTION${NC}" >&2; echo "" >&2
        echo -e "  [1] ${WHITE}$(_t ai_mode)${NC}" >&2
        echo -e "  [2] ${WHITE}$(_t traditional_mode)${NC}" >&2
        echo -e "  [3] ${WHITE}$(_t exit)${NC}" >&2; echo "" >&2
        while true; do
            read -p "$(_t choice) (1-3): " mode_choice >&2
            if [[ "$mode_choice" =~ ^[1-3]$ ]]; then break; fi
            echo -e "${RED}❌ $(_t invalid_choice)${NC}" >&2
        done
        if [[ $mode_choice -eq 3 ]]; then echo -e "${CYAN}$(_t goodbye)${NC}" >&2; return; fi
    fi

    local selected_branch_name=""
    if [[ $mode_choice -eq 1 ]]; then
        selected_branch_name=$(run_ai_mode "$PREFIX" "$TICKET_NUMBER" "$DESCRIPTION" "$username")
    elif [[ $mode_choice -eq 2 ]]; then
        selected_branch_name=$(run_traditional_mode "$PREFIX" "$TICKET_NUMBER" "$DESCRIPTION" "$username")
    fi

    create_git_branch "$selected_branch_name"
}

# Run main function
main "$@"