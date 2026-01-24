# Installation Guide

## Quick Start

### 1. Automated Installation
```bash
git clone https://github.com/yourusername/easy-clone-cli.git
cd easy-clone-cli
./setup.sh
```

### 2. Reload Shell
```bash
exec zsh
```

### 3. Test
```bash
clone <TAB>
```

## System Requirements

- **ZSH** 5.0 or higher
- **Git** 2.7.0 or higher
- **Bash** (for setup script)
- **GitHub CLI** (optional - falls back to curl)

### Check Your Setup

```bash
# Check ZSH version
zsh --version
# Should output: zsh 5.x.x or higher

# Check Git version
git --version
# Should output: git version 2.x.x or higher

# Check GitHub CLI (optional)
gh --version
# Should output: gh version x.x.x or higher
```

## Installation Methods

### Method 1: One-Liner (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/easy-clone-cli/main/setup.sh | bash
```

### Method 2: Manual Installation

If you prefer to install manually or don't trust automation scripts:

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/easy-clone-cli.git
   cd easy-clone-cli
   ```

2. **Create the config directory**
   ```bash
   mkdir -p ~/.config/zsh
   ```

3. **Copy the completion file**
   ```bash
   cp src/clone-completion.zsh ~/.config/zsh/
   ```

4. **Add to your ~/.zshrc**
   ```bash
   # Source the clone completion function
   source "$HOME/.config/zsh/clone-completion.zsh"

   # Clone command
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

   # ZSH completion context
   zstyle ':completion:*:clone:*' completer _clone_complete
   zstyle ':completion:*:clone:*' file-patterns '(no-files)'
   ```

5. **Reload your shell**
   ```bash
   exec zsh
   ```

### Method 3: With Zinit

If you use Zinit plugin manager:

```bash
zinit ice lucid
zinit snippet https://github.com/yourusername/easy-clone-cli/blob/main/src/clone-completion.zsh
```

Then add the `clone()` function to your `.zshrc` manually (see Method 2 above).

### Method 4: With Oh-My-Zsh

Create a custom plugin directory:

```bash
mkdir -p ~/.oh-my-zsh/custom/plugins/easy-clone-cli
cp src/clone-completion.zsh ~/.oh-my-zsh/custom/plugins/easy-clone-cli/
```

Add to your `.zshrc`:
```bash
plugins=(... easy-clone-cli)
```

Then add the `clone()` function.

## Configuration

### Default Owner

The default owner is set to `AIntelligentTech`. To change it:

1. Edit `~/.config/zsh/clone-completion.zsh`
2. Find the line:
   ```bash
   local owner="${1:-AIntelligentTech}"
   ```
3. Replace `AIntelligentTech` with your desired username

### SSH Remote

The default SSH remote is `aintelligenttech-github`. To use a different remote:

1. Edit your `~/.zshrc`
2. Find the `clone()` function
3. Change:
   ```bash
   git clone "aintelligenttech-github:${repo_slug}.git"
   ```
   to:
   ```bash
   git clone "git@github.com:${repo_slug}.git"
   ```
   or your custom remote

### Cache Location

The cache is stored at `~/.cache/zsh-completions/github-repos.txt` by default.

To change it, edit `~/.config/zsh/clone-completion.zsh`:
```bash
CLONE_CACHE_DIR="${HOME}/.cache/zsh-completions"
CLONE_CACHE_FILE="${CLONE_CACHE_DIR}/github-repos.txt"
```

## Verification

After installation, verify everything is working:

```bash
# Test 1: Function exists
type clone
# Output: clone is a function

# Test 2: Completion function exists
type _clone_complete
# Output: _clone_complete is a function

# Test 3: Cache initialized
ls -la ~/.cache/zsh-completions/github-repos.txt

# Test 4: Autocomplete works
clone <TAB>
# Should show repositories

# Test 5: Clone function works
clone --help
```

## Troubleshooting

### Completion Still Shows Files

This usually means:
1. ZSH completion system not properly initialized
2. `.zshrc` changes not loaded

Fix:
```bash
# Clear ZSH completion cache
rm -rf ~/.cache/zcompdump*

# Force reload
exec zsh

# Refresh repository cache
clone-refresh

# Test again
clone <TAB>
```

### Cache Empty

If repositories don't appear in autocomplete:

```bash
# Check GitHub CLI authentication
gh auth status

# Manual cache refresh
clone-refresh

# Check cache contents
cat ~/.cache/zsh-completions/github-repos.txt | wc -l
```

### Function Not Found

If you get "command not found: clone":

```bash
# Check if .zshrc is being loaded
echo $SHELL
# Should output: /usr/bin/zsh

# Check if zshrc is sourced
grep "clone" ~/.zshrc

# Reload shell
exec zsh
```

## Uninstallation

To remove Easy Clone CLI:

```bash
cd easy-clone-cli
./uninstall.sh
```

Or manually:
1. Remove source line from `~/.zshrc`
2. Delete `~/.config/zsh/clone-completion.zsh`
3. Delete `~/.cache/zsh-completions/github-repos.txt` (optional)
4. Reload shell: `exec zsh`

## Next Steps

- Read [USAGE.md](./USAGE.md) for usage examples
- Read [ARCHITECTURE.md](./ARCHITECTURE.md) for technical details
- Read [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for issues

## Support

- 🐛 Report issues: https://github.com/yourusername/easy-clone-cli/issues
- 💬 Ask questions: https://github.com/yourusername/easy-clone-cli/discussions
