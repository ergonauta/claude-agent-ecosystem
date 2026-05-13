---
name: skill-self-review
description: Assemble a 5-persona review panel to evaluate staged diffs at gate G5. Dispatches qa-agent, security-agent, tech-lead-agent, architect-agent, and a stack specialist. Outputs a consolidated findings list with blocking/non-blocking classifications.
compatibility: Designed for Claude Code
metadata:
  type: Workflow — Orchestrator
  trigger: /self-review
  maturity: L1: Specified
---

## Purpose

Assemble a review panel of expert personas, dispatch the phase diff to each in
parallel, then write a single brief summary document for the human to read and act on.

The goal is not to validate — it is to find reasons to reject.

---

## Prerequisites

- Staged changes or diff against main available
- `implementation-plan.md` readable (review against original intent)
- `implementation-status.md` readable (current phase context)
- Stack detected during planning known (to select the right Senior Engineer)

---

## Review Panel

Five personas. Each reviews the diff independently from their role's perspective.

| Persona | Lens |
|---|---|
| **Senior [Stack] Engineer** | Correctness against ACs, idiomatic patterns, performance, framework-specific pitfalls. Stack-specific: invoke `/react-agent`, `/fastapi-agent`, etc. Fallback when no stack specialist exists: review from generic senior backend/frontend perspective based on `context/repo-context.md` stack field. |
| **Tech Lead** (`/tech-lead-agent`) | Scope adherence to plan, cross-cutting concerns, delivery risk, anything that blocks the next phase |
| **Architect** (`/architect-agent`) | Boundary violations, coupling introduced, structural regressions, decisions that should have been ADRs |
| **QA Engineer** (`/qa-agent`) | Test coverage against ACs; edge cases missing; whether passing tests give real confidence. Reviews behaviour, not implementation details. Flags gaps only — does not write tests. |
| **Security Engineer** (`/security-agent`) | OWASP Top 10; auth gaps; injection vectors; data exposure; unvalidated inputs. Severity tiers: Critical/High → blocking, Medium → should-fix, Low → note. |

---

## Diff Size Handling

Before dispatching, measure the diff:

```
git diff --stat HEAD | tail -1   # shows insertions/deletions
```

| Diff size | Strategy |
|-----------|----------|
| ≤ 500 lines changed | Dispatch all 5 personas in parallel (default) |
| > 500 lines changed | Split by file area: group changed files by directory or concern, run each group as a sub-diff. Dispatch personas per group sequentially. Note the split in the summary header. |

The threshold applies to non-test lines. Large test files alone do not trigger sequential mode.

---

## Behaviour

### Step 1 — Dispatch in parallel (or split if large diff)

Send the diff and phase context to all five personas simultaneously.
Each returns CC-formatted findings (see Comment Format below).

For large diffs (>500 lines): split into file-area sub-diffs, run each group through the full panel sequentially, then consolidate all findings into one summary.

### Step 2 — Consolidate and summarise

Read all findings. Write a single summary document to `self-review-phase-N.md`
in the project root. The summary must be brief — the human reads this one file,
not individual agent outputs.

Rules for the summary:
- **Do not pad.** If a reviewer found nothing, omit them from the summary.
- **Do not duplicate.** If two personas flag the same issue, merge into one item and note both sources.
- **Do not soften.** Report what was found. No editorial filter.
- **Prioritise by severity.** Blocking items first, then non-blocking, then notes/praise.
- **One line per finding** in the summary. Discussion only if the fix is non-obvious.

### Step 3 — Present summary path and G5 gate

Tell the human where the summary was written. Present G5.

---

## Comment Format — Conventional Comments

All findings use Conventional Comments format:

```
<label> [decorations]: <subject>

[discussion]
```

**Labels:**

| Label | Blocking by default? | Use for |
|---|---|---|
| `issue` | Yes | Specific problems — user-facing or behind the scenes |
| `todo` | Yes | Small, necessary changes |
| `chore` | Yes | Process tasks required before acceptance |
| `suggestion` | Depends on decoration | Improvements — be explicit about what and why |
| `question` | No | Potential concern, not sure if relevant |
| `nitpick` | No | Trivial preference |
| `thought` | No | Non-blocking idea from reviewing |
| `note` | No | Highlight something, no action required |
| `praise` | N/A | Genuine positive — at least one per review |

**Decorations:**

| Decoration | Meaning |
|---|---|
| `(blocking)` | Must resolve before commit |
| `(non-blocking)` | Should not prevent acceptance |
| `(if-minor)` | Resolve only if change is trivial |
| `(security)` | Security domain |
| `(test)` | Test quality domain |
| `(perf)` | Performance domain |
| `(arch)` | Architectural domain |

---

## Summary Document Format

File: `self-review-phase-N.md` (written by the orchestrator, not by individual agents)

```markdown
# Self Review — Phase N: [Phase Name]
**Date:** [date]
**Reviewers:** Senior [Stack] Engineer, Tech Lead, Architect, QA Engineer, Security Engineer

## Must Resolve
<!-- issue/todo/chore with (blocking) decoration -->

- `issue (blocking, security)` `auth/login.ts:42` — JWT not validated on refresh *(Security Engineer)*
- `issue (blocking)` `api/users.ts:18` — N+1 query on user list fetch *(Senior Engineer)*

## Should Consider
<!-- suggestions, questions, non-blocking items — only include if actionable -->

- `suggestion (non-blocking)` `components/Form.tsx:67` — extract validation to hook *(Senior Engineer)*
- `question` `api/users.ts:30` — is pagination needed here or deferred? *(Tech Lead)*

## Notes
<!-- praise, thoughts, notes — keep to 1–3 items max -->

- `praise` Happy path test coverage is solid *(QA Engineer)*
- `note` Consider adding metrics for this endpoint as follow-up *(Tech Lead)*
```

If "Must Resolve" is empty, write `None.` and say so explicitly — do not omit the section.

---

## Gate G5

```
GATE G5: Self Review Approval — Phase [N]
Status: AWAITING APPROVAL

Summary written to: self-review-phase-N.md
Reviewers: Senior [Stack] Engineer · Tech Lead · Architect · QA Engineer · Security Engineer

Must Resolve: [N items]
Should Consider: [N items]

For each Must Resolve item:
- Fix it, OR
- Accept it explicitly: "accepting [item] — [reason]"

Questions must be answered before approval.

To approve: respond "APPROVED"
To request changes: respond with which items need resolution
```

After approval: update `implementation-status.md` Gate G5 → ✅ APPROVED.

---

## Behavioural Tests

See `tests/behaviours/skill-self-review.behaviour.md`.
