# Workflow — High Level

## Overview

The implementation workflow moves a feature from a written specification through
phased test-driven delivery, with explicit human approval gates at every critical
transition. A feature is broken into phases (e.g. API layer, data model, UI page).
Each phase goes through the full RED → GREEN → SELF-REVIEW → COMMIT loop before
the next phase begins. One PR is opened at the end, covering all phases.

```
FEATURE SPEC
  → PLANNING → [G1]
  → ┌─────────────────────────────────────────────────────┐
    │  For each phase:                                    │
    │  RED → [G3] → GREEN → [G4] → SELF-REVIEW → [G5]   │
    │    → COMMIT → [G6]                                  │
    │                │                                    │
    │    spec gap?   └→ PLAN REVISION → [G1-R] → RED     │
    └─────────────────────────────────────────────────────┘
  → PR → [G7]
```

---

## Stages

### Stage 1 — Feature Spec

**Owner:** Human
**Output:** `feature-spec.md` (written from template before planning begins)

The human writes the feature description in their own words before any planning
session starts. The spec can reference any source — ADRs, Jira tickets, tech
documents, conversations — but must be consolidated into a single document.

This is not a formal PRD. It is the human's honest account of what needs to exist
and why. Completeness matters more than polish.

**Done when:** Human considers the spec complete enough to hand to Claude for planning.

---

### Stage 2 — Planning

**Owner:** Human (with Claude as challenger)
**Output:** `implementation-plan.md` + `implementation-status.md`

Claude reads `feature-spec.md` and `context/repo-context.md`, then works through
four steps before producing the plan:

**Step 1 — Stack detection**
Claude identifies the tech stack from `repo-context.md` (e.g. React, FastAPI,
Next.js, Django) and notes which specialist agents apply to this feature.
Specialist agents are invoked as sub-agents during planning to validate
phase scope and surface stack-specific risks.

Available specialist agents (invoke as relevant):

- `/react-agent` — React / Next.js component and state architecture
- `/fastapi-agent` — FastAPI route, schema, and dependency design
- `/tech-lead-agent` — cross-cutting architectural concerns
- `/architect-agent` — system design, integration boundaries, data flow

If no specialist agent exists for the detected stack, Claude proceeds without one
and flags the gap in the plan.

**Step 2 — Spec challenge**
The spec is challenged from multiple expert lenses before Claude consolidates findings.
Each relevant agent (identified in Step 1) reviews `feature-spec.md` independently:

- **Stack specialist(s)** — challenge from implementation reality: are the described
  behaviours achievable with this stack? Are there missing constraints specific to
  the framework (auth patterns, rendering boundaries, async limits)?
- **`/tech-lead-agent`** — challenge from delivery: are phases implicit in the spec
  actually sequenceable? Are there shared concerns that must be resolved before any
  phase begins?
- **`/architect-agent`** — challenge from system design: does the spec respect existing
  service boundaries? Does it introduce coupling or data flow that conflicts with the
  current architecture?

Claude consolidates all agent challenges into a single structured list, presents it
to the human, and does not proceed to phase breakdown until every challenge is
resolved or explicitly accepted.

The plan is not written _for_ Claude. It is written by the human, forced to think
precisely about what they want. The agents are the adversaries that find the holes.

**Step 3 — Phase breakdown and PR grouping**
Claude proposes a phase breakdown and, as part of the same step, identifies natural
PR boundaries by concern — not by size alone.

Phases are grouped into PRs by asking: _what can be merged and used independently,
before the rest of the feature exists?_

Natural PR boundaries emerge from concern separation:

- **Generic/shared layer** — reusable components, utilities, data structures with
  no feature-specific knowledge. These can be merged first and used by other features.
- **Domain/data layer** — business logic, data manipulation, parsing, transformations
  that depend on the generic layer but not on the UI integration.
- **Integration layer** — the feature-specific assembly: wiring generic components
  with domain logic, routing, page composition.

Example: a card feature with accordion, table, and triple hash map parser becomes:

```
PR 1 — Generic components: Card, Header, Divider, Accordion, Table
PR 2 — Data layer: triple hash map parser + table data adapter
PR 3 — Integration: feature page wiring everything together
```

