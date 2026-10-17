#!/usr/bin/env bash
# Usage: sync-standards.sh <path-to-repo>
# Copies the shared standard files into a repo. Repo-specific files (README, LICENSE,
# preflight, the checklist in AGENTS.md) are left alone.
set -euo pipefail

src="$(cd "$(dirname "$0")/.." && pwd)"
dest="$(cd "${1:?usage: sync-standards.sh <path-to-repo>}" && pwd)"

mkdir -p "$dest/scripts/hooks" "$dest/.github/workflows"

cp "$src/lefthook.yml" "$src/commitlint.config.js" "$src/.editorconfig" "$src/.prettierrc" "$dest/"
cp "$src"/scripts/hooks/*.sh "$dest/scripts/hooks/"
cp "$src/templates/github/workflows/ci.yml" "$dest/.github/workflows/ci.yml"
cp "$src/templates/github/dependabot.yml" "$dest/.github/dependabot.yml"
cp "$src/templates/CODEOWNERS" "$dest/.github/CODEOWNERS"
[ -f "$dest/.nvmrc" ] || cp "$src/.nvmrc" "$dest/.nvmrc"

echo "Synced standards into $dest. Review the diff, then adapt AGENTS.md and preflight."
