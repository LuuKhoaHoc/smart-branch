# 🚀 Setup GitHub Repository - Smart Branch

Hướng dẫn chi tiết để setup repository Smart Branch trên GitHub và deploy code.

## 📋 Prerequisites

- Git đã được cài đặt ✅
- GitHub account
- Repository local đã được initialize ✅
- Initial commit đã completed ✅

## 🔧 Bước 1: Tạo Repository trên GitHub

1. **Truy cập GitHub:**

   - Đi tới [GitHub.com](https://github.com)
   - Đăng nhập vào account của bạn

2. **Tạo New Repository:**

   - Click nút **"New"** hoặc **"+"** → **"New repository"**
   - Repository name: `smart-branch`
   - Description: `🤖 AI-powered Git branch creation tool with smart naming conventions`
   - Chọn **Public** (recommended cho open source project)
   - **KHÔNG** check "Add a README file" (vì đã có local)
   - **KHÔNG** check "Add .gitignore" (vì đã có local)
   - **KHÔNG** check "Choose a license" (vì đã có LICENSE file)

3. **Click "Create repository"**

## 🌐 Bước 2: Setup Remote Origin

Sau khi tạo repository trên GitHub, copy URL của repository và chạy commands sau:

```bash
# Add remote origin (thay LuuKhoaHoc bằng GitHub username thật)
git remote add origin https://github.com/LuuKhoaHoc/smart-branch.git

# Verify remote
git remote -v

# Set upstream và push
git branch -M main
git push -u origin main
```

**Hoặc sử dụng SSH (recommended):**

```bash
# Add remote origin với SSH
git remote add origin git@github.com:LuuKhoaHoc/smart-branch.git

# Push với SSH
git branch -M main
git push -u origin main
```

## 📦 Bước 3: Tạo First Release

1. **Trên GitHub repository:**

   - Vào tab **"Releases"**
   - Click **"Create a new release"**

2. **Release details:**

   - Tag version: `v1.0.0`
   - Release title: `Smart Branch v1.0.0 - Initial Release`
   - Description:

   ```markdown
   🎉 **Smart Branch v1.0.0 - Initial Release**

   AI-powered Git branch creation tool với smart naming conventions.

   ## 🚀 Features

   - AI-powered branch name generation
   - Smart branch naming conventions
   - Multi-platform support (Windows, Linux, macOS)
   - Easy installation and setup
   - Comprehensive documentation

   ## 📥 Installation

   Xem [INSTALLATION.md](docs/INSTALLATION.md) để biết chi tiết.

   ## 🔧 Usage

   Xem [USAGE.md](docs/USAGE.md) và [examples](examples/) để học cách sử dụng.
   ```

3. **Click "Publish release"**

## ⚙️ Bước 4: Enable GitHub Features

### 4.1 Issues

- Vào **Settings** → **General** → **Features**
- Ensure **Issues** is enabled ✅
- Issues templates đã được setup trong `.github/ISSUE_TEMPLATE/`

### 4.2 Discussions (Optional)

- Enable **Discussions** cho community support
- Tạo categories: General, Q&A, Feature Requests, Show and Tell

### 4.3 GitHub Pages (Optional)

- Vào **Settings** → **Pages**
- Source: **Deploy from a branch**
- Branch: **main** / **docs**
- Folder: **/ (root)** hoặc **/docs**

### 4.4 Branch Protection

```bash
# Tạo develop branch cho development
git checkout -b develop
git push -u origin develop

# Set main làm default branch và protect
```

## 🔄 Bước 5: Regular Workflow

### Development workflow:

```bash
# Create feature branch
./sb "Add new AI model integration"

# Make changes và commit
git add .
git commit -m "feat: add new AI model integration"

# Push và create PR
git push -u origin feature/add-new-ai-model-integration
```

### Release workflow:

```bash
# Update version trong các files cần thiết
# Update CHANGELOG.md
# Create release commit
git add .
git commit -m "chore: bump version to v1.1.0"

# Create tag và push
git tag v1.1.0
git push origin main
git push origin v1.1.0
```

## 🛠️ Automation Scripts

Sử dụng `deploy.sh` script để automate setup process:

```bash
# Make executable
chmod +x deploy.sh

# Run setup
./deploy.sh YOUR_GITHUB_USERNAME
```

## 📚 Next Steps

1. **Setup CI/CD:** Tạo GitHub Actions cho automated testing
2. **Add badges:** Thêm status badges vào README.md
3. **Setup monitoring:** Configure notifications cho issues/PRs
4. **Community guidelines:** Review và update CONTRIBUTING.md
5. **Documentation:** Expand docs với more examples và tutorials

## 🆘 Troubleshooting

### Authentication Issues:

```bash
# Setup Git credentials
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# For SSH issues
ssh-keygen -t ed25519 -C "your.email@example.com"
# Add public key to GitHub SSH keys
```

### Remote Issues:

```bash
# Remove và re-add remote
git remote remove origin
git remote add origin https://github.com/LuuKhoaHoc/smart-branch.git
```

### Push Issues:

```bash
# Force push nếu cần (cẩn thận!)
git push --force-with-lease origin main
```

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/LuuKhoaHoc/smart-branch/issues)
- **Discussions:** [GitHub Discussions](https://github.com/LuuKhoaHoc/smart-branch/discussions)
- **Documentation:** [docs/](docs/)

---

**Happy coding! 🚀**
