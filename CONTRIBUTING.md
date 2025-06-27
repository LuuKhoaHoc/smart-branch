# Contributing to Smart Branch 🤝

Thank you for your interest in contributing to Smart Branch! We welcome all contributions from the community.

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

This project adheres to the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/). By participating, you agree to follow these rules.

## Getting Started

### Prerequisites

- Git
- Bash 4.0+ (Linux/macOS) or PowerShell 3.0+ (Windows)
- curl and jq (optional, for AI features)
- GitHub Account

### Fork and Clone

```bash
# Fork the repository on GitHub
# Clone your fork
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch

# Add upstream remote
git remote add upstream https://github.com/original-owner/smart-branch.git
```

## Development Setup

### Linux/macOS

```bash
# Setup development environment
./install.sh

# Make scripts executable
chmod +x /*.sh
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

If you find a bug, please create an issue with:

- **Detailed description** of the bug
- **Steps to reproduce**
- **Expected vs actual behavior**
- **Environment info** (OS, shell, Git version)
- **Screenshots/logs** if available

### ✨ Feature Requests

To propose a new feature:

- **Clear description** of the feature
- **Specific use case**
- **Mockups/examples** if available
- **Technical considerations**

### 🔧 Code Contributions

1.  **Find an issue** or create a new one
2.  **Comment** on the issue to announce you will work on it
3.  **Create a branch** from `main`
4.  **Implement changes**
5.  **Test thoroughly**
6.  **Submit a Pull Request**

## Coding Standards

### Shell Scripts (Bash)

```bash
#!/bin/bash

# File header with description
# Author and date

# Colors and constants at the top of the file
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Functions with clear documentation
function example_function() {
    local param1=$1
    local param2=$2

    # Implementation
    echo "Result"
}

# Main logic at the end of the file
main() {
    # Implementation
}

main "$@"
```

### PowerShell Scripts

```powershell
# File header with description
# Author and date

param(
    [string]$Parameter1,
    [switch]$Help
)

# Functions with proper error handling
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

- **Indentation**: 4 spaces (no tabs)
- **Line length**: Max 100 characters
- **Comments**: Vietnamese for user-facing, English for technical
- **Variables**: Descriptive names, lowercase with underscores (Bash)
- **Functions**: PascalCase (PowerShell), snake_case (Bash)
- **Error handling**: Graceful degradation, informative messages

## Testing

### Manual Testing

```bash
# Test basic functionality
sb feat 123 "test feature"

# Test AI mode (with API key)
sb # select AI mode

# Test traditional mode
sb # select traditional mode

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
# Test with valid API key
# Test with invalid API key
# Test when API unavailable
# Test fallback mechanism
```

## Pull Request Process

### Pre-submission Checklist

- [ ] Code adheres to style guidelines
- [ ] Tested on multiple platforms
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated
- [ ] Commit messages are descriptive
- [ ] No breaking changes (or documented)

### PR Template

```markdown
## Description

Brief description of changes

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

<!-- If there are UI changes -->

## Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings/errors
```

### Review Process

1.  **Automated checks** will run
2.  **Maintainer reviews** code and tests
3.  **Address feedback** if any
4.  **Approved and merged**

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

1.  Update version numbers
2.  Update CHANGELOG.md
3.  Create release branch
4.  Final testing
5.  Create GitHub release
6.  Merge to main

## Getting Help

- **Discord**: [Link to Discord]
- **GitHub Discussions**: [Link to Discussions]
- **Email**: maintainer@example.com

## Recognition

Contributors will be recognized in:

- README.md contributors section
- CHANGELOG.md
- GitHub releases notes

Thank you for contributing to Smart Branch! 🎉
