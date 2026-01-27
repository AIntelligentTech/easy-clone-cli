# Output Patterns

## Colored Output

Use consistent color functions:

```bash
info()    { echo -e "${C_BBLUE}ℹ${C_RESET} $*"; }
success() { echo -e "${C_BGREEN}✓${C_RESET} $*"; }
warn()    { echo -e "${C_BYELLOW}⚠${C_RESET} $*" >&2; }
error()   { echo -e "${C_BRED}✗${C_RESET} $*" >&2; }
```

## Rules

- Send errors and warnings to stderr (`>&2`)
- Support `--json` flag for machine-readable output
- Support `--quiet` or `--silent` flags
- Use structured headers for sections
- Show progress for long operations
- Always show a summary at the end
- Check if output is a TTY before using colors: `[[ -t 1 ]]`
