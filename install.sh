#!/bin/bash

# --- Configuration ---
# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANG_DIR="$SCRIPT_DIR/lang"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
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

detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux" ;;
        Darwin*)    echo "mac" ;;
        *)          echo "unknown" ;;
    esac
}

detect_package_manager() {
    if command -v apt-get >/dev/null 2>&1; then echo "apt"
    elif command -v pacman >/dev/null 2>&1; then echo "pacman"
    elif command -v dnf >/dev/null 2>&1; then echo "dnf"
    elif command -v yum >/dev/null 2>&1; then echo "yum"
    else echo "unknown"; fi
}

install_package() {
    local package_name=$1
    echo -e "${CYAN}$(_t checking_for) ${package_name}...${NC}"
    if ! command -v "$package_name" >/dev/null 2>&1; then
        echo -e "${YELLOW}${package_name} $(_t not_found)${NC}"
        local os=$(detect_os)
        if [[ "$os" == "mac" ]]; then
            if command -v brew >/dev/null 2>&1; then brew install "$package_name"; else echo -e "${RED}$(_t brew_not_found)${NC}"; return 1; fi
        elif [[ "$os" == "linux" ]]; then
            local pm=$(detect_package_manager)
            case "$pm" in
                "apt")    sudo apt-get install -y "$package_name" ;;
                "pacman") sudo pacman -S --noconfirm "$package_name" ;;
                "dnf")    sudo dnf install -y "$package_name" ;;
                "yum")    sudo yum install -y "$package_name" ;;
                *) echo -e "${RED}$(_t unsupported_pm) ${package_name}.${NC}"; return 1 ;;
            esac
        else
            echo -e "${RED}$(_t unsupported_os) ${package_name}.${NC}"; return 1
        fi
        if ! command -v "$package_name" >/dev/null 2>&1; then
            echo -e "${RED}$(_t install_failed) ${package_name}.${NC}"; return 1
        else
            echo -e "${GREEN}$(_t install_success) ${package_name}.${NC}"
        fi
    else
        echo -e "${GREEN}${package_name} $(_t already_installed)${NC}"
    fi
    return 0
}

# --- Main Setup Logic ---
main() {
    # Language Selection
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

    # Source the language file
    if [ -f "$LANG_DIR/$LANG.sh" ]; then
        source "$LANG_DIR/$LANG.sh"
    else
        echo "Error: Language file $LANG_DIR/$LANG.sh not found."
        exit 1
    fi

    # Set language for the main script as well
    export SB_LANG=$LANG
    echo ""

    echo -e "${CYAN}$(_t start_setup)${NC}"
    echo ""

    # 1. Install Dependencies
    echo -e "${YELLOW}$(_t step1)${NC}"
    install_package "curl"
    install_package "jq"
    echo ""

    # 2. Setup AI Configuration
    echo -e "${YELLOW}$(_t step2)${NC}"
    local CONFIG_TEMPLATE="$SCRIPT_DIR/config/config.json.template"
    local CONFIG_FILE="$SCRIPT_DIR/src/config.json"

    if [ ! -f "$CONFIG_FILE" ]; then
        echo "$(_t config_not_found) '$CONFIG_FILE'."
        if [ -f "$CONFIG_TEMPLATE" ]; then
            echo "$(_t copying_template)"
            cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
            echo -e "${GREEN}$(_t create_config_success) $CONFIG_FILE${NC}"
        else
            echo -e "${RED}$(_t template_not_found)${NC}"; exit 1
        fi
    else
        echo "$(_t config_exists) '$CONFIG_FILE'."
    fi

    echo ""
    echo -e "${CYAN}$(_t api_key_prompt)${NC}"
    echo "$(_t api_key_source)"
    local api_key
    read -p "$(_t enter_api_key)" api_key

    if [ -n "$api_key" ]; then
        if command -v jq >/dev/null 2>&1; then
            jq --arg key "$api_key" '.api_key = $key' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
            echo -e "${GREEN}$(_t update_api_key_success) $CONFIG_FILE${NC}"
        else
            echo -e "${YELLOW}$(_t jq_not_found_sed)${NC}"
            sed -i.bak 's/"api_key": *"[^"]*"/"api_key": "'"$api_key"'"/' "$CONFIG_FILE"
            rm -f "${CONFIG_FILE}.bak"
            echo -e "${GREEN}$(_t update_api_key_success) $CONFIG_FILE${NC}"
        fi
    else
        echo -e "${YELLOW}$(_t skip_api_key) '$CONFIG_FILE' later.${NC}"
    fi

    echo ""
    echo -e "${GREEN}$(_t setup_complete)${NC}"
}

# Run main function
main "$@"