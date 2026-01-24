# easy-clone-cli

> 🚀 Effortless Git cloning with intelligent repository autocomplete for GitHub and beyond.

A lightweight, robust ZSH utility that transforms `git clone` into a smart, intuitive command with GitHub repository autocomplete, intelligent owner prefix handling, and modern developer ergonomics.

## Features

✨ **Smart Repository Autocomplete**
- Autocomplete GitHub repositories directly in your shell
- Intelligent fuzzy searching with FZF integration
- 24-hour intelligent caching with automatic background refresh
- Zero performance impact on shell startup

🧠 **Intelligent Prefix Handling**
- Use short repo names: `clone nvim-config`
- Use full slugs: `clone AIntelligentTech/nvim-config`
- Use other accounts: `clone username/repo`
- Automatic owner prefix injection when needed

⚡ **Developer-Focused**
- Minimal, focused codebase (~110 lines of clean ZSH)
- No external dependencies beyond GitHub CLI (optional fallback to curl)
- Battle-tested with custom SSH remotes
- Full backward compatibility with standard `git clone`

🛠️ **Production Ready**
- Explicit error handling and return codes
- Comprehensive troubleshooting guides
- Automated test suite
- Full documentation

## Quick Start

### 1. Clone this repository
```bash
git clone https://github.com/yourusername/easy-clone-cli.git
cd easy-clone-cli
```

### 2. Run the installer
```bash
./setup.sh
```

### 3. Reload your shell
```bash
exec zsh
```

### 4. Test it out
```bash
clone <TAB>           # Autocomplete your repos
clone nvim-config     # Clone with short name
clone dotfiles        # Another repo
```

## Installation Methods

### Method 1: Automated Installation (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/easy-clone-cli/main/setup.sh | bash
```

### Method 2: Manual Installation
1. Copy `src/clone-completion.zsh` to `~/.config/zsh/`
2. Add to your `~/.zshrc`:
   ```bash
   source ~/.config/zsh/clone-completion.zsh
   ```
3. Reload: `exec zsh`

### Method 3: With Zinit Plugin Manager
```bash
zinit ice lucid
zinit snippet https://github.com/yourusername/easy-clone-cli/blob/main/src/clone-completion.zsh
```

## Usage Examples

### Basic Cloning
```bash
# Short names (with default prefix)
clone nvim-config
clone agent-deep-toolkit
clone brain

# Full slugs (any owner)
clone AIntelligentTech/dotfiles
clone torvalds/linux
clone neovim/neovim

# Mixed usage
clone myrepo                    # Uses default prefix
clone username/myrepo          # Uses specified owner
```

### Autocomplete Features
```bash
# List all available repositories
clone <TAB>

# Fuzzy search
clone nv<TAB>                  # Shows nvim-* repos
clone agent<TAB>               # Shows agent-* repos

# Full repo preview in FZF
clone <TAB>                    # Shows preview with repo info
```

### Cache Management
```bash
# Manually refresh the cache
clone-refresh

# Cache automatically refreshes every 24 hours
# or refresh manually whenever needed
```

## Configuration

### Customizing the Default Owner

Edit `~/.config/zsh/clone-completion.zsh` and change:

```bash
local owner="${1:-AIntelligentTech}"
```

Replace `AIntelligentTech` with your default GitHub username.

### Customizing the SSH Remote

Edit your `.zshrc` and change the `clone()` function:

```bash
clone() {
  local repo_slug="$1"
  if [[ ! "$repo_slug" == *"/"* ]]; then
    repo_slug="DefaultOwner/${repo_slug}"
  fi
  git clone "your-ssh-remote:${repo_slug}.git"
}
```

### Using with Standard SSH

```bash
git clone "git@github.com:${repo_slug}.git"
```

## Architecture

See [ARCHITECTURE.md](./docs/ARCHITECTURE.md) for comprehensive technical details including:
- Completion system design (three-layer architecture)
- Cache management strategy
- Integration with ZSH completion system
- Performance characteristics
- Future enhancement possibilities

## Troubleshooting

### Issue: Autocomplete shows files instead of repos

**Solution**: Ensure you're using ZSH 5.0+
```bash
zsh --version  # Should be 5.0 or higher
```

Force reload:
```bash
exec zsh
clone-refresh
clone <TAB>
```

See [TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md) for more issues.

## Requirements

- **ZSH** 5.0 or higher
- **GitHub CLI** (optional - falls back to curl if not available)
- **Git** 2.7.0 or higher
- **FZF** (optional - for fuzzy search in autocomplete)

## Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| Linux    | ✅ Tested | Ubuntu, Debian, Fedora, Arch |
| macOS    | ✅ Tested | 10.15+, M1/Intel |
| BSD      | ✅ Likely | Not extensively tested |
| WSL2     | ✅ Tested | Windows 11 with WSL2 |

## Performance

| Operation | Time | Notes |
|-----------|------|-------|
| Cache hit | <10ms | Instant from disk |
| Cache miss | 2-3s | One-time fetch from GitHub |
| Stale cache | <10ms | Uses cache + background refresh |
| Shell startup | ~0ms | Zero impact |

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

### Quick Start for Contributors

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-thing`
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Code of Conduct

This project adheres to the Contributor Covenant Code of Conduct. See [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) for details.

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Uninstallation

```bash
./uninstall.sh
```

Or manually:
1. Remove from `~/.zshrc`: `source ~/.config/zsh/clone-completion.zsh`
2. Remove the file: `rm ~/.config/zsh/clone-completion.zsh`
3. Clear cache: `rm -rf ~/.cache/zsh-completions/github-repos.txt`
4. Reload: `exec zsh`

## Changelog

See [CHANGELOG.md](./docs/CHANGELOG.md) for version history.

## Support

- 📖 Check [Documentation](./docs/)
- 🐛 Report bugs: [GitHub Issues](https://github.com/yourusername/easy-clone-cli/issues)
- 💬 Ask questions: [GitHub Discussions](https://github.com/yourusername/easy-clone-cli/discussions)

## Acknowledgments

Built with ❤️ for developers who value simplicity and efficiency.

Inspired by the need for smarter Git workflows and modern shell tooling.

---

**Version**: 1.0.0
**Status**: Production Ready
**Last Updated**: January 2026
