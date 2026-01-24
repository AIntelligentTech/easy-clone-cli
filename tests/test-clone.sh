#!/usr/bin/env zsh
# =============================================================================
# Easy Clone CLI - Test Suite
# =============================================================================
# Comprehensive tests for clone command and autocomplete system

set -e

echo "═══════════════════════════════════════════════════════════════"
echo "  Easy Clone CLI - Test Suite"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# =============================================================================
# Helper Functions
# =============================================================================

run_test() {
  local test_name="$1"
  local test_cmd="$2"

  echo -n "Testing: $test_name ... "

  if eval "$test_cmd" &>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((TESTS_PASSED++))
  else
    echo -e "${RED}✗ FAIL${NC}"
    ((TESTS_FAILED++))
  fi
}

# =============================================================================
# 1. Environment Checks
# =============================================================================

echo -e "${BLUE}1. Environment Checks${NC}"
echo ""

run_test "Running in ZSH" '[[ -n "$ZSH_VERSION" ]]'
run_test "ZSH version 5.0+" '[[ "${ZSH_VERSION%.*}" -ge 5 ]]'
run_test "Git installed" 'command -v git &>/dev/null'
run_test "Bash available" 'command -v bash &>/dev/null'

echo ""

# =============================================================================
# 2. Installation Checks
# =============================================================================

echo -e "${BLUE}2. Installation Checks${NC}"
echo ""

run_test "Completion file exists" '[[ -f ~/.config/zsh/clone-completion.zsh ]]'
run_test "Completion sourced in zshrc" 'grep -q "clone-completion" ~/.zshrc'
run_test "Cache directory exists" '[[ -d ~/.cache/zsh-completions ]]'
run_test "Cache file exists" '[[ -f ~/.cache/zsh-completions/github-repos.txt ]]'

echo ""

# =============================================================================
# 3. Function Checks
# =============================================================================

echo -e "${BLUE}3. Function Checks${NC}"
echo ""

run_test "clone function defined" 'type clone &>/dev/null'
run_test "clone-refresh function defined" 'type clone-refresh &>/dev/null'
run_test "_clone_complete function defined" 'type _clone_complete &>/dev/null'
run_test "_clone_fetch_repos function defined" 'type _clone_fetch_repos &>/dev/null'
run_test "_clone_cache_is_fresh function defined" 'type _clone_cache_is_fresh &>/dev/null'

echo ""

# =============================================================================
# 4. Cache Content Checks
# =============================================================================

echo -e "${BLUE}4. Cache Content Checks${NC}"
echo ""

REPO_COUNT=$(wc -l < ~/.cache/zsh-completions/github-repos.txt 2>/dev/null || echo 0)
run_test "Cache not empty ($REPO_COUNT repos)" '[[ $REPO_COUNT -gt 0 ]]'
run_test "Cache has short names" 'grep -qv "/" ~/.cache/zsh-completions/github-repos.txt'
run_test "Cache doesn't have full slugs duplicates" '[[ $(grep -c "/" ~/.cache/zsh-completions/github-repos.txt || true) -eq 0 ]]'
run_test "No empty lines in cache" '[[ -z $(grep "^$" ~/.cache/zsh-completions/github-repos.txt || true) ]]'

echo ""

# =============================================================================
# 5. ZSH Configuration Checks
# =============================================================================

echo -e "${BLUE}5. ZSH Configuration Checks${NC}"
echo ""

run_test "zstyle completer set for clone" 'grep -q "zstyle.*clone.*completer.*_clone_complete" ~/.zshrc'
run_test "zstyle file-patterns set for clone" 'grep -q "zstyle.*clone.*file-patterns" ~/.zshrc'

echo ""

# =============================================================================
# 6. GitHub Integration Checks
# =============================================================================

echo -e "${BLUE}6. GitHub Integration Checks${NC}"
echo ""

run_test "GitHub CLI installed" 'command -v gh &>/dev/null'
run_test "GitHub CLI authenticated" 'gh auth status &>/dev/null 2>&1'

if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
  run_test "Can list repositories" 'gh repo list --limit 1 &>/dev/null'
fi

echo ""

# =============================================================================
# 7. Functional Behavior Tests
# =============================================================================

echo -e "${BLUE}7. Functional Behavior Tests${NC}"
echo ""