Each phase within a PR goes through its own RED → GREEN → SELF-REVIEW → COMMIT loop.
PRs are opened in dependency order. If the feature fits in one PR, no stacking needed.

Claude invokes `/stacked-branches` to formalise the branching plan whenever more
than one PR is identified. This happens during planning, before G1 — not reactively
after implementation reveals the scope was too large.

**[G1: Plan Approval]**

```
GATE G1: Plan Approval
Status: AWAITING APPROVAL

Stack detected: [stack name]
Specialist agents consulted: [list or "none"]
Branching strategy: [single PR | stacked — see stacked-branches plan]

Checklist:
- [ ] All acceptance criteria are specific and testable
- [ ] Out-of-scope items are explicitly listed
- [ ] Failure modes are documented
- [ ] Phase breakdown is appropriately granular
- [ ] Risks and open questions are captured
- [ ] PR strategy is appropriate for the scope

To approve: respond "APPROVED"
To request changes: respond with what needs to change
```

**Done when:** Human approves. `implementation-plan.md` is read-only from this point,
except via `/plan-revision`.

---

### Stage 3 — RED (Test Writing) — per phase

**Owner:** Claude (guided by the plan)
**Output:** Failing tests covering the current phase's acceptance criteria

Claude translates each acceptance criterion for the current phase into tests written
to fail. Tests are the executable version of the spec. If the tests are wrong,
the implementation will be wrong.

**[G3: RED Approval]**

```
GATE G3: RED Approval — Phase [N]
Status: AWAITING APPROVAL

Checklist:
- [ ] Every acceptance criterion for this phase has at least one test
- [ ] Edge cases and failure modes are covered
- [ ] Test descriptions are human-readable and match intent
- [ ] No test checks implementation details — behaviour only
- [ ] Tests run and fail for the right reason

To approve: respond "APPROVED"
To reject: respond "REJECTED — [reason]"
```

**Done when:** Human approves the RED tests.

---

### Stage 4 — GREEN (Implementation) — per phase

**Owner:** Claude
**Output:** Working implementation that makes all RED tests pass

Claude implements the minimum code required to make the tests pass. No more.
Implementation follows conventions in `repo-context.md`.

**[G4: GREEN Approval]**

```
GATE G4: GREEN Approval — Phase [N]
Status: AWAITING APPROVAL

Checklist:
- [ ] All RED tests now pass
- [ ] No existing tests were broken
- [ ] Implementation matches the plan (not a creative interpretation of it)
- [ ] No scope creep

To approve: respond "APPROVED"
To reject: respond "REJECTED — [reason]"
```

**Done when:** Human approves the GREEN implementation.

---

### Stage 5 — Self Review — per phase

**Owner:** Claude (`/self-review` skill — orchestrator)
**Output:** `self-review-phase-N.md` — a single brief summary document

`/self-review` assembles a five-person review panel, dispatches the diff to each
in parallel, then writes one summary document. The human reads that one file —
not individual agent outputs.

| Persona                 | Lens                                                                      |
| ----------------------- | ------------------------------------------------------------------------- |
| Senior [Stack] Engineer | Correctness, idiomatic patterns, performance, framework-specific pitfalls |
| Tech Lead               | Scope adherence, cross-cutting concerns, delivery risk                    |
| Architect               | Boundary violations, coupling, structural regressions                     |
| QA Engineer             | Test coverage, edge cases, whether tests give real confidence             |
| Security Engineer       | OWASP top 10, auth, injection, data exposure                              |

Findings use **Conventional Comments** format: `issue (blocking)`, `suggestion`,
`question`, `praise`, etc. Summary is prioritised: Must Resolve → Should Consider → Notes.

**[G5: Self Review Approval]**

```
GATE G5: Self Review Approval — Phase [N]
Status: AWAITING APPROVAL

Checklist:
- [ ] All blocking items resolved or explicitly accepted with rationale
- [ ] Non-blocking items logged as follow-ups if not resolved

To approve: respond "APPROVED"
To reject: respond "REJECTED — [reason]"
```

**Done when:** Human approves resolution of blocking items.

---

### Stage 6 — Commit — per phase

**Owner:** Claude (`/atomic-commits` skill)
**Output:** Atomic commits for the current phase

Claude proposes commits following **Conventional Commits v1.0.0**. Format:

