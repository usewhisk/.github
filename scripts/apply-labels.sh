#!/usr/bin/env bash
# Usage: apply-labels.sh <owner/repo>
set -euo pipefail

repo="${1:?usage: apply-labels.sh <owner/repo>}"

while IFS='|' read -r name color description; do
  gh label create "$name" --repo "$repo" --color "$color" --description "$description" --force
done <<'LABELS'
phase-1-foundation|1d76db|Phase 1: engine fixes, registry, Arc, release
phase-2-platform|5319e7|Phase 2: API, auth, dashboard, admin, stats
phase-3-distribution|0e8a16|Phase 3: React Native, elements, checkout, Business API
phase-4-pay-with-anything|fbca04|Phase 4: swap, exact amounts, offramp interface
phase-5-revenue|d93f0b|Phase 5: plans, billing, fee share, audit
phase-6-reach|006b75|Phase 6: Sui, Aptos, social wallets, Earn
later|c5def5|Planned, needs its own ADR first
adr|000000|Needs or is an ADR pair
bug|d73a4a|Something is broken
feature|a2eeef|New capability
docs|0075ca|Documentation
chore|cfd3d7|Maintenance
security|b60205|Security issue or hardening
dependencies|0366d6|Dependency updates
fund-safety|b60205|Could lose, lock or misprice funds
main-broken|b60205|main took a push that skipped the gates
good first issue|7057ff|Good for newcomers
LABELS
