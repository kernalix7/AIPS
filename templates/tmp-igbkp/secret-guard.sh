#!/usr/bin/env bash
# AIPS v6.0 toolkit — copied by /aips:init to project tmp-igbkp/
###############################################################################
# secret-guard.sh — Block commits that contain inline secrets (v6.0).
###############################################################################
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
while [[ "$PROJECT_ROOT" != "/" ]]; do
    [[ -d "$PROJECT_ROOT/.git" ]] && break
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done
cd "$PROJECT_ROOT"

GREEN=''; RED=''; YELLOW=''; NC=''
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'
fi

if [[ "${1:-}" == "--install-hook" ]]; then
    HOOK="$PROJECT_ROOT/.git/hooks/pre-commit"
    if [[ -f "$HOOK" ]] && ! grep -q "secret-guard.sh" "$HOOK"; then
        echo -e "${YELLOW}[warn]${NC} pre-commit exists at $HOOK"
        echo "  Add: \"$SCRIPT_DIR/secret-guard.sh\" || exit 1"
        exit 1
    fi
    cat > "$HOOK" <<EOF
#!/usr/bin/env bash
"$SCRIPT_DIR/secret-guard.sh" || exit 1
EOF
    chmod +x "$HOOK"
    echo -e "${GREEN}[OK]${NC} Installed: $HOOK"
    exit 0
fi

SCAN_ALL=false
[[ "${1:-}" == "--all" ]] && SCAN_ALL=true

if [[ "$SCAN_ALL" == true ]]; then
    FILES=$(git ls-files 2>/dev/null)
else
    FILES=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null)
fi

[[ -z "$FILES" ]] && { echo "Nothing to scan."; exit 0; }

declare -a PATTERNS=(
    'AKIA[0-9A-Z]{16}|AWS Access Key (AKIA)'
    'ASIA[0-9A-Z]{16}|AWS Temp Key (ASIA)'
    'sk-proj-[A-Za-z0-9_-]{20,}|OpenAI Project Key'
    'sk-[A-Za-z0-9]{32,}|OpenAI API Key (legacy)'
    'ghp_[A-Za-z0-9]{36}|GitHub PAT'
    'ghs_[A-Za-z0-9]{36}|GitHub Server Token'
    'gho_[A-Za-z0-9]{36}|GitHub OAuth'
    'glpat-[A-Za-z0-9_-]{20,}|GitLab PAT'
    'xox[abprs]-[A-Za-z0-9-]{10,}|Slack Token'
    'sk_live_[A-Za-z0-9]{24,}|Stripe Live Secret'
    'rk_live_[A-Za-z0-9]{24,}|Stripe Live Restricted'
    'AIza[0-9A-Za-z_-]{35}|Google API Key'
    '-----BEGIN (RSA|OPENSSH|EC|DSA|PGP) PRIVATE KEY-----|Private Key'
    'eyJ[A-Za-z0-9_-]{20,}\.eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}|JWT'
)

VIOLATIONS=0
for f in $FILES; do
    [[ -f "$f" ]] || continue
    file "$f" 2>/dev/null | grep -q "binary" && continue
    SIZE=$(wc -c < "$f" 2>/dev/null || echo 0)
    [[ "$SIZE" -gt 1048576 ]] && continue
    [[ "$f" == *"secret-guard.sh" ]] && continue

    for entry in "${PATTERNS[@]}"; do
        REGEX="${entry%|*}"
        LABEL="${entry##*|}"
        MATCHES=$(grep -nE "$REGEX" "$f" 2>/dev/null | grep -vE '(#|//)[[:space:]]*secret-guard:ignore' || true)
        if [[ -n "$MATCHES" ]]; then
            ((VIOLATIONS++))
            echo -e "${RED}[BLOCKED]${NC} $f — $LABEL"
            echo "$MATCHES" | head -3 | sed 's/^/    /'
            echo "  (Allow with: # secret-guard:ignore)"
            echo
        fi
    done

    if [[ "$f" == ".mcp.json" || "$f" == */mcp.json ]]; then
        BAD=$(grep -nE '"(token|key|secret|password|api_key|apiKey)"[[:space:]]*:[[:space:]]*"[^$"][^"]+"' "$f" 2>/dev/null || true)
        if [[ -n "$BAD" ]]; then
            ((VIOLATIONS++))
            echo -e "${RED}[BLOCKED]${NC} $f — Inline secret in .mcp.json (use \${ENV_VAR})"
            echo "$BAD" | head -3 | sed 's/^/    /'
            echo
        fi
    fi
done

if [[ "$VIOLATIONS" -eq 0 ]]; then
    echo -e "${GREEN}[OK]${NC} No secrets detected."
    exit 0
else
    echo -e "${RED}BLOCKED — $VIOLATIONS secret pattern(s) found${NC}"
    exit 1
fi
