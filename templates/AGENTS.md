# Engineering Standards & AI Governance Rulebook

All AI coding agents (Claude Code, Codex, Antigravity, Qwen Code, and custom LLM dev
harnesses) operating in this repository MUST abide by the rules and lifecycle in this
document.

Whisk moves real money. A wrong amount, a wrong domain, or a burn without a mint is a
loss for a real person. Every rule below exists because of that.

---

## Core Mandatory AI Governance Directives

### Directive 1: Read-Only Long-Lived Branches & Mandatory Worktree Isolation

Direct commits or pushes to `main` are strictly forbidden for all AI agents. `main` is
the only long-lived branch.
All feature development, refactoring, and bug fixing MUST be conducted in isolated Git
worktrees created off `origin/main`, using `git worktree add`.
AI agents must never assume a local long-lived branch is current without explicitly
syncing ground truth.

### Directive 2: Human Approval Gate (Phase 1 DECIDE)

AI agents are strictly prohibited from implementing non-trivial features,
architectural changes, or framework modifications without authoring TWO Architectural
Decision Records under `docs/adr/`:

1. Technical ADR (`docs/adr/ADR-<YYYY-MM-DD>-<topic>.md`): full technical
   specification covering context, decision, architectural impact, trade-offs, and
   a component or sequence diagram.
2. Simplified Companion ADR (`docs/adr/ADR-<YYYY-MM-DD>-<topic>-for-dummies.md`):
   plain-English context, decision, and impact for non-technical stakeholders.

- An AI agent is strictly forbidden from approving its own ADRs or implementation plan.
- Execution MUST NOT begin until explicit, unambiguous human approval is granted on
  both ADR documents. Silence is not approval. A question about the ADR is not approval.

### Directive 3: Red-Green Test-First Bug Fixing Protocol

When addressing any bug, regression, or defect, the AI agent MUST follow this order:

1. Red: write a failing unit or integration test that reproduces the defect. Run it
   and confirm it fails for the exact reason identified.
2. Green: implement the minimal production fix. Re-run and confirm clean passage with
   no secondary regressions.

### Directive 4: Prohibition of Error Swallowing & Symptom Masking

AI agents are forbidden from resolving build errors, type errors, or test failures by
masking them:

- Do NOT wrap failing operations in silent `try/catch` blocks or empty catch handlers.
- Do NOT bypass type checks with `@ts-ignore`, `@ts-nocheck`, or loose `any` casts.
- Do NOT return dummy, empty, or fallback objects to hide missing data or broken upstreams.
- Do NOT comment out, weaken, or delete failing assertions or test cases.
- Do NOT raise a budget, a timeout, or a threshold to make a gate pass. Fix the cause.

### Directive 5: Local Preflight Verification Enforcement

Before submitting any Pull Request or marking a task complete, the AI agent MUST run
`./scripts/preflight.sh`. Every gate the repository defines must complete with zero
warnings and zero errors. A gate that passes only when
run alone does not count; the full run is the verdict.

### Directive 6: Human Comments Only

No AI-written comments anywhere in the project: source, tests, config, workflows,
scripts, or docs.

- Default to no comment. Add one only when the code cannot say it: why a choice was
  made, a protocol quirk, a non-obvious constraint.
- Every comment reads as if a careful human engineer wrote it by hand: plain English,
  short, specific to this line of code.
- No narration of what the code plainly does, no restating the function name, no
  section banners, no "Note:" or "Important:" filler, no em-dashes.
- No references to the agent, the session, the prompt, or the change history
  ("added for the refactor", "now uses", "previously"). History belongs in git.
- No AI co-author trailers or session footers in commits or pull requests.

---

## Git Hooks

`pnpm install` installs lefthook. The hooks are part of the gate, not a convenience:

- `pre-commit`: formatting, gitleaks, no em-dashes, no `@ts-ignore`, `@ts-nocheck` or
  `as any`.
- `commit-msg`: Conventional Commits, no AI trailers.
- `pre-push`: no push to `main`, `<type>/<kebab-description>` branch names, fast
  preflight.

AI agents never pass `--no-verify`, never edit a hook to get past it, and never
disable one. A failing hook is fixed at its cause.

---

## Multi-Stage Development Lifecycle (Phases 0-8)

```
[Phase 0: SYNC] --> [Phase 1: DECIDE] --> [Phase 2: PLAN]
                                                |
[Phase 5: BUILD] <-------------- [Phase 3: ISOLATE]
       |
       v
[Phase 6: VERIFY] --> [Phase 7: DOCUMENT] --> [Phase 8: DELIVER]
```

### Phase 0: SYNC

`git fetch origin main`. Never rely on a stale local ref.

### Phase 1: DECIDE

For non-trivial work, author both ADRs, present them, and pause until the human
approves. Trivial work (a typo, a copy change, a one-line fix with a regression test)
skips this phase; when unsure, it is not trivial.

### Phase 2: PLAN

`docs/plans/<date>-<feature>-plan.md`: component boundaries, interface contracts,
state changes, test strategy, and UI mockups where relevant.

### Phase 3: ISOLATE

`git worktree add .worktrees/<branch-name> -b <branch-name> origin/main`, then
`pnpm install` inside the worktree.

### Phase 5: BUILD

Test-driven implementation inside the layering rules in this repository's checklist.

### Phase 6: VERIFY

`./scripts/preflight.sh`, then run the affected app, page or example and exercise the
flow by hand, on testnet where money moves, including the edge cases the ADR named.

### Phase 7: DOCUMENT

A release note where the repository requires one, and a changeset for any change to a
published package. Docs that describe the changed behaviour are updated in the same
pull request.

### Phase 8: DELIVER

Open the PR against `main`, using the pull request template. All CI checks green
before requesting review. Only the maintainer merges.
