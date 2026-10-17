# usewhisk/.github

The organization profile, community health files and shared tooling for every
repository in the [`usewhisk`](https://github.com/usewhisk) org.

## What lives here

| Path                                                                 | Purpose                                                                      |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `profile/README.md`                                                  | The profile shown on the org page                                            |
| `SECURITY.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SUPPORT.md` | Defaults GitHub applies to every org repo without its own copy               |
| `.github/ISSUE_TEMPLATE/`, `.github/pull_request_template.md`        | Default issue forms and PR template                                          |
| `.github/workflows/quality.yml`                                      | Reusable gate: tools, install, `./scripts/preflight.sh`, audit               |
| `.github/workflows/secrets.yml`                                      | Reusable gitleaks scan over the new commits                                  |
| `.github/workflows/commits.yml`                                      | Reusable commitlint over the PR title and commits, plus the AI trailer check |
| `.github/workflows/main-guard.yml`                                   | Reusable alarm for private repos: opens a `main-broken` issue on a bad push  |
| `lefthook.yml`, `commitlint.config.js`, `scripts/hooks/`             | The canonical git hooks                                                      |
| `templates/`                                                         | Files copied into each repo                                                  |
| `scripts/sync-standards.sh`                                          | Copies the standard files into a repo                                        |
| `scripts/apply-labels.sh`                                            | Applies the shared label set to a repo                                       |

## Using the standards in a repo

```bash
./scripts/sync-standards.sh ../whisk
./scripts/apply-labels.sh usewhisk/whisk
```

The target repo then needs `lefthook`, `@commitlint/cli`,
`@commitlint/config-conventional` and `prettier` as dev dependencies, a
`"prepare": "lefthook install"` script, and its own `scripts/preflight.sh`.

## Local setup

Requires Node 22, pnpm 10, and `brew install gitleaks shellcheck actionlint`.

```bash
pnpm install
pnpm preflight
```

## The hooks

| Hook         | Checks                                                                                                          |
| ------------ | --------------------------------------------------------------------------------------------------------------- |
| `pre-commit` | Prettier on staged files, gitleaks on the staged diff, no em-dashes, no `@ts-ignore`, `@ts-nocheck` or `as any` |
| `commit-msg` | Conventional Commits, no AI co-author trailers or "generated with" footers                                      |
| `pre-push`   | No push to `main`, `<type>/<kebab-description>` branch names, `./scripts/preflight.sh --fast`                   |

The decision record is
[ADR-2026-10-16-repo-standards-and-local-gates](https://github.com/usewhisk/whisk/blob/main/docs/adr/ADR-2026-10-16-repo-standards-and-local-gates.md).

## License

MIT
