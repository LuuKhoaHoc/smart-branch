# Smart Branch

> **Ghi chú / Note:**
> Dự án này hỗ trợ đa ngôn ngữ (Tiếng Việt & Tiếng Anh). Xem hướng dẫn dịch thuật tại [`docs/TRANSLATION.md`](docs/TRANSLATION.md).
> This project supports multiple languages (Vietnamese & English). See translation guide in [`docs/TRANSLATION.md`](docs/TRANSLATION.md).

## Overview

Smart Branch là một công cụ dòng lệnh giúp tự động hóa việc tạo và quản lý nhánh Git theo chuẩn đặt tên thông minh, hỗ trợ đa ngôn ngữ và dễ dàng mở rộng.

Smart Branch is a CLI tool for automating the creation and management of Git branches with smart naming conventions, multilingual support, and easy extensibility.

## Features

- Tạo nhánh Git nhanh chóng với tên chuẩn hóa.
- Hỗ trợ đa ngôn ngữ: Tiếng Việt & Tiếng Anh (xem thư mục [`lang/`](lang/)).
- Dễ dàng mở rộng và tùy chỉnh.
- Tài liệu chi tiết cho cài đặt, sử dụng và dịch thuật.

## Project Structure

```
.
├── config/                # Cấu hình mẫu cho dự án (project config templates)
│   └── config.json.template
├── docs/                  # Tài liệu chi tiết (detailed documentation)
│   ├── INSTALLATION.md
│   ├── USAGE.md
│   └── TRANSLATION.md
├── examples/              # Ví dụ sử dụng (usage examples)
│   ├── BASIC_EXAMPLES.md
│   └── demo.sh
├── lang/                  # Tập lệnh ngôn ngữ (language scripts)
│   ├── en.sh
│   └── vi.sh
├── src/                   # Mã nguồn chính (main source code)
│   ├── quick-branch.bat
│   ├── sb
│   ├── smart-branch.ps1
│   ├── smart-branch.sh
│   └── lang/
│       ├── en.sh
│       └── vi.sh
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── SETUP_GITHUB.md
├── deploy.sh
├── install.sh
└── .gitignore
```

## Installation

Xem hướng dẫn cài đặt chi tiết tại [`docs/INSTALLATION.md`](docs/INSTALLATION.md).

See detailed installation instructions in [`docs/INSTALLATION.md`](docs/INSTALLATION.md).

## Usage

Xem hướng dẫn sử dụng chi tiết tại [`docs/USAGE.md`](docs/USAGE.md).

See detailed usage instructions in [`docs/USAGE.md`](docs/USAGE.md).

## Multilingual Support

- Dự án hỗ trợ Tiếng Việt và Tiếng Anh thông qua các tập lệnh trong thư mục [`lang/`](lang/).
- Hướng dẫn dịch thuật và đóng góp ngôn ngữ mới: [`docs/TRANSLATION.md`](docs/TRANSLATION.md).

The project supports Vietnamese and English via scripts in [`lang/`](lang/).
See [`docs/TRANSLATION.md`](docs/TRANSLATION.md) for translation and language contribution guidelines.

## Contributing

Đóng góp vui lòng xem [`CONTRIBUTING.md`](CONTRIBUTING.md).

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for contribution guidelines.

## License

This project is licensed under the terms of the [MIT License](LICENSE).
