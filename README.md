# Smart Branch 🚀

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue)](https://github.com/LuuKhoaHoc/smart-branch)
[![Shell](https://img.shields.io/badge/shell-Bash%20%7C%20PowerShell%20%7C%20Zsh%20%7C%20Fish-green)](https://github.com/LuuKhoaHoc/smart-branch)
[![AI](https://img.shields.io/badge/AI-Google%20Gemini-orange)](https://ai.google.dev/)

**Công cụ tạo nhánh Git thông minh với AI hỗ trợ từ Google Gemini**

_CHỈ CẦN NHỚ 1 COMMAND: `sb`_

[Cài đặt](#-cài-đặt) • [Sử dụng](#-sử-dụng) • [Tính năng](#-tính-năng) • [Cấu hình](#️-cấu-hình) • [Đóng góp](#-đóng-góp)

</div>

---

## 🎯 Tính năng chính

- **🎯 Ticket number OPTIONAL** - Linh hoạt với hoặc không có ticket
- **🤖 AI Mode** - Smart suggestions với Google Gemini API
- **⚡ Traditional Mode** - Classic naming convention
- **🔄 Auto-detect format** trong command line mode
- **🌐 Cross-platform** - Windows, Linux, macOS
- **📋 Interactive & Command-line** modes
- **🐚 Multi-shell support** - Bash, Zsh, Fish, PowerShell

## 🚀 Quick Start

### Một lệnh duy nhất để nhớ:

```bash
sb
```

### Command Formats

```bash
# Interactive mode
sb

# Command line với ticket
sb feat 123 "implement authentication"

# Command line không ticket
sb feat "add new dashboard"
```

## 📦 Cài đặt

### Windows (PowerShell)

```powershell
# Clone repository
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Setup alias trong PowerShell profile
notepad $PROFILE

# Thêm vào profile:
Set-Alias -Name sb -Value smart_branch
function smart_branch { & "C:/path/to/smart-branch/src/smart-branch.ps1" $args }

# Reload profile
. $PROFILE
```

### Linux/macOS

```bash
# Clone repository
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Auto setup
./src/setup-linux.sh
source ~/.bashrc  # hoặc ~/.zshrc

# Sử dụng ngay
sb
```

### Manual Setup (Linux/macOS)

```bash
# Make executable
chmod +x src/smart-branch.sh
chmod +x sb

# Add alias to shell config
echo 'alias sb="/path/to/smart-branch/sb"' >> ~/.bashrc
source ~/.bashrc
```

## 💻 Sử dụng

### Interactive Mode

```bash
sb
```

Sẽ hiển thị menu với các tùy chọn:

- 🤖 AI Mode - Smart suggestions với Google Gemini
- ⚡ Traditional Mode - Classic naming convention

### Command Line Mode

```bash
# Với ticket number
sb feat 123 "implement user authentication"
# → feat/username-123_implement-user-auth

# Không ticket number
sb feat "add new dashboard"
# → feat/username_add-new-dashboard

# Các prefix được hỗ trợ
sb bug "fix login redirect issue"
sb refactor "optimize database queries"
sb docs "update API documentation"
```

### Help

```bash
sb --help        # Linux/macOS
sb -Help         # Windows
```

## 🤖 AI Features

### Google Gemini Integration

Smart Branch sử dụng Google Gemini API để tạo ra 3 gợi ý tên nhánh thông minh:

**Input:**

```
Prefix: feat
Ticket: 123
Description: implement user authentication system
```

**AI Output:**

```
🎯 Chọn tên nhánh:
  [1] feat/username-123_implement-user-auth
  [2] feat/username-123_add-auth-system
  [3] feat/username-123_create-login-feature
  [4] feat/username-123_implement-user-authentication-system (truyền thống)
  [5] Nhập tên nhánh khác
```

### AI vs Traditional Modes

| Feature       | AI Mode                | Traditional Mode     |
| ------------- | ---------------------- | -------------------- |
| **Tốc độ**    | ~2-3 giây              | Tức thì              |
| **Tính năng** | 3 gợi ý thông minh     | Sanitize description |
| **Yêu cầu**   | API key + internet     | Chỉ cần Git          |
| **Fallback**  | Tự động về traditional | N/A                  |

## ⚙️ Cấu hình

### AI Setup (Google Gemini)

1. **Lấy API Key:**

   - Truy cập [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Tạo API key mới (miễn phí)

2. **Cấu hình:**

   ```bash
   # Copy template config
   cp config/config.json.template config.json

   # Edit config.json
   nano config.json
   ```

3. **Cập nhật API key:**
   ```json
   {
     "ai_provider": "gemini",
     "api_key": "YOUR_GEMINI_API_KEY_HERE",
     "model": "gemini-2.0-flash-exp",
     "enabled": true
   }
   ```

### Branch Naming Convention

**Với ticket number:**

```
prefix/{username}-{ticket_number}_description
```

**Không ticket number:**

```
prefix/{username}_description
```

- **prefix**: feat, bug, hotfix, sync, refactor, docs, test, chore
- **username**: tự động lấy từ `git config user.name`
- **ticket_number**: ID của ticket (OPTIONAL)
- **description**: mô tả ngắn gọn được sanitize

## 🛠️ Requirements

### Minimum Requirements

- Git với `git config user.name` đã thiết lập
- **Windows**: PowerShell 3.0+
- **Linux/macOS**: Bash 4.0+ hoặc Zsh

### Optional (cho AI features)

- curl (để gọi API)
- jq (để parse JSON responses)

### Supported Shells

- ✅ Bash
- ✅ Zsh
- ✅ Fish
- ✅ PowerShell

## 🔧 Troubleshooting

### Common Issues

```bash
# Git config chưa thiết lập
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Permission issues (Linux/macOS)
chmod +x src/smart-branch.sh
chmod +x sb

# PowerShell execution policy (Windows)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# AI không hoạt động
# Kiểm tra API key trong config.json hoặc tắt AI:
# "enabled": false
```

### Dependencies Installation

**Arch Linux:**

```bash
sudo pacman -S curl jq
```

**Ubuntu/Debian:**

```bash
sudo apt install curl jq
```

**macOS:**

```bash
brew install curl jq
```

## 📁 Project Structure

```
smart-branch/
├── src/                        # Core scripts
│   ├── smart-branch.sh         # Linux/macOS script
│   ├── smart-branch.ps1        # Windows PowerShell script
│   ├── setup-linux.sh          # Linux auto-setup
│   └── quick-branch.bat        # Windows quick tool
├── config/                     # Configuration
│   └── config.json.template    # AI configuration template
├── examples/                   # Usage examples
│   └── demo.sh                 # Demo script
├── docs/                       # Documentation
├── .github/                    # GitHub templates
│   ├── ISSUE_TEMPLATE/
│   └── workflows/
├── sb                          # Universal launcher
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── CHANGELOG.md
└── .gitignore
```

## 🤝 Đóng góp

Chúng tôi hoan nghênh mọi đóng góp! Vui lòng đọc [CONTRIBUTING.md](CONTRIBUTING.md) để biết thêm chi tiết.

### Development Setup

```bash
# Clone repository
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Setup development environment
./src/setup-linux.sh

# Run tests
./examples/demo.sh
```

## 📄 License

Dự án này được cấp phép theo [MIT License](LICENSE).

## 🎉 Acknowledgments

- [Google Gemini](https://ai.google.dev/) cho AI capabilities
- Git community cho inspiration
- Tất cả contributors đã đóng góp

---

<div align="center">

**[⭐ Star này repository nếu bạn thấy hữu ích!](https://github.com/LuuKhoaHoc/smart-branch)**

Made with ❤️ by [khoahoc](https://github.com/LuuKhoaHoc)

</div>
