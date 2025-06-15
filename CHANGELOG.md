# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Initial repository structure
- Professional GitHub repository setup
- Comprehensive documentation

### Changed

- N/A

### Deprecated

- N/A

### Removed

- N/A

### Fixed

- N/A

### Security

- N/A

## [1.0.0] - 2025-06-15

### Added

- ✨ **Smart Branch Creator** - Unified Git branch creation tool
- 🤖 **AI Mode** - Smart suggestions với Google Gemini API
- ⚡ **Traditional Mode** - Classic naming convention
- 🌐 **Cross-platform support** - Windows, Linux, macOS
- 📋 **Interactive mode** - User-friendly menu selection
- 🔤 **Command-line mode** - Direct arguments support
- 🎯 **Optional ticket numbers** - Flexible workflow support
- 🐚 **Multi-shell support** - Bash, Zsh, Fish, PowerShell

### Core Scripts

- `src/smart-branch.sh` - Linux/macOS implementation
- `src/smart-branch.ps1` - Windows PowerShell implementation
- `src/setup-linux.sh` - Automated Linux setup
- `src/quick-branch.bat` - Windows quick branch tool
- `sb` - Universal cross-platform launcher

### Features

- **Branch naming convention**: `prefix/{username}-{ticket}_{description}`
- **Supported prefixes**: feat, bug, hotfix, sync, refactor, docs, test, chore
- **AI integration**: Google Gemini 2.0 Flash API
- **Auto-detect format**: Intelligent parameter parsing
- **Error handling**: Graceful degradation and fallbacks
- **Validation**: Git config, branch existence, prefix validation

### Configuration

- `config/config.json.template` - AI configuration template
- Environment detection and dependency checking
- Automatic config file generation

### Documentation

- Comprehensive README.md with badges and examples
- CONTRIBUTING.md with development guidelines
- MIT License
- GitHub issue templates
- Professional project structure

---

## Version History Notes

### Versioning Strategy

- **Major version** (x.0.0): Breaking changes, major features
- **Minor version** (x.y.0): New features, backwards compatible
- **Patch version** (x.y.z): Bug fixes, minor improvements

### Release Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security improvements

### Future Roadmap

- [ ] GitHub Actions CI/CD
- [ ] Docker support
- [ ] Additional AI providers (OpenAI, Claude)
- [ ] Git hooks integration
- [ ] Branch templates
- [ ] Team workflows
- [ ] IDE extensions

---

[Unreleased]: https://github.com/LuuKhoaHoc/smart-branch/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/LuuKhoaHoc/smart-branch/releases/tag/v1.0.0
