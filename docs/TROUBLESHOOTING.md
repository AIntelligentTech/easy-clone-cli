# Troubleshooting Guide

## Common Issues and Solutions

### Issue 1: Autocomplete Shows Files Instead of Repositories

**Symptoms:**
```bash
clone <TAB>
# Shows: Downloads/, Documents/, .config/, etc.
# WRONG - should show repos
```

**Root Causes:**
1. ZSH completion not properly initialized
2. Deferred loading of completion function
3. File completion not explicitly disabled

**Solutions:**

**Solution A: Force Reload** (Usually works)
```bash
# Step 1: Clear ZSH completion cache
rm -rf ~/.cache/zcompdump*

# Step 2: Clear repository cache
rm ~/.cache/zsh-completions/github-repos.txt

# Step 3: Force reload shell
exec zsh

# Step 4: Refresh repository cache
clone-refresh

# Step 5: Test
clone <TAB>
```

**Solution B: Verify Configuration**
```bash
# Check if completion is sourced
grep -n "clone-completion" ~/.zshrc

# Check if zstyle is set
grep -n "zstyle.*clone" ~/.zshrc

# Expected output:
# source ~/.config/zsh/clone-completion.zsh
# zstyle ':completion:*:clone:*' completer _clone_complete
# zstyle ':completion:*:clone:*' file-patterns '(no-files)'
```

**Solution C: Manual Configuration**
```bash
# 1. Open .zshrc in your editor
nano ~/.zshrc

# 2. Verify these lines exist (add if missing):
#    source ~/.config/zsh/clone-completion.zsh
#    zstyle ':completion:*:clone:*' completer _clone_complete
#    zstyle ':completion:*:clone:*' file-patterns '(no-files)'

# 3. Save and reload
exec zsh
```

---

### Issue 2: Cache Empty - No Repositories in Autocomplete

**Symptoms:**
```bash
clone <TAB>
# No repositories shown, error message

clone-refresh
# ✗ Failed to fetch repositories
```

**Root Causes:**
1. GitHub CLI not authenticated
2. Network connectivity issue
3. GitHub API rate limits exceeded
4. Repository list endpoint failure

**Solutions:**

**Solution A: Check GitHub Authentication**
```bash
# Check if GitHub CLI is installed
command -v gh
# If not: brew install gh (or your package manager)

# Check authentication status
gh auth status
# Output should show your login

# Re-authenticate if needed
gh auth login
```

**Solution B: Check Network Connectivity**
```bash
# Test network connection
ping github.com

# Test GitHub API directly
curl -i https://api.github.com/users/AIntelligentTech/repos?per_page=1

# Should return: HTTP/1.1 200 OK
```

**Solution C: Check Rate Limits**
```bash
# Unauthenticated requests: 60 per hour
# Authenticated requests: 5000 per hour

gh api rate_limit
# Shows remaining requests

# Fix: Ensure you're authenticated
gh auth status
```

**Solution D: Force Refresh**
```bash
# Clear cache
rm ~/.cache/zsh-completions/github-repos.txt

# Refresh with debug output
sh -x ~/.config/zsh/clone-completion.zsh
```

---

### Issue 3: Clone Function Not Found

**Symptoms:**
```bash
clone dotfiles
# zsh: command not found: clone
```

**Root Causes:**
1. Function not defined in .zshrc
2. Wrong shell (using Bash instead of ZSH)
3. .zshrc not being loaded

**Solutions:**

**Solution A: Verify You're Using ZSH**
```bash
# Check current shell
echo $SHELL
# Output should be: /usr/bin/zsh (or similar)

# If using bash or other shell, switch to ZSH
exec zsh
```

**Solution B: Check if Function Is Defined**
```bash
# Try to access function
type clone

# Should output: clone is a function

# If not found, check .zshrc
grep -n "^clone()" ~/.zshrc
# Should find the function definition
```

