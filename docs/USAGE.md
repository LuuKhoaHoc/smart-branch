# Usage Guide 📖

Hướng dẫn chi tiết cách sử dụng Smart Branch để tạo Git branches một cách hiệu quả.

## 🎯 Basic Usage

### Command duy nhất cần nhớ:

```bash
sb
```

## 🎪 Command Formats

Smart Branch hỗ trợ nhiều formats linh hoạt:

```bash
# Interactive mode - menu selection
sb

# Command line với ticket number
sb feat 123 "implement user authentication"
sb bug 456 "fix login redirect issue"

# Command line không ticket number
sb feat "add new dashboard feature"
sb refactor "optimize database queries"

# Help
sb --help        # Linux/macOS
sb -Help         # Windows
```

## 🎮 Interactive Mode

### Menu Selection

Khi chạy `sb` không có arguments, bạn sẽ thấy menu:

```
🚀 === Smart Branch Creator ===

Chọn mode:
  [1] 🤖 AI Mode - Smart suggestions với Google Gemini
  [2] ⚡ Traditional Mode - Classic naming
  [3] ❌ Thoát

Lựa chọn (1-3):
```

### Input Flow

1. **Chọn Mode** (AI hoặc Traditional)
2. **Nhập Prefix** (feat, bug, hotfix, etc.)
3. **Nhập Ticket Number** (optional)
4. **Nhập Description** (required)
5. **Chọn Branch Name** (từ AI suggestions hoặc traditional)
6. **Confirm Creation**

### Example Interactive Session

```
📝 Nhập thông tin nhánh:
Prefix (feat/bug/hotfix/sync/refactor/docs/test/chore): feat
Ticket number (optional, nhấn Enter để skip): 123
Mô tả chi tiết task: implement user login system

🤖 Đang gọi AI để tạo gợi ý...

🎯 Chọn tên nhánh:
  [1] feat/username-123_implement-user-login
  [2] feat/username-123_add-auth-system
  [3] feat/username-123_create-login-feature
  [4] feat/username-123_implement-user-login-system (truyền thống)
  [5] Nhập tên nhánh khác

Lựa chọn (1-5): 1

🎯 Tên nhánh được chọn: feat/username-123_implement-user-login

✅ Xác nhận tạo nhánh? (y/N): y

🔄 Đang tạo nhánh...
✅ Đã tạo và chuyển sang nhánh 'feat/username-123_implement-user-login' thành công!
```

## ⚡ Command Line Mode

### Format Detection

Smart Branch tự động detect format based on arguments:

```bash
# 3 arguments = prefix + ticket + description
sb feat 123 "implement feature"

# 2 arguments = prefix + description (no ticket)
sb feat "implement feature"

# Invalid - sẽ hiển thị error và usage
sb feat
```

### Prefix Options

| Prefix     | Description         | Example Use Case                              |
| ---------- | ------------------- | --------------------------------------------- |
| `feat`     | New features        | `sb feat 123 "add user profile"`              |
| `bug`      | Bug fixes           | `sb bug 456 "fix validation error"`           |
| `hotfix`   | Urgent fixes        | `sb hotfix 789 "fix critical security issue"` |
| `refactor` | Code refactoring    | `sb refactor "optimize query performance"`    |
| `docs`     | Documentation       | `sb docs "update API documentation"`          |
| `test`     | Adding tests        | `sb test "add unit tests for auth"`           |
| `chore`    | Maintenance tasks   | `sb chore "update dependencies"`              |
| `sync`     | Sync/merge branches | `sb sync "merge latest from main"`            |

## 🤖 AI Mode Features

### Google Gemini Integration

AI Mode sử dụng Google Gemini để:

- Phân tích description
- Tạo 3 gợi ý tên nhánh khác nhau
- Optimize cho readability và convention

### AI vs Traditional Comparison

**AI Mode output:**

```bash
sb feat 123 "implement user authentication with OAuth2"

# AI suggestions:
[1] feat/username-123_implement-oauth2-auth
[2] feat/username-123_add-user-authentication
[3] feat/username-123_create-oauth2-login
[4] feat/username-123_implement-user-authentication-with-oauth2 (truyền thống)
```

**Traditional Mode output:**

```bash
sb feat 123 "implement user authentication with OAuth2"

# Traditional result:
feat/username-123_implement-user-authentication-with-oauth2
```

### AI Fallback

AI Mode tự động fallback về Traditional Mode khi:

- API key không được cấu hình
- Network connection fail
- API limit reached
- Invalid API response

## 🎨 Branch Naming Convention

### With Ticket Number

```
{prefix}/{username}-{ticket_number}_{description}
```

