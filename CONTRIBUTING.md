# Contributing Guide

Thank you for your interest in contributing to Easy Clone CLI! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please read and follow our [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) in all interactions.

## How Can I Contribute?

### Reporting Bugs

**Before Submitting a Bug Report:**
- Check the [existing issues](https://github.com/yourusername/easy-clone-cli/issues)
- Check the [troubleshooting guide](./docs/TROUBLESHOOTING.md)
- Test with the latest version
- Run diagnostic commands in TROUBLESHOOTING.md

**When Submitting a Bug Report:**
- Use a clear, descriptive title
- Include your environment (OS, ZSH version, GitHub CLI version)
- Provide step-by-step reproduction instructions
- Include expected vs actual behavior
- Include relevant output/logs
- Use code blocks for commands/output

**Bug Report Template:**
```markdown
**Environment:**
- OS: macOS 13.5
- ZSH version: 5.9
- GitHub CLI version: 2.30.0
- Installation method: setup.sh

**Description:**
[Clear description of the bug]

**Steps to Reproduce:**
1. [First step]
2. [Second step]
3. [...]

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happened]

**Logs/Output:**
```
[Include relevant output]
```
```

### Suggesting Enhancements

**Before Submitting:**
- Check existing [issues](https://github.com/yourusername/easy-clone-cli/issues) and [discussions](https://github.com/yourusername/easy-clone-cli/discussions)
- Provide use cases

**Enhancement Suggestion Template:**
```markdown
**Problem:**
[Describe the problem this solves or limitation this addresses]

**Proposed Solution:**
[Describe your proposed solution]

**Use Case:**
[How would you use this feature?]

**Alternatives Considered:**
[Other approaches you've considered]

**Additional Context:**
[Any additional information]
```

### Pull Requests

**Before Starting:**
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Check if there's an existing issue/discussion

**Making Changes:**

1. **Keep it focused** - One feature/fix per PR
2. **Update documentation** - Update docs/ files if needed
3. **Add tests** - Include tests for new functionality
4. **Follow style** - Maintain consistency with existing code

**ZSH Code Style:**
```zsh
# Use function keyword explicitly
function my_function() {
  local var="value"
  # ...
}

# Or compact form
my_function() {
  # ...
}

# Use [[]] for conditionals (not [])
if [[ $var == "value" ]]; then
  # ...
fi

# Quote variables
"$var" not $var

# Use local for all function variables
local cache_dir="$HOME/.cache"
```

**Submitting a PR:**

1. Push to your fork
2. Open a Pull Request with:
   - Clear title describing change
   - Description of what/why
   - Link to related issue (if applicable)
   - Note any breaking changes

**PR Template:**
```markdown
## Description
[Brief description of changes]

## Motivation and Context
- Fixes #[issue number] or relates to #[issue number]
- [Why this change is needed]

## Testing
- [ ] Added tests
- [ ] Verified on macOS
- [ ] Verified on Linux
- [ ] Manual testing steps: [...]

## Checklist
- [ ] Code follows style guidelines
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings generated
```

## Development Setup

### Clone the Repository
```bash
git clone https://github.com/yourusername/easy-clone-cli.git
cd easy-clone-cli
```

### Install Locally for Testing
```bash
./setup.sh

# Or manually for development:
mkdir -p ~/.config/zsh
cp src/clone-completion.zsh ~/.config/zsh/
source ~/.config/zsh/clone-completion.zsh
```

### Run Tests
```bash
bash tests/test-clone.sh
```

### Manual Testing
```bash
# Test autocomplete
clone <TAB>

# Test clone function
clone dotfiles

# Test refresh
clone-refresh
```

## Project Structure

```
easy-clone-cli/
├── README.md                 # Main documentation
├── LICENSE                   # MIT license
├── setup.sh                  # Installation script
├── uninstall.sh              # Removal script
├── CONTRIBUTING.md           # This file
├── CODE_OF_CONDUCT.md        # Community guidelines
├── src/
│   └── clone-completion.zsh  # Main completion logic
├── docs/
│   ├── INSTALLATION.md       # Installation guide
│   ├── USAGE.md              # Usage examples
│   ├── TROUBLESHOOTING.md    # Troubleshooting guide
│   ├── ARCHITECTURE.md       # Technical architecture
│   └── CHANGELOG.md          # Version history
├── tests/
│   └── test-clone.sh         # Test suite
└── examples/
    └── .zshrc-snippet        # Example .zshrc additions
```

## Making Changes

### Key Files to Know

**src/clone-completion.zsh** (~110 lines)
- Main completion logic
- Cache management
- GitHub integration

**setup.sh** (Installer)
- Installation automation
- Configuration setup
- Verification

**docs/TROUBLESHOOTING.md**
- Known issues
- Solution procedures
- Diagnostic steps

### Example: Adding a Feature

1. **Create a branch**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make your changes**
   ```bash
   # Edit src/clone-completion.zsh
   nano src/clone-completion.zsh
   ```

3. **Test thoroughly**
   ```bash
   # Force reload
   exec zsh

   # Test the feature
   clone <TAB>
   ```

4. **Update documentation**
   ```bash
   # Update relevant docs
   nano docs/USAGE.md
   nano docs/ARCHITECTURE.md
   ```

5. **Add tests if applicable**
   ```bash
   # Update test suite
   nano tests/test-clone.sh
   ```

6. **Commit with clear message**
   ```bash
   git add .
   git commit -m "feat: Add cool new feature

   - Adds feature X
   - Maintains backward compatibility
   - Tested on macOS and Linux"
   ```

7. **Push and create PR**
   ```bash
   git push origin feature/my-feature
   # Then create PR on GitHub
   ```

## Commit Message Guidelines

Use clear, descriptive commit messages:

```
<type>: <subject>

<body>

<footer>
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `style:` - Code style (no logic change)
- `refactor:` - Code refactoring
- `test:` - Test additions/changes
- `chore:` - Build/dependency updates

**Examples:**
```
feat: Add support for multi-account cloning

- Allows specifying multiple GitHub accounts
- New clone-add-account command
- Maintains backward compatibility

Fixes #42
```

```
fix: Prevent file completion fallback

- Add zstyle for explicit completer
- Ensure _clone_complete returns proper codes
- Resolves issue where files showed in autocomplete

Fixes #15
```

## Testing Guidelines

### Before Submitting

Run the test suite:
```bash
bash tests/test-clone.sh
```

Test on multiple platforms if possible:
```bash
# macOS
zsh --version
./tests/test-clone.sh

# Linux
zsh --version
./tests/test-clone.sh

# WSL2
zsh --version
./tests/test-clone.sh
```

### Writing Tests

Tests are in `tests/test-clone.sh`. Example:

```bash
run_test "Test description" 'command to test'
# Example:
run_test "Clone function works" 'type clone &>/dev/null'
```

## Documentation Updates

When changing functionality, update:
1. **README.md** - If it affects overview/quick start
2. **docs/USAGE.md** - If it affects usage
3. **docs/TROUBLESHOOTING.md** - If it introduces new issues
4. **docs/ARCHITECTURE.md** - If it changes architecture
5. **docs/CHANGELOG.md** - Add to unreleased section

## Review Process

1. **Automated Checks**
   - Syntax validation
   - Test suite runs
   - Basic linting

2. **Code Review**
   - Maintainer review
   - Feedback/suggestions
   - Request changes if needed

3. **Approval & Merge**
   - Approved by maintainer
   - Merged to main
   - Added to next release

## Recognition

Contributors will be recognized in:
- CHANGELOG.md (first contribution or notable work)
- README.md (for substantial contributions)
- GitHub contributors page (automatic)

## Questions?

- 💬 Open a [discussion](https://github.com/yourusername/easy-clone-cli/discussions)
- 🐛 Open an [issue](https://github.com/yourusername/easy-clone-cli/issues)
- 📧 Contact maintainers (see GitHub profile)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make Easy Clone CLI better! 🎉