**Solution C: Ensure .zshrc Exists and Is Loaded**
```bash
# Check if .zshrc exists
ls -la ~/.zshrc

# Check if it's being sourced
cat ~/.zshrc | head -5

# If file doesn't exist, create it
touch ~/.zshrc

# Reload shell
exec zsh
```

**Solution D: Manually Add Function**
```bash
# Add to your ~/.zshrc:
clone() {
  if [[ -z "$1" ]]; then
    echo "Usage: clone <repo_name|owner/repo>"
    return 1
  fi

  local repo_slug="$1"
  if [[ ! "$repo_slug" == *"/"* ]]; then
    repo_slug="AIntelligentTech/${repo_slug}"
  fi
  git clone "aintelligenttech-github:${repo_slug}.git"
}

# Reload
exec zsh
```

---

### Issue 4: Wrong Repositories Shown

**Symptoms:**
```bash
clone <TAB>
# Shows repos from wrong owner
# Expected: AIntelligentTech repos
# Actual: OtherUsername repos
```

**Root Causes:**
1. Default owner misconfigured
2. Cache from different owner

**Solutions:**

**Solution A: Check Default Owner**
```bash
# Find the default owner setting
grep "local owner=" ~/.config/zsh/clone-completion.zsh

# Should show:
# local owner="${1:-AIntelligentTech}"
```

**Solution B: Update Default Owner**
```bash
# Edit the completion file
nano ~/.config/zsh/clone-completion.zsh

# Find the line:
# local owner="${1:-AIntelligentTech}"

# Change to:
# local owner="${1:-YourUsername}"

# Save and reload
exec zsh
```

**Solution C: Clear and Refresh Cache**
```bash
# Clear old cache
rm ~/.cache/zsh-completions/github-repos.txt

# Refresh with correct owner
clone-refresh

# Verify
cat ~/.cache/zsh-completions/github-repos.txt | head -5
```

---

### Issue 5: Slow Autocomplete Response

**Symptoms:**
```bash
clone <TAB>
# Takes 2-3 seconds to show results
# Should be instant
```

**Root Causes:**
1. Cache is stale (>24 hours old)
2. GitHub CLI not installed (falls back to curl)
3. Network connectivity slow

**Solutions:**

**Solution A: Check Cache Age**
```bash
# View cache file age
stat ~/.cache/zsh-completions/github-repos.txt | grep Modify

# If older than 24 hours, refresh:
clone-refresh
```

**Solution B: Install GitHub CLI**
```bash
# macOS
brew install gh

# Linux (Debian/Ubuntu)
sudo apt install gh

# Linux (Fedora)
sudo dnf install gh

# Verify
gh --version
```

**Solution C: Pre-populate Cache on Startup**
```bash
# Add to your ~/.zshrc (already in setup):
if [[ ! -f "$HOME/.cache/zsh-completions/github-repos.txt" ]]; then
  _clone_fetch_repos "AIntelligentTech" &>/dev/null &
fi
```

---

### Issue 6: Git Clone Fails with SSH Remote

**Symptoms:**
```bash
clone dotfiles
# fatal: could not read Username for 'aintelligenttech-github': No such file or directory
```

**Root Causes:**
1. SSH remote not configured in Git
2. SSH key not added to GitHub account
3. Wrong SSH remote name

**Solutions:**

**Solution A: Configure SSH Remote**
```bash
# Add custom remote to ~/.gitconfig
git config --global url."git@github.com:".insteadOf "aintelligenttech-github:"

# Or use standard GitHub SSH
git config --global url."git@github.com:".insteadOf "git+ssh://git@github.com/"
```

**Solution B: Check SSH Keys**
```bash
# List SSH keys
ls -la ~/.ssh/

# If no keys, generate one
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Add public key to GitHub:
# https://github.com/settings/keys
```

**Solution C: Use HTTPS Instead**
```bash
# Edit ~/.zshrc and change the clone function:
git clone "https://github.com/${repo_slug}.git"

# No SSH configuration needed
```

---

### Issue 7: Multiple Instances of Repositories in Cache

