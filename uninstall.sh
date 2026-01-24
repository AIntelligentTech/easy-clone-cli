#!/usr/bin/env bash
# =============================================================================
# Easy Clone CLI - Uninstallation Script
# =============================================================================
# This script safely removes the clone command and autocomplete from your system.
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
  echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}  Easy Clone CLI - Uninstallation${NC}"
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

confirm() {
  local prompt="$1"
  local response

  echo -n -e "${YELLOW}$prompt${NC} (y/N) "
  read -r response

  [[ "$response" =~ ^[Yy]$ ]]
}

# =============================================================================
# Uninstallation
# =============================================================================

uninstall_completion_file() {
  local completion_file="$HOME/.config/zsh/clone-completion.zsh"

  if [[ -f "$completion_file" ]]; then
    rm "$completion_file"
    print_success "Removed completion file"
  else
    print_warning "Completion file not found (already removed?)"
  fi
}

uninstall_from_zshrc() {
  local zshrc="$HOME/.zshrc"

  if [[ ! -f "$zshrc" ]]; then
    print_warning ".zshrc not found"
    return
  fi

  # Create backup
  cp "$zshrc" "${zshrc}.bak-$(date +%s)"
  print_info "Created backup: ${zshrc}.bak-*"

  # Remove Easy Clone CLI sections
  # This is conservative - only removes our specific markers
  sed -i.tmp '/^# Easy Clone CLI/,/^# =/d' "$zshrc"
  sed -i.tmp '/clone-completion/d' "$zshrc"
  sed -i.tmp '/clone() {/,/^}/d' "$zshrc"
  sed -i.tmp '/zstyle.*clone/d' "$zshrc"
  sed -i.tmp '/mkdir -p.*zsh-completions/d' "$zshrc"

  # Clean up temp file
  rm -f "${zshrc}.tmp"

  print_success "Removed from .zshrc"
}

clear_cache() {
  local cache_file="$HOME/.cache/zsh-completions/github-repos.txt"

  if [[ -f "$cache_file" ]]; then
    rm "$cache_file"
    print_success "Cleared cache"
  else
    print_warning "Cache file not found (already cleared?)"
  fi
}

# =============================================================================
# Verification
# =============================================================================

verify_uninstallation() {
  print_info "Verifying uninstallation..."

  local still_installed=false

  if [[ -f "$HOME/.config/zsh/clone-completion.zsh" ]]; then
    print_warning "Completion file still exists"
    still_installed=true
  fi

  if grep -q "clone-completion" "$HOME/.zshrc" 2>/dev/null; then
    print_warning "References still in .zshrc"
    still_installed=true
  fi

  if [[ "$still_installed" == "false" ]]; then
    print_success "Uninstallation verified"
    return 0
  else
    return 1
  fi
}

# =============================================================================
# Main Uninstallation Flow
# =============================================================================

main() {
  print_header

  echo "This will remove Easy Clone CLI from your system."
  echo ""

  if ! confirm "Continue with uninstallation?"; then
    echo ""
    print_info "Uninstallation cancelled"
    exit 0
  fi

  echo ""
  echo "Uninstalling components..."
  echo ""

  uninstall_completion_file
  uninstall_from_zshrc
  clear_cache

  echo ""

  if verify_uninstallation; then
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Uninstallation Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Reload your shell:"
    echo -e "   ${YELLOW}exec zsh${NC}"
    echo ""
    echo "2. Verify clone is removed:"
    echo -e "   ${YELLOW}type clone${NC}"
    echo ""
    echo "Your backup .zshrc is saved as .zshrc.bak-*"
    echo ""
  else
    echo ""
    print_warning "Some components may remain. Please check manually:"
    echo "  1. ~/.config/zsh/clone-completion.zsh"
    echo "  2. ~/.zshrc (search for 'clone')"
    echo "  3. ~/.cache/zsh-completions/github-repos.txt"
    echo ""
  fi
}

# Run uninstallation
main "$@"
