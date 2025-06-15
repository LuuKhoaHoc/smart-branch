---
name: 🐛 Bug Report
about: Báo cáo bug để giúp chúng tôi cải thiện Smart Branch
title: "[BUG] "
labels: ["bug", "needs-triage"]
assignees: ""
---

## 🐛 Mô tả Bug

Mô tả rõ ràng và ngắn gọn về bug đã gặp phải.

## 🔄 Steps to Reproduce

Các bước để reproduce bug:

1. Chạy command `sb ...`
2. Chọn option '...'
3. Nhập '...'
4. Xem lỗi

## ✅ Expected Behavior

Mô tả những gì bạn mong đợi sẽ xảy ra.

## ❌ Actual Behavior

Mô tả những gì thực sự đã xảy ra.

## 🖥️ Environment

**Operating System:**

- [ ] Windows 10/11
- [ ] macOS (version: )
- [ ] Linux (distro và version: )

**Shell:**

- [ ] PowerShell (version: )
- [ ] Bash (version: )
- [ ] Zsh (version: )
- [ ] Fish (version: )

**Git Version:**

```
git --version
```

**Smart Branch Version:**

```bash
# Nếu có version command
sb --version
```

## 📋 Configuration

**AI Configuration:**

- [ ] AI enabled
- [ ] AI disabled
- [ ] API key configured
- [ ] Using traditional mode only

**Config.json content (xóa API key):**

```json
{
  "ai_provider": "...",
  "api_key": "[REDACTED]",
  "model": "...",
  "enabled": true/false
}
```

## 📊 Output/Logs

**Terminal Output:**

```bash
# Paste terminal output ở đây
```

**Error Messages:**

```
# Paste error messages ở đây
```

## 📸 Screenshots

Nếu applicable, thêm screenshots để giúp explain problem.

## 🔍 Additional Context

Thêm bất kỳ context nào khác về problem ở đây.

**Workarounds (nếu có):**

- Mô tả các cách để bypass bug tạm thời

**Related Issues:**

- Link đến các issues liên quan

## ✅ Checklist

- [ ] Tôi đã search existing issues để đảm bảo đây không phải duplicate
- [ ] Tôi đã test với latest version của Smart Branch
- [ ] Tôi đã thử restart terminal/shell
- [ ] Tôi đã check Git configuration (`git config user.name`)
- [ ] Tôi đã cung cấp tất cả thông tin cần thiết ở trên
