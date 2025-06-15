# Basic Examples 📋

Tập hợp các ví dụ cơ bản để giúp bạn bắt đầu với Smart Branch.

## 🚀 Getting Started Examples

### Interactive Mode

```bash
# Start interactive mode
sb

# You'll see this menu:
🚀 === Smart Branch Creator ===

Chọn mode:
  [1] 🤖 AI Mode - Smart suggestions với Google Gemini
  [2] ⚡ Traditional Mode - Classic naming
  [3] ❌ Thoát

Lựa chọn (1-3): 1

📝 Nhập thông tin nhánh:
Prefix (feat/bug/hotfix/sync/refactor/docs/test/chore): feat
Ticket number (optional, nhấn Enter để skip): 123
Mô tả chi tiết task: implement user login feature

# AI will provide suggestions...
```

## 💻 Command Line Examples

### Feature Development

```bash
# New features với ticket numbers
sb feat 123 "implement user authentication"
# → feat/username-123_implement-user-auth

sb feat 124 "add user profile management"
# → feat/username-124_add-user-profile-mgmt

sb feat 125 "implement dashboard analytics"
# → feat/username-125_implement-dashboard-analytics
```

### Bug Fixes

```bash
# Bug fixes
sb bug 456 "fix login redirect issue"
# → bug/username-456_fix-login-redirect-issue

sb bug 457 "resolve email validation error"
# → bug/username-457_resolve-email-validation-error

sb bug 458 "fix responsive layout on mobile"
# → bug/username-458_fix-responsive-layout-mobile
```

### Without Ticket Numbers

```bash
# Features without tickets
sb feat "add dark mode support"
# → feat/username_add-dark-mode-support

sb feat "implement search functionality"
# → feat/username_implement-search-functionality

sb feat "add export to PDF feature"
# → feat/username_add-export-pdf-feature
```

## 🔧 Maintenance Examples

### Refactoring

```bash
sb refactor "optimize database queries"
# → refactor/username_optimize-database-queries

sb refactor "extract user service layer"
# → refactor/username_extract-user-service-layer

sb refactor "improve error handling"
# → refactor/username_improve-error-handling
```

### Documentation

```bash
sb docs "update API documentation"
# → docs/username_update-api-documentation

sb docs "add installation guide"
# → docs/username_add-installation-guide

sb docs "create troubleshooting section"
# → docs/username_create-troubleshooting-section
```

### Testing

```bash
sb test "add unit tests for auth module"
# → test/username_add-unit-tests-auth-module

sb test "implement integration tests"
# → test/username_implement-integration-tests

sb test "add end-to-end user journey tests"
# → test/username_add-e2e-user-journey-tests
```

## 🚨 Hotfix Examples

```bash
# Critical fixes
sb hotfix 999 "fix security vulnerability"
# → hotfix/username-999_fix-security-vulnerability

sb hotfix 998 "patch database connection leak"
# → hotfix/username-998_patch-db-connection-leak

sb hotfix "fix production payment gateway"
# → hotfix/username_fix-production-payment-gateway
```

## 🔄 Sync Examples

```bash
# Branch synchronization
sb sync "merge latest from develop"
# → sync/username_merge-latest-from-develop

sb sync "update from main branch"
# → sync/username_update-from-main-branch

sb sync 101 "sync feature branch with master"
# → sync/username-101_sync-feature-branch-master
```

## 🎯 Real-world Scenarios

### E-commerce Application

```bash
# Shopping cart features
sb feat 201 "implement add to cart functionality"
sb feat 202 "add cart persistence"
sb feat 203 "implement checkout process"

# Payment integration
sb feat 301 "integrate stripe payment"
sb feat 302 "add paypal support"
sb feat 303 "implement payment validation"

# Bug fixes
sb bug 401 "fix cart total calculation"
sb bug 402 "resolve payment timeout issue"
sb bug 403 "fix inventory update race condition"
```

### Social Media Platform

```bash
# User features
sb feat 501 "implement user registration"
sb feat 502 "add profile photo upload"
sb feat 503 "create user settings page"

# Content features
sb feat 601 "implement post creation"
sb feat 602 "add image posting"
sb feat 603 "create comment system"

# Social features
sb feat 701 "implement follow/unfollow"
sb feat 702 "add notification system"
sb feat 703 "create activity feed"
```

### Enterprise Dashboard

```bash
# Analytics features
sb feat 801 "implement real-time metrics"
sb feat 802 "add custom report builder"
sb feat 803 "create data export functionality"

# Admin features
sb feat 901 "implement user management"
sb feat 902 "add role-based permissions"
sb feat 903 "create audit logging"
```

