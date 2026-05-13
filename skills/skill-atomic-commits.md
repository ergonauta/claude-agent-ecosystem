# Skill: /atomic-commits

> **Type:** Workflow  
> **Trigger:** `/atomic-commits`  
> **Maturity:** L1: Specified
> **Status:** SPECIFIED — behavioural tests written; not yet human-verified

---

## Purpose

Review proposed commits for Conventional Commits compliance and message quality.
Propose or validate commit message content before execution.

**Note:** Per ADR 0003, commits should be made *during* implementation at each sub-step,
not retroactively after the full phase. This skill validates those commits — it does not
retroactively split a large diff.

---

## When This Skill Runs

Two contexts:

**A) During GREEN phase (sub-step commits)**
After each sub-step within a phase, Claude proposes a commit message before executing.
This skill defines the format and quality bar for those proposals.

**B) Gate G6 (commit review)**
Before the human approves the final commit set for a phase, this skill does a final
pass to ensure all commits in the phase are well-formed.

---

## Conventional Commits Format

Full structure (v1.0.0 spec):

```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Use for | SemVer |
|---|---|---|
| `feat` | New feature or behaviour | MINOR |
| `fix` | Bug fix | PATCH |
| `test` | Adding or modifying tests — RED phase commits use this | — |
| `refactor` | Code change that neither fixes a bug nor adds a feature | — |
| `docs` | Documentation only | — |
| `chore` | Maintenance, dependency updates, configuration | — |
| `perf` | Performance improvement | — |
| `style` | Formatting, whitespace — no logic change | — |
| `ci` | CI/CD config changes | — |
| `build` | Build system or tooling changes | — |

`feat` MUST be used for new features. `fix` MUST be used for bug fixes.
Other types MAY be used freely.

### Breaking changes

Two valid forms — both are acceptable:

```
feat(api)!: remove deprecated endpoint

BREAKING CHANGE: /v1/users endpoint removed. Use /v2/users.
```

```
feat!: drop support for Node 16
```

Rules:
- `BREAKING CHANGE` in footer MUST be uppercase
- `BREAKING CHANGE:` in footer and `!` in prefix MAY both be used together
- `BREAKING CHANGE` and `BREAKING-CHANGE` are synonymous as footer tokens

### Scope

Optional. A noun describing the section of the codebase, in parentheses:
`feat(auth):`, `fix(parser):`, `test(api):`

### Rules — description line

- MUST immediately follow the type/scope colon and space
- Imperative mood: "add token validation" not "added token validation"
- Under 72 characters
- No trailing period
- Specific: "add expiry check to JWT middleware" not "update auth"

### Rules — body

- MAY be provided; MUST begin one blank line after the description
- Explain *why*, not *what* — the diff shows what
- Wrap at 72 characters

### Rules — footers

- MAY be provided one blank line after body
- Token MUST use `-` in place of whitespace (exception: `BREAKING CHANGE`)
- Format: `Token: value` or `Token #value`
- MUST always include: `Refs: implementation-plan.md Phase N`
- MUST include `BREAKING CHANGE: <description>` if the commit introduces a breaking change

### Examples

```
test(auth): add failing tests for JWT expiry validation

Refs: implementation-plan.md Phase 1
```

```
feat(auth): implement JWT expiry check in middleware

Guard against tokens with exp claim in the past. Returns 401
with WWW-Authenticate header on failure.

Refs: implementation-plan.md Phase 1
```

```
feat(api)!: remove /v1/users endpoint

BREAKING CHANGE: endpoint removed after deprecation period.
Consumers must migrate to /v2/users.

Refs: implementation-plan.md Phase 3
```

---

## Sub-step Commit Proposal Format

During GREEN phase, before each sub-step commit, Claude presents:

```
Proposed commit for sub-step [N]:

  <type>(<scope>): <description>

  [body if needed]

  Refs: implementation-plan.md Phase N

Staged changes summary:
  [brief list of what's in the diff]

To approve: respond "COMMIT" or "COMMIT — [modifications]"
To revise: respond with the change needed
```

Claude does not execute the commit until the human responds.

---

## Gate G6 — Final Commit Review

After self-review approval, present all phase commits for final review:

```
GATE G6: Commit Approval
Status: AWAITING APPROVAL

Commits for Phase N:

  1. test(auth): add failing tests for JWT expiry validation
     Refs: implementation-plan.md Phase 1

  2. feat(auth): implement JWT expiry check in middleware
     Refs: implementation-plan.md Phase 1

  3. feat(auth): add expiry error response formatting
     Refs: implementation-plan.md Phase 1

To approve: respond "APPROVED"
To revise: specify which commit needs changes
```

---

## Multi-File Cross-Concern Commits

When a sub-step touches files from multiple logical concerns (e.g., a model change that
also requires a migration and a route update):

- **Prefer splitting** — three commits: `chore(db): add migration`, `feat(model): add field`, `feat(api): expose field on route`
- **Merge only if inseparable** — if the three changes are atomic (all pass or all fail), one commit is acceptable. Justify this in the body.

Rule: a commit must be reversible without breaking other commits in the sequence. If reverting one commit breaks another, split them.

---

## Merge and Rebase Scenarios

This skill does not handle merge conflicts or rebase operations. When a merge or
rebase is needed:

1. Abort the commit proposal.
2. Tell the human: "Resolve the merge/rebase first, then re-run `/atomic-commits`."
3. Do not attempt to auto-resolve conflicts or amend history.

---

## Behavioural Tests

See `tests/behaviours/skill-atomic-commits.behaviour.md`.