**Examples:**

- `feat/khoahoc-123_implement-user-auth`
- `bug/alice-456_fix-login-redirect`
- `hotfix/bob-789_patch-security-issue`

### Without Ticket Number

```
{prefix}/{username}_{description}
```

**Examples:**

- `feat/khoahoc_add-new-dashboard`
- `refactor/alice_optimize-database`
- `docs/bob_update-readme`

### Username Processing

Username được lấy từ `git config user.name` và processed:

- Convert to lowercase
- Remove spaces
- Keep alphanumeric characters only

```bash
# Git config: "Khoa Hoc Nguyen"
# Processed: "khoahocnguyen"

# Git config: "john.doe"
# Processed: "johndoe"
```

## 📋 Advanced Usage

### Environment Variables

```bash
# Disable AI temporarily
SMART_BRANCH_AI=false sb feat 123 "feature"

# Custom config file
SMART_BRANCH_CONFIG=/path/to/config.json sb
```

### Batch Operations

```bash
# Create multiple branches quickly
sb feat 101 "implement login"
sb feat 102 "implement logout"
sb test 103 "add auth tests"
```

### Team Workflows

**Feature Development:**

```bash
# Developer A
sb feat 123 "implement user service"

# Developer B
sb feat 124 "implement user controller"

# Integration
sb feat 125 "integrate user components"
```

**Bug Fixing:**

```bash
# Initial fix
sb bug 456 "fix validation error"

# Additional fixes
sb bug 456 "add validation tests"
sb bug 456 "update error messages"
```

## 🔧 Configuration Options

### Config.json Structure

```json
{
  "ai_provider": "gemini",
  "api_key": "your-api-key",
  "model": "gemini-2.0-flash-exp",
  "endpoint": "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent",
  "max_tokens": 150,
  "temperature": 0.7,
  "enabled": true
}
```

### Configuration Options

| Option        | Description             | Default                  |
| ------------- | ----------------------- | ------------------------ |
| `ai_provider` | AI provider name        | `"gemini"`               |
| `api_key`     | API key for AI service  | `""`                     |
| `model`       | AI model to use         | `"gemini-2.0-flash-exp"` |
| `max_tokens`  | Max tokens per request  | `150`                    |
| `temperature` | AI creativity (0.0-1.0) | `0.7`                    |
| `enabled`     | Enable AI features      | `true`                   |

### Disable AI Features

```json
{
  "enabled": false
}
```

## 🎯 Best Practices

### Branch Naming

✅ **Good:**

```bash
sb feat 123 "implement user authentication"
sb bug 456 "fix email validation"
sb docs "update installation guide"
```

❌ **Avoid:**

```bash
sb feat 123 "fix stuff"  # Too vague
sb feat 123 "implement the entire user management system with authentication, authorization, profile management, and admin controls"  # Too long
```

### Ticket Management

**One Branch = One Ticket = One Feature:**

```bash
# Good - focused scope
sb feat 123 "add user login form"
sb feat 124 "add user registration form"

# Avoid - mixed concerns
sb feat 123 "add user login and registration and profile management"
```

### Description Guidelines

**Be Specific:**

- `"implement user authentication"` ✅
- `"add login feature"` ✅
- `"fix stuff"` ❌
- `"do work"` ❌

**Use Action Verbs:**

- `"implement"`, `"add"`, `"fix"`, `"update"`, `"remove"`
- `"optimize"`, `"refactor"`, `"enhance"`

## 🐛 Troubleshooting

### Common Issues

**Command not found:**

```bash
# Check alias
which sb
alias | grep sb

# Reload shell config
source ~/.bashrc
```

**Git username not configured:**

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**AI not working:**

```bash
# Check config
cat config.json

# Test API key manually
curl -H "Content-Type: application/json" \
     -d '{"contents":[{"parts":[{"text":"test"}]}]}' \
     "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=YOUR_API_KEY"
```

**Branch already exists:**

```bash
# Delete existing branch
git branch -D existing-branch-name

# Or use different description
sb feat 123 "implement user auth v2"
```

## 📚 Examples

Xem thêm examples trong [examples directory](../examples/):

- [demo.sh](../examples/demo.sh) - Interactive demo
- [Basic usage examples](../examples/BASIC_EXAMPLES.md)
- [Advanced workflows](../examples/ADVANCED_WORKFLOWS.md)

## 🆘 Getting Help

```bash
# Built-in help
sb --help

# Version info (if available)
sb --version

# Community support
# - GitHub Issues: https://github.com/LuuKhoaHoc/smart-branch/issues
# - Discussions: https://github.com/LuuKhoaHoc/smart-branch/discussions
```
