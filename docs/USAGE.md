# Usage Guide

## Basic Usage

### Cloning Repositories

#### Short Name (Default Owner)
```bash
clone nvim-config
# Expands to: git clone aintelligenttech-github:AIntelligentTech/nvim-config.git
```

#### Full Slug
```bash
clone AIntelligentTech/dotfiles
# Expands to: git clone aintelligenttech-github:AIntelligentTech/dotfiles.git
```

#### Other Owners
```bash
clone torvalds/linux
# Expands to: git clone aintelligenttech-github:torvalds/linux.git
```

### Using Autocomplete

#### View All Available Repositories
```bash
clone <TAB>
```

Displays your complete list of repositories with descriptions.

#### Fuzzy Search
```bash
clone nv<TAB>
# Shows: nvim-config, nvim-snacks-file-picker-mouse-support, etc.

clone agent<TAB>
# Shows: agent-deep-toolkit, etc.

clone br<TAB>
# Shows: brain, etc.
```

#### Full Preview
With FZF integration enabled, you get a preview of:
- Repository name
- Clone command
- Other metadata

## Advanced Usage

### Manual Cache Refresh

```bash
clone-refresh
```

Output:
```
Refreshing GitHub repository cache...
✓ Cached 51 repositories
```

Use when you've added new repositories and want immediate autocomplete access.

### Checking Function Version

```bash
type clone
# Output: clone is a function
```

### Getting Help

```bash
clone --help
# Shows usage information

clone
# Shows usage information if no arguments provided
```

## Common Workflows

### Cloning Multiple Repositories

```bash
# Clone several related repos
clone nvim-config
clone dotfiles
clone brain

# All use the AIntelligentTech prefix automatically
```

### Cloning from Different Owners

```bash
# Your repos (default prefix)
clone my-project

# Other projects
clone neovim/neovim
clone torvalds/linux
clone nodejs/node
```

### Mix of Methods

```bash
# Short name (fastest)
clone dotfiles

# Full slug (explicit)
clone AIntelligentTech/dotfiles

# Without owner (if different)
clone username/repo
```

## Integration Examples

### With Shell Aliases

```bash
# Add to ~/.zshrc for quick operations
alias cloneopen='clone && cd $(basename $1)'
alias clonelst='clone-refresh && clone'
```

### With Other Tools

```bash
# Clone and open in editor
clone nvim-config && nvim

# Clone into specific directory
clone dotfiles ~/.dotfiles
cd ~/.dotfiles

# Clone and list
clone dotfiles && ls -la
```

### With Git Workflows

```bash
# Clone for development
clone nvim-config
cd nvim-config
git checkout -b feature/my-feature

# Clone read-only (using https)
git clone https://github.com/AIntelligentTech/dotfiles.git
```

## Performance Tips

### Cache Behavior

**First Run (Cache Miss)**
- Duration: 2-3 seconds
- Action: Fetches all repositories from GitHub

**Subsequent Runs (Cache Hit)**
- Duration: <10ms
- Action: Uses cached repository list

**Stale Cache (>24 hours)**
- Duration: <10ms immediate + background refresh
- Action: Shows cached list, refreshes in background

### Optimize Autocomplete

```bash
# Pre-populate cache on shell startup (automatic)
# No action needed - happens in background

# Force immediate refresh before intensive cloning
clone-refresh

# Clear stale cache manually
rm ~/.cache/zsh-completions/github-repos.txt
clone-refresh
```

## Troubleshooting

### Autocomplete Not Working

```bash
# Test 1: Function exists
type _clone_complete

# Test 2: Cache exists
ls -la ~/.cache/zsh-completions/github-repos.txt

# Test 3: Manually refresh
clone-refresh

# Test 4: Try again
clone <TAB>
```

### Wrong Repositories Showing

```bash
# Check default owner
grep "local owner=" ~/.config/zsh/clone-completion.zsh

# Update if needed - see INSTALLATION.md
```

### Slow Autocomplete

```bash
# Check cache age
stat ~/.cache/zsh-completions/github-repos.txt

# Refresh if stale
clone-refresh

# Check GitHub CLI authentication
gh auth status
```

## Configuration Examples

### Change Default Owner

Edit `~/.config/zsh/clone-completion.zsh`:

```bash
# Before
local owner="${1:-AIntelligentTech}"

# After
local owner="${1:-your-username}"
```

### Use Standard GitHub SSH

Edit the `clone()` function in `~/.zshrc`:

```bash
# Before
git clone "aintelligenttech-github:${repo_slug}.git"

# After
git clone "git@github.com:${repo_slug}.git"
```

### Use HTTPS Instead of SSH

```bash
git clone "https://github.com/${repo_slug}.git"
```

## Best Practices

### ✅ Do

- Use short names for your default owner's repos: `clone dotfiles`
- Use full slugs for clarity when mixing owners: `clone username/repo`
- Refresh cache weekly with many new repos: `clone-refresh`
- Check GitHub authentication regularly: `gh auth status`

### ❌ Don't

- Don't use spaces in repo names (shell limitation)
- Don't modify completion while cloning (it's safe, but unnecessary)
- Don't rely on cached list for critical clones (refresh first if unsure)

## Examples by Use Case

### Learning New Projects

```bash
# Explore available repos
clone <TAB>

# Find interesting one
clone neovim

# Dive in
cd neovim
git log --oneline | head -20
```

### Contributing to Open Source

```bash
# Clone your fork
clone my-fork/project

# Set up remotes
cd project
git remote add upstream https://github.com/original/project.git

# Create feature branch
git checkout -b feature/improvement
```

### Managing Dotfiles

```bash
# Clone configuration repo
clone dotfiles

# Use with dotfiles manager
cd dotfiles
make install

# Or with stow
stow */
```

### Quick Setup

```bash
# Clone multiple repos efficiently
for repo in nvim-config dotfiles brain; do
  clone $repo &
done
wait

# All clone in parallel while you grab coffee
```

## Need Help?

- Check [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for common issues
- Check [ARCHITECTURE.md](./ARCHITECTURE.md) for technical details
- Open an issue: https://github.com/yourusername/easy-clone-cli/issues
- Ask for help: https://github.com/yourusername/easy-clone-cli/discussions