```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
Refs: implementation-plan.md Phase N
```

Types: `feat`, `fix`, `test`, `refactor`, `docs`, `chore`, `perf`, `style`, `ci`, `build`
Breaking changes: `!` suffix on type, or `BREAKING CHANGE:` footer (MUST be uppercase)

Each commit covers one logical change. Claude never commits autonomously — every
commit is proposed and approved individually during GREEN, then reviewed in full at G6.

**[G6: Commit Approval]**

```
GATE G6: Commit Approval — Phase [N]
Status: AWAITING APPROVAL

Proposed commits:
[list]

To approve: respond "APPROVED"
To adjust: respond with what to change
```

**Done when:** Human approves. Move to next phase's RED, or to PR if all phases complete.

---

### Plan Revision — escape hatch

**Owner:** Claude (`/plan-revision` skill)
**Trigger:** A phase reveals a gap, contradiction, or changed requirement in the plan

When a phase uncovers that the plan is wrong — not just that the implementation is
wrong — `/plan-revision` is invoked instead of proceeding to the next phase.

The revision agent reviews the gap, proposes targeted changes to `implementation-plan.md`,
and presents them for approval before overwriting the plan. This is the **only**
mechanism that can modify `implementation-plan.md` after G1.

**[G1-R: Plan Revision Approval]**

```
GATE G1-R: Plan Revision Approval
Status: AWAITING APPROVAL

Gap identified: [description]
Proposed changes to implementation-plan.md: [diff or summary]
Phases affected: [list]

To approve: respond "APPROVED"
To reject: respond "REJECTED — [reason]" and clarify intent
```

**Done when:** Human approves. Plan is updated. Resume from RED for the affected phase.

---

### Stage 7 — PR

**Owner:** Claude (`/gh-create-pr` skill)
**Trigger:** All phases committed and approved
**Output:** Drafted PR covering the full feature

PR is populated from the PR template. Includes: summary, AC coverage table, commit
list, testing notes, and links to the plan file. Claude does not open the PR without
explicit approval.

**[G7: PR Approval]**

```
GATE G7: PR Approval
Status: AWAITING APPROVAL

Checklist:
- [ ] PR description complete — no empty sections
- [ ] AC coverage table accurate
- [ ] Commit list correct
- [ ] No unresolved blocking items from self-reviews

To approve: respond "APPROVED"
To adjust: respond with what to change
```

**Done when:** Human approves and merges.

---

## Context Management

`implementation-plan.md` and `implementation-status.md` are the only state that
persists across context clears.

**Rule:** Clear context between every stage. Reload only:

1. `implementation-plan.md`
2. `implementation-status.md`
3. `context/repo-context.md`

This keeps Claude's context window tight and prevents model degradation over long sessions.

---

## The Human's Role

| Stage                     | Human does                                                  |
| ------------------------- | ----------------------------------------------------------- |
| Feature Spec              | Writes the spec from template before planning               |
| Planning                  | Responds to challenges, approves phase breakdown            |
| RED (per phase)           | Reviews tests against intent, confirms failures are correct |
| GREEN (per phase)         | Confirms tests pass, checks for scope creep                 |
| Self Review (per phase)   | Triages blocking vs. acceptable feedback                    |
| Commit (per phase)        | Reviews proposed commits, approves                          |
| Plan Revision (if needed) | Reviews proposed plan changes, approves or refines spec     |
| PR                        | Reviews PR draft, approves merge                            |

The human is never bypassed. Claude never proceeds without approval.

---

## Gate Index

| Gate | When                            | What human reviews                                 |
| ---- | ------------------------------- | -------------------------------------------------- |
| G1   | End of planning                 | Feature spec, acceptance criteria, phase breakdown |
| G3   | Per phase — tests written       | Tests match intent, fail for right reason          |
| G4   | Per phase — implementation done | Tests pass, no regressions, no scope creep         |
| G5   | Per phase — self review done    | Blocking items resolved or accepted                |
| G6   | Per phase — commits proposed    | Commit messages accurate and complete              |
| G1-R | When plan revision triggered    | Proposed plan changes are correct and complete     |
| G7   | All phases done                 | PR draft complete, ready to open                   |

G2 (Plan Review) is intentionally omitted — overhead not justified for well-scoped features.

