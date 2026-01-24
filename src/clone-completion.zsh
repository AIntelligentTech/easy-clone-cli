# =============================================================================
# Clone Command Autocomplete - GitHub Repository Completion
# =============================================================================
# Version: 1.0.0
# License: MIT
# Description: Intelligent ZSH autocomplete for Git repository cloning with
#              GitHub integration and smart caching.
# =============================================================================

# Cache configuration
CLONE_CACHE_DIR="${HOME}/.cache/zsh-completions"
CLONE_CACHE_FILE="${CLONE_CACHE_DIR}/github-repos.txt"
CLONE_CACHE_MAX_AGE=$((24 * 60 * 60))  # 24 hours in seconds

# =============================================================================
# Cache Management Functions
# =============================================================================

# Check if cache is fresh (less than 24 hours old)
_clone_cache_is_fresh() {
  [[ -f "$CLONE_CACHE_FILE" ]] || return 1
  local cache_age=$(( $(date +%s) - $(stat -c %Y "$CLONE_CACHE_FILE" 2>/dev/null || echo 0) ))
  [[ $cache_age -lt $CLONE_CACHE_MAX_AGE ]]
}

# Fetch repositories from GitHub and cache them
# Only stores short repo names (not full slugs) to avoid duplication
_clone_fetch_repos() {
  local owner="${1:-AIntelligentTech}"
  mkdir -p "$CLONE_CACHE_DIR"

  if command -v gh &>/dev/null; then
    # Use gh CLI - fetch only short repo names
    gh repo list "$owner" --limit 1000 --json name --jq '.[].name' 2>/dev/null > "$CLONE_CACHE_FILE"
    return $?
  else
    # Fallback: curl to public API - extract just repo names
    curl -s "https://api.github.com/users/${owner}/repos?per_page=100" 2>/dev/null | \
      grep -o '"name": "[^"]*"' | cut -d'"' -f4 > "$CLONE_CACHE_FILE"
    return $?
  fi
}

# Refresh cache asynchronously (non-blocking)
_clone_refresh_cache_async() {
  { _clone_fetch_repos "AIntelligentTech" &>/dev/null } &>/dev/null &
}

# =============================================================================
# Public Command
# =============================================================================

# Manual cache refresh - user-facing
clone-refresh() {
  echo "Refreshing GitHub repository cache..."
  if _clone_fetch_repos "AIntelligentTech"; then
    local count=$(wc -l < "$CLONE_CACHE_FILE" 2>/dev/null || echo 0)
    echo "✓ Cached $count repositories"
    return 0
  else
    echo "✗ Failed to fetch repositories"
    return 1
  fi
}

# =============================================================================
# Zsh Completion Function
# =============================================================================

_clone_complete() {
  local -a repos line state

  # Only complete first argument (repository name)
  if [[ $CURRENT -ne 2 ]]; then
    return 1
  fi

  # Initialize cache on first use
  if [[ ! -f "$CLONE_CACHE_FILE" ]]; then
    _clone_fetch_repos "AIntelligentTech" &>/dev/null
  fi

  # Refresh cache asynchronously if stale
  if ! _clone_cache_is_fresh; then
    _clone_refresh_cache_async
  fi

  # Load and complete with cached repos
  if [[ -f "$CLONE_CACHE_FILE" ]]; then
    repos=(\"${(@f)$(cat \"$CLONE_CACHE_FILE\")}\")

    # Use _describe with correct tag to show ONLY repos (no file fallback)
    # Return 0 to prevent default completion
    if (( ${#repos[@]} > 0 )); then
      _describe -t repos 'GitHub repository' repos -V repos
      return 0
    fi
  fi

  # Explicitly refuse file completion
  _message "No repositories available. Run: clone-refresh"
  return 1
}

# =============================================================================
# Register Completion
# =============================================================================

# Use compdef to register our completion function
# This must happen AFTER compinit has been called
compdef _clone_complete clone 2>/dev/null || true

# Ensure cache exists on shell startup
if [[ ! -f "$CLONE_CACHE_FILE" ]]; then
  _clone_fetch_repos "AIntelligentTech" &>/dev/null &
fi
