# Installation Guide 📦

Hướng dẫn chi tiết cài đặt Smart Branch trên các platform khác nhau.

## 📋 Requirements

### Minimum Requirements

- **Git** 2.0+ với `git config user.name` đã thiết lập
- **Windows**: PowerShell 3.0+ (Windows 7+)
- **Linux**: Bash 4.0+ hoặc Zsh
- **macOS**: Bash 3.2+ hoặc Zsh (built-in)

### Optional Requirements (cho AI features)

- **curl** - để gọi API
- **jq** - để parse JSON responses
- **Internet connection** - cho Google Gemini API

## 🚀 Quick Installation

### Option 1: Clone Repository

```bash
# Clone repository
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Linux/macOS - Auto setup
./src/setup-linux.sh

# Windows - Manual setup (xem bên dưới)
```

### Option 2: Download Release

```bash
# Download latest release
curl -L https://github.com/LuuKhoaHoc/smart-branch/releases/latest/download/smart-branch.zip -o smart-branch.zip
unzip smart-branch.zip
cd smart-branch
```

## 🐧 Linux Installation

### Automatic Setup

```bash
# Clone repository
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Run setup script
./src/setup-linux.sh

# Reload shell
source ~/.bashrc  # or ~/.zshrc for Zsh users
```

### Manual Setup

```bash
# Make scripts executable
chmod +x src/smart-branch.sh
chmod +x sb

# Add alias to shell config
echo 'alias sb="/path/to/smart-branch/sb"' >> ~/.bashrc

# For Zsh users
echo 'alias sb="/path/to/smart-branch/sb"' >> ~/.zshrc

# Reload shell
source ~/.bashrc  # or source ~/.zshrc
```

### Distribution-specific Notes

**Ubuntu/Debian:**

```bash
# Install dependencies
sudo apt update
sudo apt install curl jq git

# Then run setup
./src/setup-linux.sh
```

**Arch Linux:**

```bash
# Install dependencies
sudo pacman -S curl jq git

# Then run setup
./src/setup-linux.sh
```

**CentOS/RHEL/Fedora:**

```bash
# Fedora
sudo dnf install curl jq git

# CentOS/RHEL
sudo yum install curl jq git

# Then run setup
./src/setup-linux.sh
```

## 🍎 macOS Installation

### Using Git (Recommended)

```bash
# Clone repository
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Run setup
./src/setup-linux.sh

# Reload shell
source ~/.zshrc  # or ~/.bash_profile
```

### Install Dependencies

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install curl jq git
```

### Shell Configuration

**Zsh (default trên macOS Catalina+):**

```bash
echo 'alias sb="/path/to/smart-branch/sb"' >> ~/.zshrc
source ~/.zshrc
```

**Bash:**

```bash
echo 'alias sb="/path/to/smart-branch/sb"' >> ~/.bash_profile
source ~/.bash_profile
```

## 🪟 Windows Installation

### PowerShell Setup

1. **Clone Repository:**

```powershell
# Clone using Git
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Or download và extract ZIP file
```

2. **Set Execution Policy:**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

3. **Create PowerShell Profile:**

```powershell
# Check if profile exists
Test-Path $PROFILE

# Create if not exists
if (!(Test-Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }

# Edit profile
notepad $PROFILE
```

4. **Add to Profile:**

```powershell
# Add these lines to your PowerShell profile
Set-Alias -Name sb -Value smart_branch
function smart_branch {
    & "C:/path/to/smart-branch/src/smart-branch.ps1" $args
}
```

5. **Reload Profile:**

```powershell
. $PROFILE
```

### Windows Subsystem for Linux (WSL)

```bash
# Inside WSL, follow Linux instructions
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch
./src/setup-linux.sh
```

### Git Bash

```bash
# Clone repository
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Make executable
chmod +x src/smart-branch.sh
chmod +x sb

# Add alias to ~/.bashrc
echo 'alias sb="/path/to/smart-branch/sb"' >> ~/.bashrc
source ~/.bashrc
```

## 🔧 Configuration

### AI Setup (Optional)

1. **Get Google Gemini API Key:**

   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create new API key (free tier available)

2. **Configure Smart Branch:**

```bash
# Copy template
cp config/config.json.template config.json

# Edit configuration
nano config.json  # or your preferred editor
```

3. **Update API Key:**

```json
{
  "ai_provider": "gemini",
  "api_key": "YOUR_GEMINI_API_KEY_HERE",
  "model": "gemini-2.0-flash-exp",
  "enabled": true
}
```

### Git Configuration

```bash
# Set git user info if not already set
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## ✅ Verification

### Test Installation

```bash
# Test basic functionality
sb --help

# Test interactive mode
sb

# Test command line mode
sb feat test "test installation"
```

### Troubleshooting

**Command not found:**

```bash
# Check if alias is set
which sb
alias | grep sb

# Re-run setup if needed
source ~/.bashrc  # or appropriate shell config
```

**Permission denied:**

```bash
# Fix permissions (Linux/macOS)
chmod +x src/smart-branch.sh
chmod +x sb
```

**PowerShell execution policy (Windows):**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🔄 Updates

### Git-based Installation

```bash
cd /path/to/smart-branch
git pull origin main

# Re-run setup if needed
./src/setup-linux.sh
```

### Manual Update

1. Download latest release
2. Replace existing files
3. Re-run setup process

## 🗑️ Uninstallation

### Remove Alias

```bash
# Edit shell config
nano ~/.bashrc  # or ~/.zshrc

# Remove line:
# alias sb="/path/to/smart-branch/sb"

# Reload shell
source ~/.bashrc
```

### Remove Files

```bash
rm -rf /path/to/smart-branch
```

### Windows PowerShell

```powershell
# Edit PowerShell profile
notepad $PROFILE

# Remove smart_branch function và alias
# Delete smart-branch folder
```

## 🆘 Getting Help

Nếu gặp vấn đề trong quá trình cài đặt:

1. Check [Troubleshooting Guide](TROUBLESHOOTING.md)
2. Search [existing issues](https://github.com/LuuKhoaHoc/smart-branch/issues)
3. Create [new issue](https://github.com/LuuKhoaHoc/smart-branch/issues/new)

## 📚 Next Steps

- Read [Usage Guide](USAGE.md)
- Explore [Examples](../examples/)
- Configure [AI Integration](AI_SETUP.md)
