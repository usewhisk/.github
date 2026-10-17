#!/usr/bin/env bash
set -euo pipefail

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
command -v mise >/dev/null 2>&1 && eval "$(mise activate bash --shims)"

need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "preflight: $1 is not installed. Install it with 'brew install $1'." >&2
    exit 1
  fi
}
need shellcheck
need actionlint
need gitleaks

echo "=== Preflight ==="
echo "[1/3] Format"
pnpm exec prettier --check .
echo "[2/3] Lint"
shellcheck scripts/*.sh scripts/hooks/*.sh test/*.sh
actionlint
echo "[3/3] Tests"
bash test/hooks.test.sh
echo "All preflight gates passed."
