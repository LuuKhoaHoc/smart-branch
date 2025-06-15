# Contributing to Smart Branch 🤝

Cảm ơn bạn đã quan tâm đến việc đóng góp cho Smart Branch! Chúng tôi rất hoan nghênh mọi đóng góp từ community.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)

## Code of Conduct

Dự án này tuân thủ [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/). Bằng cách tham gia, bạn đồng ý tuân theo các quy tắc này.

## Getting Started

### Prerequisites

- Git
- Bash 4.0+ (Linux/macOS) hoặc PowerShell 3.0+ (Windows)
- curl và jq (optional, cho AI features)
- Tài khoản GitHub

### Fork và Clone

```bash
# Fork repository trên GitHub
# Clone fork của bạn
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Add upstream remote
git remote add upstream https://github.com/original-owner/smart-branch.git
```

## Development Setup

### Linux/macOS

```bash
# Setup development environment
./src/setup-linux.sh

# Make scripts executable
chmod +x src/*.sh
chmod +x sb

# Test installation
./examples/demo.sh
```

### Windows

```powershell
# Setup PowerShell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Test scripts
.\src\smart-branch.ps1 -Help
```

## How to Contribute

### 🐛 Bug Reports

Nếu bạn tìm thấy bug, hãy tạo issue với:

- **Mô tả chi tiết** về bug
- **Steps to reproduce**
- **Expected vs actual behavior**
- **Environment info** (OS, shell, Git version)
- **Screenshots/logs** nếu có

### ✨ Feature Requests

Để đề xuất tính năng mới:

- **Mô tả rõ ràng** về tính năng
- **Use case** cụ thể
- **Mockups/examples** nếu có
- **Technical considerations**

### 🔧 Code Contributions

1. **Tìm issue** hoặc tạo issue mới
2. **Comment** trên issue để thông báo bạn sẽ làm
3. **Create branch** từ `main`
4. **Implement changes**
5. **Test thoroughly**
6. **Submit Pull Request**

## Coding Standards

### Shell Scripts (Bash)

```bash
#!/bin/bash

# File header với description
# Author và date

# Colors và constants ở đầu file
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Functions với clear documentation
function example_function() {
    local param1=$1
    local param2=$2

    # Implementation
    echo "Result"
}

# Main logic ở cuối file
main() {
    # Implementation
}

main "$@"
```

### PowerShell Scripts

```powershell
# File header với description
# Author và date

param(
    [string]$Parameter1,
    [switch]$Help
)

# Functions với proper error handling
function Get-ExampleData {
    param([string]$Input)

    try {
        # Implementation
        return $result
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
        exit 1
    }
}

# Main logic
function Main {
    # Implementation
}

Main
```

### Style Guidelines

- **Indentation**: 4 spaces (không dùng tabs)
- **Line length**: Max 100 characters
- **Comments**: Tiếng Việt cho user-facing, English cho technical
- **Variables**: Descriptive names, lowercase with underscores (Bash)
- **Functions**: PascalCase (PowerShell), snake_case (Bash)
- **Error handling**: Graceful degradation, informative messages

## Testing

### Manual Testing

```bash
# Test basic functionality
sb feat 123 "test feature"

# Test AI mode (với API key)
sb # chọn AI mode

# Test traditional mode
sb # chọn traditional mode

# Test edge cases
sb invalid_prefix 123 "test"  # should fail
sb feat "" "test"             # should fail
sb feat 123 ""               # should fail
```

### Cross-platform Testing

- **Linux**: Ubuntu, Arch, CentOS
- **macOS**: Latest version
- **Windows**: PowerShell 5.1+, PowerShell 7+
- **Shells**: Bash, Zsh, Fish

### AI Integration Testing

```bash
# Test với valid API key
# Test với invalid API key
# Test khi API unavailable
# Test fallback mechanism
```

## Pull Request Process

### Pre-submission Checklist

- [ ] Code tuân thủ style guidelines
- [ ] Đã test trên multiple platforms
- [ ] Documentation được update
- [ ] CHANGELOG.md được update
- [ ] Commit messages descriptive
- [ ] No breaking changes (hoặc documented)

### PR Template

```markdown
## Description

Brief description của changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing

- [ ] Tested on Linux
- [ ] Tested on macOS
- [ ] Tested on Windows
- [ ] AI integration works
- [ ] Manual testing passed

## Screenshots

<!-- Nếu có UI changes -->

## Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings/errors
```

### Review Process

1. **Automated checks** sẽ run
2. **Maintainer review** code và test
3. **Address feedback** nếu có
4. **Approved và merged**

## Issue Guidelines

### Bug Report Template

```markdown
**Describe the bug**
A clear description of the bug

**To Reproduce**
Steps to reproduce:

1. Go to '...'
2. Click on '....'
3. See error

**Expected behavior**
What you expected to happen

**Environment:**

- OS: [e.g. Ubuntu 20.04]
- Shell: [e.g. Bash 5.0]
- Git version: [e.g. 2.25.0]

**Additional context**
Any other context about the problem
```

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of the problem

**Describe the solution you'd like**
A clear description of what you want to happen

**Describe alternatives you've considered**
Any alternative solutions or features you've considered

**Additional context**
Any other context or screenshots about the feature request
```

## Development Workflow

### Branch Naming

```bash
# Feature branches
feat/feature-name
feat/123-add-new-mode

# Bug fixes
bug/fix-description
bug/456-fix-ai-fallback

# Documentation
docs/update-readme
docs/add-examples
```

### Commit Messages

```bash
# Format: type(scope): description

feat(ai): add support for multiple AI providers
fix(setup): resolve permission issues on macOS
docs(readme): update installation instructions
refactor(core): improve error handling
test(ai): add integration tests for Gemini API
```

### Release Process

1. Update version numbers
2. Update CHANGELOG.md
3. Create release branch
4. Final testing
5. Create GitHub release
6. Merge to main

## Getting Help

- **Discord**: [Link to Discord]
- **GitHub Discussions**: [Link to Discussions]
- **Email**: maintainer@example.com

## Recognition

Contributors sẽ được recognition trong:

- README.md contributors section
- CHANGELOG.md
- GitHub releases notes

Cảm ơn bạn đã đóng góp cho Smart Branch! 🎉
