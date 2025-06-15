#!/bin/bash

# 🚀 Smart Branch - GitHub Deploy Script
# Automate GitHub repository setup process

set -e  # Exit on any error

# Cleanup function
cleanup() {
    if [ $? -ne 0 ]; then
        print_error "Script interrupted or failed!"
        print_info "You may need to clean up manually:"
        echo "- Check git remote: git remote -v"
        echo "- Check git status: git status"
        echo "- Reset if needed: git reset --hard HEAD"
    fi
}

# Set trap for cleanup
trap cleanup EXIT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emoji
ROCKET="🚀"
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
INFO="ℹ️"

print_header() {
    echo -e "${PURPLE}"
    echo "=================================================="
    echo "           🤖 Smart Branch Deploy Script"
    echo "           GitHub Repository Setup"
    echo "=================================================="
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}${ROCKET} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

print_info() {
    echo -e "${CYAN}${INFO} $1${NC}"
}

# Check if username is provided
if [ $# -eq 0 ]; then
    print_error "GitHub username is required!"
    echo "Usage: $0 <github_username>"
    echo "Example: $0 johndoe"
    exit 1
fi

GITHUB_USERNAME=$1
REPO_NAME="smart-branch"
REPO_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
SSH_URL="git@github.com:${GITHUB_USERNAME}/${REPO_NAME}.git"

print_header

# Step 0: Verify we're in the right directory
print_step "Step 0: Verifying project structure..."
if [ ! -f "README.md" ] || [ ! -d "src" ] || [ ! -f "sb" ]; then
    print_error "This doesn't appear to be the smart-branch project directory!"
    print_info "Please run this script from the smart-branch root directory."
    print_info "Expected files: README.md, src/, sb"
    exit 1
fi
print_success "Project structure verified"

# Step 1: Verify Git repository
print_step "Step 1: Verifying Git repository..."
if [ ! -d ".git" ] && [ ! -f ".git" ]; then
    print_error "Not a Git repository! Please run 'git init' first."
    exit 1
fi

# Check if this is a submodule
if [ -f ".git" ]; then
    print_info "Detected Git submodule environment"
    # Read the gitdir path from .git file
    GITDIR=$(cat .git | sed 's/gitdir: //')
    if [ ! -d "$GITDIR" ]; then
        print_error "Invalid Git submodule configuration!"
        exit 1
    fi
    print_info "Using Git directory: $GITDIR"
else
    print_info "Standard Git repository detected"
fi
print_success "Git repository verified"

# Step 2: Check Git status
print_step "Step 2: Checking repository status..."
if [ -n "$(git status --porcelain)" ]; then
    print_warning "Working directory is not clean. Uncommitted changes found:"
    git status --short
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Aborting deploy. Please commit your changes first."
        exit 1
    fi
fi
print_success "Repository status checked"

# Step 3: Setup remote origin
print_step "Step 3: Setting up remote origin..."

# Check current remote origin
current_origin=""
if git remote get-url origin >/dev/null 2>&1; then
    current_origin=$(git remote get-url origin)
    print_info "Current remote origin: $current_origin"

    # Check if it's already pointing to the correct repository
    if [[ "$current_origin" == *"${GITHUB_USERNAME}/${REPO_NAME}"* ]]; then
        print_success "Remote origin already correctly configured"
        echo -e "${YELLOW}Current setup:${NC}"
        git remote -v
        read -p "Keep current remote configuration? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_info "Removing existing remote origin..."
            git remote remove origin
        else
            print_info "Keeping current remote configuration"
            # Skip to next step
            print_success "Remote origin verified"
            # Jump to branch setup
            print_step "Step 4: Verifying remote configuration..."
            git remote -v
            print_success "Remote verification complete"

            print_step "Step 5: Setting up main branch..."
            current_branch=$(git branch --show-current)
            if [ "$current_branch" != "main" ]; then
                git branch -M main
                print_success "Switched to main branch"
            else
                print_success "Already on main branch"
            fi

            # Skip to final steps
            print_step "Step 6: Repository setup verified!"
            print_info "Submodule is properly configured with remote origin"
            print_success "Deploy script completed - repository already setup!"
            echo ""
            echo -e "${GREEN}${CHECK} Repository URL: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}${NC}"
            echo -e "${PURPLE}${ROCKET} Submodule is ready to use! ${ROCKET}${NC}"
            exit 0
        fi
    else
        print_warning "Remote origin points to different repository: $current_origin"
        read -p "Replace with new repository URL? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Removing existing remote origin..."
            git remote remove origin
        else
            print_info "Keeping existing remote origin, aborting setup"
            exit 1
        fi
    fi
fi

# Ask user for authentication method
echo -e "${YELLOW}Choose authentication method:${NC}"
echo "1) HTTPS (easier setup)"
echo "2) SSH (more secure, recommended)"
read -p "Enter choice (1 or 2): " auth_choice

case $auth_choice in
    1)
        print_info "Using HTTPS authentication..."
        git remote add origin "$REPO_URL"
        ;;
    2)
        print_info "Using SSH authentication..."
        # Check if SSH key exists
        if [ ! -f ~/.ssh/id_ed25519 ] && [ ! -f ~/.ssh/id_rsa ]; then
            print_warning "No SSH key found. Generating new SSH key..."
            read -p "Enter your email for SSH key: " user_email
            ssh-keygen -t ed25519 -C "$user_email" -f ~/.ssh/id_ed25519 -N ""
            print_info "SSH key generated. Please add the following public key to GitHub:"
            echo -e "${GREEN}$(cat ~/.ssh/id_ed25519.pub)${NC}"
            print_info "Go to: https://github.com/settings/ssh/new"
            read -p "Press Enter after adding SSH key to GitHub..."
        fi
        git remote add origin "$SSH_URL"
        ;;
    *)
        print_error "Invalid choice. Using HTTPS as default..."
        git remote add origin "$REPO_URL"
        ;;