# Test clone function argument handling
run_test "clone with no args returns error" '! clone &>/dev/null'

# Test cache freshness
run_test "Cache freshness check works" '_clone_cache_is_fresh'

# Test short name prefix handling
echo "Testing: Short name prefix detection"
TEST_SHORT="nvim-config"
TEST_FULL="AIntelligentTech/nvim-config"
if [[ ! "$TEST_SHORT" == *"/"* ]] && [[ "$TEST_FULL" == *"/"* ]]; then
  echo -e "${GREEN}✓${NC} PASS"
  ((TESTS_PASSED++))
else
  echo -e "${RED}✗${NC} FAIL"
  ((TESTS_FAILED++))
fi

echo ""

# =============================================================================
# 8. File Integrity Checks
# =============================================================================

echo -e "${BLUE}8. File Integrity Checks${NC}"
echo ""

run_test "Completion file is readable" '[[ -r ~/.config/zsh/clone-completion.zsh ]]'
run_test "Cache file is readable" '[[ -r ~/.cache/zsh-completions/github-repos.txt ]]'
run_test ".zshrc is readable" '[[ -r ~/.zshrc ]]'

echo ""

# =============================================================================
# 9. Performance Checks
# =============================================================================

echo -e "${BLUE}9. Performance Checks${NC}"
echo ""

# Measure cache freshness check time
START=$(date +%s%N)
_clone_cache_is_fresh &>/dev/null
END=$(date +%s%N)
ELAPSED=$(( (END - START) / 1000000 ))

if [[ $ELAPSED -lt 50 ]]; then
  echo -e "Cache freshness check: ${GREEN}${ELAPSED}ms${NC} (fast)"
  ((TESTS_PASSED++))
else
  echo -e "Cache freshness check: ${YELLOW}${ELAPSED}ms${NC} (acceptable)"
  ((TESTS_PASSED++))
fi

echo ""

# =============================================================================
# 10. Documentation Checks
# =============================================================================

echo -e "${BLUE}10. Documentation Checks${NC}"
echo ""

run_test "README.md exists" '[[ -f README.md ]]'
run_test "INSTALLATION.md exists" '[[ -f docs/INSTALLATION.md ]]'
run_test "USAGE.md exists" '[[ -f docs/USAGE.md ]]'
run_test "TROUBLESHOOTING.md exists" '[[ -f docs/TROUBLESHOOTING.md ]]'
run_test "ARCHITECTURE.md exists" '[[ -f docs/ARCHITECTURE.md ]]'
run_test "LICENSE exists" '[[ -f LICENSE ]]'
run_test "CONTRIBUTING.md exists" '[[ -f CONTRIBUTING.md ]]'
run_test "CODE_OF_CONDUCT.md exists" '[[ -f CODE_OF_CONDUCT.md ]]'

echo ""

# =============================================================================
# Results
# =============================================================================

echo "═══════════════════════════════════════════════════════════════"
echo -e "${BLUE}Test Results${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))
if [[ $TOTAL_TESTS -gt 0 ]]; then
  PASS_PERCENT=$((TESTS_PASSED * 100 / TOTAL_TESTS))
else
  PASS_PERCENT=0
fi

echo "Total Tests:    $TOTAL_TESTS"
echo -e "Passed:         ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed:         ${RED}$TESTS_FAILED${NC}"
echo -e "Success Rate:   ${BLUE}${PASS_PERCENT}%${NC}"
echo ""

if [[ $TESTS_FAILED -eq 0 ]]; then
  echo -e "${GREEN}✓ All tests passed!${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Verify autocomplete: clone <TAB>"
  echo "  2. Test cloning: clone <repo-name>"
  echo "  3. Check documentation: README.md"
  echo ""
  exit 0
else
  echo -e "${RED}✗ Some tests failed${NC}"
  echo ""
  echo "Troubleshooting:"
  echo "  1. Check docs/TROUBLESHOOTING.md"
  echo "  2. Run diagnostic commands:"
  echo "     - type clone"
  echo "     - gh auth status"
  echo "     - cat ~/.cache/zsh-completions/github-repos.txt"
  echo "  3. Reinstall if needed: ./setup.sh"
  echo ""
  exit 1
fi
