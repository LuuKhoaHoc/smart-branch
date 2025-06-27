# 📦 Installation Guide

This guide describes how to install `smart-branch` using the automated installation script.

## 📋 System Requirements

- **Required:**
  - `git`: To download the project's source code.
- **Optional (The script will automatically install if missing):**
  - `curl`: To communicate with APIs.
  - `jq`: To process JSON data from APIs.

## 🚀 Quick Install

The installation process is handled by a single script, which automates most of the steps.

### Step 1: Download the Source Code

Open your terminal and run the following command to clone the project repository:

```bash
git clone https://github.com/LuuKhoaHoc/smart-branch.git
cd smart-branch
```

### Step 2: Run the Installation Script

Execute the `install.sh` script to start the automated installation process:

```bash
bash install.sh
```

#### What does the script do?

- **Select language:** Asks whether you want to use the Vietnamese or English interface.
- **Check and install dependencies:** Automatically checks for and installs `curl` and `jq` if they are not already on your system.
- **Configure AI:**
  - Creates a `config.json` file from the template.
  - Asks for your Google Gemini `API Key` to configure the AI feature. You can skip this step and configure it later.

### Step 3: Configure Alias (Manual)

The installation script does not automatically create an alias. You need to add the `sb` alias to your shell configuration file to conveniently call `smart-branch` from anywhere.

#### Linux & macOS

1.  Open your shell's configuration file (e.g., `~/.bashrc`, `~/.zshrc`):

    ```bash
    # For Bash
    nano ~/.bashrc

    # For Zsh
    nano ~/.zshrc
    ```

2.  Add the following line to the end of the file, replacing `/path/to/smart-branch` with the absolute path to the `smart-branch` directory you just cloned:

    ```bash
    alias sb='/path/to/smart-branch/sb'
    ```

    _Tip: You can get the absolute path by running the `pwd` command inside the `smart-branch` directory._

3.  Reload the shell configuration:

    ```bash
    # For Bash
    source ~/.bashrc

    # For Zsh
    source ~/.zshrc
    ```

#### Windows (Using Git Bash or WSL)

On Windows, it is recommended to use Git Bash or Windows Subsystem for Linux (WSL). The installation process is similar to Linux.

1.  Open Git Bash or a WSL terminal.
2.  Follow **Step 1** and **Step 2**.
3.  Configure the alias for Bash as instructed above (`~/.bashrc`).

## ✅ Verify Installation

After completion, check if `smart-branch` was installed correctly:

```bash
sb --help
```

If you see the help message, the installation was successful!

## 🗑️ Uninstall

1.  Remove the `sb` alias from your shell configuration file (`~/.bashrc` or `~/.zshrc`).
2.  Reload the shell configuration (`source ~/.bashrc` or `source ~/.zshrc`).
3.  Delete the project directory: `rm -rf /path/to/smart-branch`.