## 🎨 AI Mode Examples

### AI Suggestions Comparison

**Input:**

```bash
sb feat 123 "implement user authentication with OAuth2 and JWT tokens"
```

**AI Mode Output:**

```
🎯 Chọn tên nhánh:
  [1] feat/username-123_implement-oauth2-jwt-auth
  [2] feat/username-123_add-user-authentication
  [3] feat/username-123_create-oauth2-login-system
  [4] feat/username-123_implement-user-authentication-with-oauth2-and-jwt-tokens (truyền thống)
  [5] Nhập tên nhánh khác
```

**Traditional Mode Output:**

```
feat/username-123_implement-user-authentication-with-oauth2-and-jwt-tokens
```

### Complex Feature Examples

```bash
sb feat 150 "implement advanced search with filters and pagination"

# AI might suggest:
# [1] feat/username-150_implement-advanced-search
# [2] feat/username-150_add-search-with-filters
# [3] feat/username-150_create-paginated-search
```

## 📱 Mobile App Examples

```bash
# iOS/Android features
sb feat 1001 "implement push notifications"
sb feat 1002 "add biometric authentication"
sb feat 1003 "create offline mode support"

# UI/UX improvements
sb feat 1101 "redesign onboarding flow"
sb feat 1102 "improve navigation animation"
sb feat 1103 "add accessibility features"
```

## 🌐 Web Application Examples

```bash
# Frontend features
sb feat 1201 "implement responsive design"
sb feat 1202 "add progressive web app features"
sb feat 1203 "create component library"

# Backend features
sb feat 1301 "implement GraphQL API"
sb feat 1302 "add database optimization"
sb feat 1303 "create microservices architecture"
```

## 🧪 Testing Scenarios

```bash
# Different types of testing
sb test "add unit tests for user service"
sb test "implement API integration tests"
sb test "create visual regression tests"
sb test "add performance benchmarks"
sb test "implement security testing"
```

## 🏢 Team Collaboration Examples

### Feature Team Workflow

```bash
# Team Lead
sb feat 2001 "implement user management system"

# Developer A
sb feat 2002 "create user model and validation"

# Developer B
sb feat 2003 "implement user CRUD operations"

# Developer C
sb feat 2004 "add user authentication endpoints"

# QA Engineer
sb test 2005 "add comprehensive user tests"
```

### Bug Fix Workflow

```bash
# QA finds bug
sb bug 3001 "fix user registration validation"

# Developer fixes
sb bug 3001 "implement email format validation"

# Additional fix needed
sb bug 3001 "add password strength validation"

# Testing
sb test 3001 "add validation tests"
```

## ❌ Common Mistakes to Avoid

### ❌ Too Vague

```bash
# Bad
sb feat 123 "fix stuff"
sb feat 124 "add things"
sb feat 125 "update code"

# Good
sb feat 123 "fix user login validation"
sb feat 124 "add user profile avatar"
sb feat 125 "update API documentation"
```

### ❌ Too Long

```bash
# Bad
sb feat 123 "implement the entire user management system with authentication, authorization, profile management, admin controls, and audit logging"

# Good
sb feat 123 "implement user authentication"
sb feat 124 "add user authorization"
sb feat 125 "create user profile management"
```

### ❌ Mixed Concerns

```bash
# Bad
sb feat 123 "add login and fix bugs and update docs"

# Good
sb feat 123 "implement user login"
sb bug 124 "fix login validation bug"
sb docs 125 "update login documentation"
```

## ✅ Best Practices

### Use Action Verbs

```bash
# Good action verbs
sb feat 123 "implement user authentication"
sb feat 124 "add shopping cart feature"
sb feat 125 "create dashboard component"
sb feat 126 "integrate payment gateway"
sb feat 127 "optimize database queries"
sb feat 128 "refactor user service"
sb feat 129 "enhance error handling"
sb feat 130 "update user interface"
```

### Be Specific

```bash
# Specific descriptions
sb feat 123 "implement OAuth2 authentication"
sb feat 124 "add Redis caching layer"
sb feat 125 "create React user dashboard"
sb feat 126 "integrate Stripe payment API"
```

### Follow Conventions

```bash
# Consistent naming
sb feat 123 "implement user registration"
sb feat 124 "implement user login"
sb feat 125 "implement user logout"
sb feat 126 "implement user password reset"
```

## 🔗 Next Steps

- Explore [Advanced Workflows](ADVANCED_WORKFLOWS.md)
- Read [Usage Guide](../docs/USAGE.md)
- Configure [AI Integration](../docs/AI_SETUP.md)
- Try the [Demo Script](demo.sh)
