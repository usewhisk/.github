#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
hooks="$root/scripts/hooks"
failures=0

expect() {
  local want="$1" name="$2"
  shift 2
  if "$@" >/dev/null 2>&1; then got=0; else got=1; fi
  if [ "$got" = "$want" ]; then
    echo "ok   $name"
  else
    echo "FAIL $name (exit $got, wanted $want)"
    failures=$((failures + 1))
  fi
}

repo="$(mktemp -d)"
trap 'rm -rf "$repo"' EXIT
cd "$repo"
git init -q
git config user.email test@example.com
git config user.name test
git config commit.gpgsign false
git commit -q --allow-empty -m "chore: init"

printf 'const a = 1;\n' > clean.ts
printf 'const b = 2; \xe2\x80\x94 oops\n' > dash.md
printf '// @ts-ignore\nconst c = 3;\n' > ignore.ts
printf 'const d = x as any;\n' > any.ts
printf 'const e = "as any" + y;\n' > words.md
git add .

expect 0 "clean file passes" "$hooks/check-added-lines.sh" clean.ts
expect 1 "em-dash is blocked" "$hooks/check-added-lines.sh" dash.md
expect 1 "ts-ignore is blocked" "$hooks/check-added-lines.sh" ignore.ts
expect 1 "as any is blocked" "$hooks/check-added-lines.sh" any.ts
expect 0 "as any in markdown is allowed" "$hooks/check-added-lines.sh" words.md

token="ghp_$(openssl rand -hex 18)"
printf 'export const token = "%s";\n' "$token" > leak.ts
git add leak.ts
expect 1 "staged secret is blocked" "$hooks/secrets.sh"
git rm -q --cached leak.ts
rm leak.ts
expect 0 "no secret passes" "$hooks/secrets.sh"

msg="$(mktemp)"
printf 'feat: add thing\n\nCo-Authored-By: Claude <noreply@anthropic.com>\n' > "$msg"
expect 1 "claude trailer is blocked" "$hooks/no-ai-trailer.sh" "$msg"
printf 'fix: thing\n\nGenerated with [Claude Code](https://claude.com/claude-code)\n' > "$msg"
expect 1 "generated footer is blocked" "$hooks/no-ai-trailer.sh" "$msg"
printf 'fix: thing\n\nCo-Authored-By: Ada <ada@example.com>\n' > "$msg"
expect 0 "human co-author is allowed" "$hooks/no-ai-trailer.sh" "$msg"
rm -f "$msg"

sha=1111111111111111111111111111111111111111
zero=0000000000000000000000000000000000000000
push() { printf '%s\n' "$1" | "$hooks/check-push-refs.sh"; }
expect 1 "push to main is blocked" push "refs/heads/x $sha refs/heads/main $zero"
expect 1 "bad branch name is blocked" push "refs/heads/wip $sha refs/heads/wip $zero"
expect 0 "good branch name passes" push "refs/heads/fix/arc-gas $sha refs/heads/fix/arc-gas $zero"
expect 0 "branch delete passes" push "(delete) $zero refs/heads/old-name $sha"

if [ "$failures" -gt 0 ]; then
  echo "$failures hook test(s) failed"
  exit 1
fi
echo "All hook tests passed."