**Symptoms:**
```bash
clone <TAB>
# Shows duplicates: nvim-config, nvim-config
# Shows both formats: AIntelligentTech/nvim-config, nvim-config
```

**Root Causes:**
1. Completion function fetches both formats
2. Outdated version of clone-completion.zsh

**Solutions:**

**Solution A: Update to Latest Version**
```bash
# Pull latest changes
cd easy-clone-cli
git pull origin main

# Reinstall
./setup.sh

# Reload
exec zsh
```

**Solution B: Manual Fix**
```bash
# Edit the completion file
nano ~/.config/zsh/clone-completion.zsh

# Find _clone_fetch_repos function
# Ensure it only has ONE fetch command:
# ✓ CORRECT:
#   gh repo list "$owner" --limit 1000 --json name --jq '.[].name'
#
# ✗ WRONG (old version):
#   gh repo list "$owner" --json nameWithOwner --jq '.[].nameWithOwner'
#   gh repo list "$owner" --json name --jq '.[].name'

# Keep only the short name fetch
```

**Solution C: Clear and Regenerate Cache**
```bash
# Remove cache
rm ~/.cache/zsh-completions/github-repos.txt

# Regenerate
clone-refresh

# Verify (should show 51 items, not 102)
wc -l ~/.cache/zsh-completions/github-repos.txt
```

---

## Diagnostic Commands

Run these to troubleshoot:

```bash
# 1. Check shell version
zsh --version

# 2. Check ZSH configuration
echo $SHELL

# 3. Check function exists
type clone
type _clone_complete

# 4. Check completion configuration
compdef -p | grep clone

# 5. Check cache
ls -lh ~/.cache/zsh-completions/github-repos.txt
wc -l ~/.cache/zsh-completions/github-repos.txt

# 6. Check Git configuration
git config --list | grep url

# 7. Check GitHub CLI
gh auth status
gh repo list --limit 1

# 8. Check SSH
ssh -T git@github.com

# 9. Test network
ping github.com
curl -I https://api.github.com
```

## Manual Testing

```bash
# Test 1: Function definition
source ~/.config/zsh/clone-completion.zsh
type _clone_complete

# Test 2: Cache fetch
_clone_fetch_repos "AIntelligentTech"
cat ~/.cache/zsh-completions/github-repos.txt

# Test 3: Completion output
_clone_complete "clone" "clone nv" 2
# Should show repos starting with 'nv'

# Test 4: Clone command
clone --help
```

## Getting Help

If you still need help:

1. **Check the logs**
   ```bash
   # Enable debug mode
   set -x
   clone <TAB>
   set +x
   ```

2. **Share diagnostic info**
   ```bash
   # Run this and share output with maintainer
   zsh --version
   type clone
   gh auth status
   wc -l ~/.cache/zsh-completions/github-repos.txt
   ```

3. **Open an issue**
   - https://github.com/yourusername/easy-clone-cli/issues
   - Include output from diagnostic commands above

4. **Ask in discussions**
   - https://github.com/yourusername/easy-clone-cli/discussions

## Performance Optimization

```bash
# Pre-populate cache in background on startup
# (Add to ~/.zshrc)
if [[ ! -f "$HOME/.cache/zsh-completions/github-repos.txt" ]]; then
  _clone_fetch_repos "AIntelligentTech" &>/dev/null &
fi

# Customize cache TTL (in ~/.config/zsh/clone-completion.zsh)
# Default: 24 hours = 86400 seconds
CLONE_CACHE_MAX_AGE=$((24 * 60 * 60))

# Make it 48 hours for less frequent updates:
CLONE_CACHE_MAX_AGE=$((48 * 60 * 60))
```

## Reset to Defaults

If everything is misconfigured:

```bash
# 1. Uninstall
./uninstall.sh

# 2. Clean everything
rm -rf ~/.config/zsh/clone-completion.zsh
rm -rf ~/.cache/zsh-completions/

# 3. Reload
exec zsh

# 4. Reinstall
./setup.sh
```
