#!/bin/bash

# Smart Branch Setup Script for Linux
# Tự động cài đặt aliases và dependencies cho Linux systems

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${CYAN}🚀 === Smart Branch Linux Setup ===${NC}"
echo ""

# Function to detect shell
detect_shell() {
    if [[ -n "$ZSH_VERSION" ]]; then
        echo "zsh"
    elif [[ -n "$BASH_VERSION" ]]; then
        echo "bash"
    elif [[ -n "$FISH_VERSION" ]]; then
        echo "fish"
    else
        # Fallback to checking $SHELL
        case "$SHELL" in
            */zsh) echo "zsh" ;;
            */bash) echo "bash" ;;
            */fish) echo "fish" ;;
            *) echo "bash" ;; # Default fallback
        esac
    fi
}

# Function to get shell config file
get_shell_config() {
    local shell_type=$1
    case "$shell_type" in
        "zsh")
            if [[ -f "$HOME/.zshrc" ]]; then
                echo "$HOME/.zshrc"
            else
                echo "$HOME/.zshrc"
            fi
            ;;
        "fish")
            mkdir -p "$HOME/.config/fish"
            echo "$HOME/.config/fish/config.fish"
            ;;
        "bash")
            if [[ -f "$HOME/.bashrc" ]]; then
                echo "$HOME/.bashrc"
            elif [[ -f "$HOME/.bash_profile" ]]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        *)
            echo "$HOME/.bashrc"
            ;;
    esac
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}📦 Kiểm tra dependencies...${NC}"

    local missing_deps=()

    # Check curl
    if ! command_exists curl; then
        missing_deps+=("curl")
    fi

    # Check jq (optional but recommended)
    if ! command_exists jq; then
        echo -e "${YELLOW}⚠️  jq không được cài đặt (optional cho AI features)${NC}"
        read -p "Bạn có muốn cài đặt jq? (y/N): " install_jq
        if [[ "$install_jq" == "y" || "$install_jq" == "Y" ]]; then
            missing_deps+=("jq")
        fi
    fi

    if [[ ${#missing_deps[@]} -eq 0 ]]; then
        echo -e "${GREEN}✅ Tất cả dependencies đã sẵn sàng${NC}"
        return 0
    fi

    echo -e "${YELLOW}📦 Cần cài đặt: ${missing_deps[*]}${NC}"

    # Detect package manager and install
    if command_exists pacman; then
        # Arch Linux
        echo -e "${BLUE}🔧 Phát hiện Arch Linux, sử dụng pacman...${NC}"
        sudo pacman -S --needed "${missing_deps[@]}"
    elif command_exists apt; then
        # Debian/Ubuntu
        echo -e "${BLUE}🔧 Phát hiện Debian/Ubuntu, sử dụng apt...${NC}"
        sudo apt update
        sudo apt install -y "${missing_deps[@]}"
    elif command_exists dnf; then
        # Fedora/CentOS/RHEL (modern)
        echo -e "${BLUE}🔧 Phát hiện Fedora/RHEL, sử dụng dnf...${NC}"
        sudo dnf install -y "${missing_deps[@]}"
    elif command_exists yum; then
        # CentOS/RHEL (legacy)
        echo -e "${BLUE}🔧 Phát hiện CentOS/RHEL, sử dụng yum...${NC}"
        sudo yum install -y "${missing_deps[@]}"
    elif command_exists zypper; then
        # openSUSE
        echo -e "${BLUE}🔧 Phát hiện openSUSE, sử dụng zypper...${NC}"
        sudo zypper install -y "${missing_deps[@]}"
    elif command_exists apk; then
        # Alpine Linux
        echo -e "${BLUE}🔧 Phát hiện Alpine Linux, sử dụng apk...${NC}"
        sudo apk add "${missing_deps[@]}"
    else
        echo -e "${RED}❌ Không thể tự động cài đặt dependencies${NC}"
        echo -e "${YELLOW}📋 Vui lòng cài đặt thủ công: ${missing_deps[*]}${NC}"
        return 1
    fi
}

# Function to set executable permissions
set_permissions() {
    echo -e "${YELLOW}🔧 Cài đặt permissions...${NC}"

    chmod +x "$SCRIPT_DIR/smart-branch.sh"
    chmod +x "$SCRIPT_DIR/sb"

    echo -e "${GREEN}✅ Đã cài đặt permissions${NC}"
}

# Function to add aliases to shell config
add_shell_aliases() {
    local shell_type=$(detect_shell)
    local config_file=$(get_shell_config "$shell_type")

    echo -e "${YELLOW}🐚 Phát hiện shell: ${WHITE}$shell_type${NC}"
    echo -e "${YELLOW}📁 Config file: ${WHITE}$config_file${NC}"

    # Create config file if it doesn't exist
    if [[ ! -f "$config_file" ]]; then
        touch "$config_file"
        echo -e "${GREEN}📁 Đã tạo file config: $config_file${NC}"
    fi

    # Check if alias already exists
    if grep -q "alias sb=" "$config_file" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Alias 'sb' đã tồn tại trong $config_file${NC}"
        read -p "Bạn có muốn cập nhật? (y/N): " update_alias
        if [[ "$update_alias" != "y" && "$update_alias" != "Y" ]]; then
            echo -e "${YELLOW}⏭️  Bỏ qua cập nhật alias${NC}"
            return 0
        fi

        # Remove existing alias
        if [[ "$shell_type" == "fish" ]]; then
            sed -i '/alias sb=/d' "$config_file" 2>/dev/null || true
        else
            sed -i '/alias sb=/d' "$config_file" 2>/dev/null || true
        fi
    fi

    # Add alias based on shell type
    echo ""
    echo -e "${YELLOW}📝 Thêm alias vào $config_file...${NC}"

    if [[ "$shell_type" == "fish" ]]; then
        # Fish shell syntax
        echo "" >> "$config_file"
        echo "# Smart Branch alias - added by setup-linux.sh" >> "$config_file"
        echo "alias sb='$SCRIPT_DIR/sb'" >> "$config_file"
    else
        # Bash/Zsh syntax
        echo "" >> "$config_file"
        echo "# Smart Branch alias - added by setup-linux.sh" >> "$config_file"
        echo "alias sb='$SCRIPT_DIR/sb'" >> "$config_file"
    fi

    echo -e "${GREEN}✅ Đã thêm alias 'sb' vào $config_file${NC}"
}

# Function to create config.json if not exists
create_config() {
    local config_file="$SCRIPT_DIR/config.json"

    if [[ ! -f "$config_file" ]]; then
        echo -e "${YELLOW}📁 Tạo file config.json...${NC}"
        cat > "$config_file" << 'EOF'
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
        echo -e "${GREEN}✅ Đã tạo config.json${NC}"
        echo -e "${CYAN}💡 Để sử dụng AI features, vui lòng cập nhật API key trong file này${NC}"
    else
        echo -e "${GREEN}✅ config.json đã tồn tại${NC}"
    fi
}

# Function to test installation
test_installation() {
    echo -e "${YELLOW}🧪 Kiểm tra installation...${NC}"

    # Test script execution
    if [[ -x "$SCRIPT_DIR/smart-branch.sh" ]]; then
        echo -e "${GREEN}✅ smart-branch.sh có thể thực thi${NC}"
    else
        echo -e "${RED}❌ smart-branch.sh không thể thực thi${NC}"
        return 1
    fi

    # Test universal launcher
    if [[ -x "$SCRIPT_DIR/sb" ]]; then
        echo -e "${GREEN}✅ Universal launcher 'sb' có thể thực thi${NC}"
    else
        echo -e "${RED}❌ Universal launcher 'sb' không thể thực thi${NC}"
        return 1
    fi

    # Test git config
    if git config user.name >/dev/null 2>&1; then
        local username=$(git config user.name)
        echo -e "${GREEN}✅ Git username: $username${NC}"
    else
        echo -e "${YELLOW}⚠️  Git username chưa được cấu hình${NC}"
        echo -e "${CYAN}💡 Chạy: git config --global user.name \"Your Name\"${NC}"
    fi

    return 0
}

# Main setup function
main() {
    echo -e "${BLUE}🔍 Kiểm tra hệ thống...${NC}"
    echo "OS: $(uname -s)"
    echo "Architecture: $(uname -m)"
    echo "Current directory: $PWD"
    echo "Script directory: $SCRIPT_DIR"
    echo ""

    # Install dependencies
    if ! install_dependencies; then
        echo -e "${RED}❌ Không thể cài đặt dependencies${NC}"
        echo -e "${YELLOW}⚠️  Setup có thể không hoàn chỉnh${NC}"
    fi

    echo ""

    # Set permissions
    set_permissions

    echo ""

    # Create config
    create_config

    echo ""

    # Add shell aliases
    add_shell_aliases

    echo ""

    # Test installation
    if test_installation; then
        echo ""
        echo -e "${GREEN}🎉 === Setup hoàn thành thành công! ===${NC}"
        echo ""
        echo -e "${CYAN}📋 Bước tiếp theo:${NC}"
        echo "1. Reload shell config:"

        local shell_type=$(detect_shell)
        local config_file=$(get_shell_config "$shell_type")
        echo -e "   ${WHITE}source $config_file${NC}"

        echo ""
        echo "2. Sử dụng Smart Branch:"
        echo -e "   ${WHITE}sb${NC}                    # Interactive mode"
        echo -e "   ${WHITE}sb feat 123 \"feature\"${NC}  # Command line mode"
        echo ""
        echo -e "${YELLOW}💡 Để sử dụng AI features, cập nhật API key trong config.json${NC}"
        echo -e "${CYAN}🔗 https://makersuite.google.com/app/apikey${NC}"
    else
        echo ""
        echo -e "${RED}❌ Setup gặp lỗi. Vui lòng kiểm tra lại${NC}"
        exit 1
    fi
}

# Check if running as root (not recommended)
if [[ $EUID -eq 0 ]]; then
    echo -e "${YELLOW}⚠️  Đang chạy với quyền root. Khuyến nghị chạy với user thường${NC}"
    read -p "Tiếp tục? (y/N): " continue_root
    if [[ "$continue_root" != "y" && "$continue_root" != "Y" ]]; then
        echo -e "${YELLOW}👋 Setup đã bị hủy${NC}"
        exit 0
    fi
fi

# Run main setup
main "$@"