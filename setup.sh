#!/usr/bin/env bash
# =============================================================================
# Easy Clone CLI - Installation Script
# =============================================================================
# This script installs the clone command and autocomplete to your system.
# Supported shells: ZSH (primary), Bash (basic support)
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLONE_COMPLETION_FILE="$SCRIPT_DIR/src/clone-completion.zsh"
CLONE_FUNCTION_FILE="$SCRIPT_DIR/src/clone-function.zsh"
ZSH_CONFIG_DIR="${HOME}/.config/zsh"

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
  echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}  Easy Clone CLI - Installation${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
  echo ""
}

print_success() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

# =============================================================================
# Checks
# =============================================================================

check_shell() {
  if [[ -z "$ZSH_VERSION" && -z "$BASH_VERSION" ]]; then
    print_error "This installer requires Bash or ZSH"
    exit 1
  fi

  if command -v zsh &>/dev/null; then
    ZSH_PATH=$(command -v zsh)
    print_success "ZSH found: $ZSH_PATH"
  else
    print_error "ZSH is required but not installed"
    exit 1
  fi
}

check_zshrc() {
  if [[ ! -f "$HOME/.zshrc" ]]; then
    print_warning "No .zshrc found. Creating one..."
    touch "$HOME/.zshrc"
  else
    print_success ".zshrc exists"
  fi
}

check_git() {
  if ! command -v git &>/dev/null; then
    print_error "Git is required but not installed"
    exit 1
  fi
  print_success "Git found"
}

check_github_cli() {
  if command -v gh &>/dev/null; then
    print_success "GitHub CLI found (recommended for best performance)"
  else
    print_warning "GitHub CLI not found - will fall back to curl"
    print_info "For better performance, install GitHub CLI: https://cli.github.com"
  fi
}

# =============================================================================
# Installation
# =============================================================================

install_completion() {
  print_info "Installing completion function..."

  mkdir -p "$ZSH_CONFIG_DIR"
  cp "$CLONE_COMPLETION_FILE" "$ZSH_CONFIG_DIR/clone-completion.zsh"
  print_success "Copied completion to $ZSH_CONFIG_DIR/clone-completion.zsh"
}

install_clone_function() {
  print_info "Installing clone function to .zshrc..."

  # Check if already installed
  if grep -q "source.*clone-completion" "$HOME/.zshrc"; then
    print_warning "Clone completion already sourced in .zshrc"
    return
  fi

  # Add sourcing to .zshrc
  cat >> "$HOME/.zshrc" << 'EOF'

# =============================================================================
# Easy Clone CLI - Git Repository Cloning with Autocomplete
# =============================================================================

# Source the clone completion function
if [[ -f "$HOME/.config/zsh/clone-completion.zsh" ]]; then
  source "$HOME/.config/zsh/clone-completion.zsh"
fi

# Clone command with smart owner prefix handling
clone() {
  if [[ -z "$1" ]]; then
    echo "Usage: clone <repo_name|owner/repo>"
    echo ""
    echo "Examples:"
    echo "  clone dotfiles              # Clone AIntelligentTech/dotfiles"
    echo "  clone AIntelligentTech/brain  # Clone with full slug"
    echo "  clone username/repository   # Clone from other owner"
    return 1
  fi

  local repo_slug="$1"

  # If no slash in input, prepend default owner
  if [[ ! "$repo_slug" == *"/"* ]]; then
    repo_slug="AIntelligentTech/${repo_slug}"
  fi

  git clone "aintelligenttech-github:${repo_slug}.git"
}

# Ensure cache exists on shell startup
mkdir -p "$HOME/.cache/zsh-completions"

# =============================================================================
EOF

  print_success "Added to .zshrc"
}

setup_completion_context() {
  print_info "Setting up ZSH completion context..."

  if grep -q "zstyle ':completion:\*:clone:\*'" "$HOME/.zshrc"; then
    print_warning "Completion context already configured"
    return
  fi

  cat >> "$HOME/.zshrc" << 'EOF'

# ZSH completion context for clone command
# This prevents file completion fallback and uses our custom completer
zstyle ':completion:*:clone:*' completer _clone_complete
zstyle ':completion:*:clone:*' file-patterns '(no-files)'

EOF

  print_success "Completion context configured"
}

# =============================================================================
# Verification
# =============================================================================

verify_installation() {
  print_info "Verifying installation..."

  if [[ ! -f "$ZSH_CONFIG_DIR/clone-completion.zsh" ]]; then
    print_error "Completion file not found"
    return 1
  fi

  if ! grep -q "clone-completion" "$HOME/.zshrc"; then
    print_error "Completion not sourced in .zshrc"
    return 1
  fi

  print_success "Installation verified"
  return 0
}

# =============================================================================
# Main Installation Flow
# =============================================================================

main() {
  print_header

  echo "Checking requirements..."
  echo ""

  check_shell
  check_zshrc
  check_git
  check_github_cli

  echo ""
  echo "Installing components..."
  echo ""

  install_completion
  install_clone_function
  setup_completion_context

  echo ""

  if verify_installation; then
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Reload your shell:"
    echo -e "   ${YELLOW}exec zsh${NC}"
    echo ""
    echo "2. Test the completion:"
    echo -e "   ${YELLOW}clone <TAB>${NC}"
    echo ""
    echo "3. Try cloning a repository:"
    echo -e "   ${YELLOW}clone <repo-name>${NC}"
    echo ""
    echo "For more information, see:"
    echo "  - README.md"
    echo "  - docs/INSTALLATION.md"
    echo "  - docs/USAGE.md"
    echo ""
  else
    echo ""
    print_error "Installation verification failed"
    echo ""
    echo "Please check:"
    echo "  1. File permissions"
    echo "  2. Disk space"
    echo "  3. Read docs/TROUBLESHOOTING.md"
    exit 1
  fi
}

# Run installation
main "$@"
