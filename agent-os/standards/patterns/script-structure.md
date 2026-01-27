# Script Structure Patterns

## Template

```bash
#!/usr/bin/env bash
# =============================================================================
# script-name - Brief description
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source shared libraries
source "$SCRIPT_DIR/../lib/core.sh"

# --- Configuration ---
VERBOSE=false
DRY_RUN=false

# --- Help ---
show_help() { ... }

# --- Argument Parsing ---
parse_args() { ... }

# --- Functions ---
do_work() { ... }

# --- Main ---
main() {
    parse_args "$@"
    validate
    do_work
}

main "$@"
```

## Rules

- Always use `set -euo pipefail`
- Use `|| true` for arithmetic expressions that might evaluate to 0
- Quote all variable expansions: `"$var"`, not `$var`
- Use `local` for function variables
- Provide `--help` and `--dry-run` flags
- Default to safe operations (dry-run) for destructive commands
- Source shared libraries from `lib/` directory