esac

print_success "Remote origin configured"

# Step 4: Verify remote
print_step "Step 4: Verifying remote configuration..."
git remote -v
print_success "Remote verification complete"

# Step 5: Setup main branch
print_step "Step 5: Setting up main branch..."
git branch -M main
print_success "Main branch configured"

# Step 6: Push to GitHub
print_step "Step 6: Pushing to GitHub..."

# Check if this is a submodule and warn user
if [ -f ".git" ]; then
    print_warning "This is a Git submodule!"
    print_info "Pushing changes here will update the submodule repository."
    print_info "You may also need to update the parent repository to point to new commits."
    echo ""
fi

echo -e "${YELLOW}This will push your code to GitHub. Continue? (y/N):${NC}"
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Attempting to push to GitHub..."
    if git push -u origin main; then
        print_success "Successfully pushed to GitHub!"

        # Additional submodule guidance
        if [ -f ".git" ]; then
            echo ""
            print_info "Submodule push completed. Next steps:"
            echo "1. Update parent repository to reference new commits"
            echo "2. In parent repo, run: git add smart-branch && git commit -m 'update smart-branch submodule'"
            echo "3. Push parent repository changes"
        fi
    else
        print_error "Failed to push to GitHub. Please check:"
        echo "1. Repository exists on GitHub"
        echo "2. You have push permissions"
        echo "3. Authentication is properly configured"

        if [ -f ".git" ]; then
            echo "4. Submodule configuration is correct"
        fi

        echo ""
        print_info "You can manually push later with: git push -u origin main"
        read -p "Continue with script anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Aborting script. Fix the issues above and try again."
            exit 1
        fi
    fi
else
    print_info "Skipping push to GitHub"
fi

# Step 7: Create develop branch
print_step "Step 7: Creating develop branch..."
if git show-ref --verify --quiet refs/heads/develop; then
    print_info "Develop branch already exists, skipping creation..."
else
    if git checkout -b develop; then
        if git push -u origin develop; then
            git checkout main
            print_success "Develop branch created"
        else
            print_warning "Failed to push develop branch, but local branch created"
            git checkout main
        fi
    else
        print_warning "Failed to create develop branch, continuing..."
    fi
fi

# Step 8: Show next steps
print_step "Step 8: Setup completed! Next steps:"
echo ""
echo -e "${GREEN}${CHECK} Repository URL: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}${NC}"
echo ""
echo -e "${CYAN}📋 Manual steps to complete:${NC}"
echo "1. ${YELLOW}Create Release:${NC}"
echo "   - Go to: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/releases"
echo "   - Click 'Create a new release'"
echo "   - Tag: v1.0.0"
echo "   - Title: Smart Branch v1.0.0 - Initial Release"
echo ""
echo "2. ${YELLOW}Enable GitHub Features:${NC}"
echo "   - Issues: Already configured ✅"
echo "   - Discussions: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings"
echo "   - GitHub Pages: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings/pages"
echo ""
echo "3. ${YELLOW}Setup Branch Protection:${NC}"
echo "   - Go to: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings/branches"
echo "   - Protect main branch"
echo ""
echo "4. ${YELLOW}Add Collaborators (if needed):${NC}"
echo "   - Go to: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings/access"
echo ""

# Step 9: Open repository in browser (optional)
if command -v xdg-open > /dev/null; then
    read -p "Open repository in browser? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        xdg-open "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
    fi
elif command -v open > /dev/null; then
    read -p "Open repository in browser? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
    fi
fi

print_success "Deploy script completed successfully!"

# Additional submodule information
if [ -f ".git" ]; then
    echo ""
    echo -e "${CYAN}📋 Submodule Management Tips:${NC}"
    echo "- Update submodule: ${YELLOW}git submodule update --remote smart-branch${NC}"
    echo "- Check submodule status: ${YELLOW}git submodule status${NC}"
    echo "- Sync parent repo after changes: ${YELLOW}git add . && git commit -m 'update submodule'${NC}"
fi

echo ""
echo -e "${PURPLE}${ROCKET} Happy coding with Smart Branch! ${ROCKET}${NC}"
echo ""