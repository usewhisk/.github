# Contributing to Whisk

Thanks for helping. Whisk moves real money, so the bar is high and the process is
explicit.

## Before you start

- **Bugs:** open an issue with a reproduction, using the bug form.
- **Features and new chains:** open an issue first. Non-trivial changes need a decision
  record (an ADR pair) approved by the maintainer before code is written.
- **Security issues:** never in public. See [SECURITY.md](SECURITY.md).

## Setup

You need Node 22, pnpm 10 and gitleaks (`brew install gitleaks`). Then:

```bash
pnpm install
```

`pnpm install` also installs the git hooks. They format and check your staged files,
check your commit message, and run the preflight before you push.

## Branches and commits

- Branch from `main` as `<type>/<kebab-description>`, for example `fix/arc-gas-floor`.
  Types: feat, fix, docs, chore, refactor, test, ci, perf, build, release, revert.
- Never push to `main`. Every change lands through a pull request.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org):
  `fix(core): clamp maxFeePerGas on Arc`.
- No AI co-author trailers or "generated with" footers.

## Code rules

- **Bugs are fixed test first.** Add a failing test that reproduces the bug, then the
  fix.
- **No masking.** No silent `catch`, `@ts-ignore`, `@ts-nocheck` or `as any`, and no
  weakened tests.
- **Money is exact.** USDC amounts are `bigint` subunits until the display edge.
- **Comments are rare and human.** Explain why, never what. No em-dashes.

Each repository's `AGENTS.md` has the full rulebook.

## Pull requests

1. Run `./scripts/preflight.sh`. Every gate must pass with no warnings.
2. Fill in the pull request template.
3. CI runs the same gates. Only green pull requests are merged, and only by the
   maintainer.

## Code of conduct

Everyone taking part follows the [code of conduct](CODE_OF_CONDUCT.md).
