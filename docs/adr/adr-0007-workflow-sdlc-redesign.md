# ADR 0007 — SDLC Redesign: Feature Spec, Per-Phase Loop, Plan Revision

**Date:** 2026-05-12
**Status:** Accepted
**Deciders:** Gio

---

## Context

The original workflow (documented pre-ADR-0007) described a linear sequence:

```
PLANNING → PLAN REVIEW → RED → GREEN → SELF-REVIEW → COMMIT → PR
```

This had four structural problems:

**1. No upstream input artifact.**
Planning started with the human describing a feature verbally during the session.
There was no written spec to challenge against. This meant planning quality depended
entirely on what the human happened to say in the moment — gaps in the verbal
description became gaps in the plan.

**2. Plan Review was a costly, low-signal stage.**
A dedicated review pass on the plan (G2) added a gate without meaningfully reducing
risk. The same coverage is achieved by: (a) Claude challenging the spec during planning,
and (b) the RED gate forcing tests to be written against stated criteria before any
implementation begins. Plan Review was overhead without a clear failure mode it alone
could catch.

**3. The workflow was a single pass.**
A feature went through RED → GREEN → SELF-REVIEW → COMMIT exactly once. In practice,
features decompose into multiple coherent layers (data model, API, consumption, UI,
integration). A single pass either forces all layers into one large phase — too big
to review — or requires running the entire workflow multiple times with no formal
structure connecting the passes.

**4. No plan revision mechanism.**
`implementation-plan.md` was declared read-only after G1, but no escape hatch existed
for when a phase revealed a fundamental gap in the plan. The only option was to
continue with a known-wrong plan or restart from scratch.

---

## Decision

Redesign the workflow around four changes:

---

### Change 1 — Feature Spec template as upstream input

A `feature-spec.md` document (from template) must exist before a planning session
begins. The human writes the spec in their own words, referencing any source — Jira
tickets, ADRs, tech documents, conversations. Completeness matters more than polish.

Planning becomes: Claude reads the spec and challenges it, rather than eliciting
requirements verbally.

**Rationale:** A written spec externalises the human's thinking before Claude
influences it. Gaps are visible before the planning session starts. Claude's challenges
are grounded in a concrete artifact, not a verbal summary that shifts as the
conversation progresses.

---

### Change 2 — Plan Review (G2) dropped

G2 is removed from the gate sequence.

**Rationale:** The coverage it provided is absorbed by:
- The planning challenge phase (gaps caught before G1)
- The RED gate (tests must map to stated criteria — misalignment surfaces immediately)

Adding G2 back is appropriate if a feature involves significant architectural risk
or cross-team coordination. In that case it should be invoked explicitly, not run
by default on every feature.

---

### Change 3 — Per-phase loop replaces single pass

The workflow becomes a loop. A feature is broken into phases during planning.
Each phase goes through the full RED → GREEN → SELF-REVIEW → COMMIT sequence
before the next phase begins:

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

One PR is opened at the end, covering all phases. Features should be scoped
small enough to fit in a single PR. For features too large for one PR, a future
`/stacked-branches` skill will manage a stacked branching strategy.

**Rationale:** Incremental commits of working software reduce integration risk.
Each phase gate is a natural checkpoint. Failures are caught at the phase boundary,
not at the end of a long implementation pass. The human reviews smaller, coherent
diffs rather than one large one.

---

### Change 4 — Plan Revision escape hatch (`/plan-revision`)

`implementation-plan.md` remains read-only after G1, with one exception:
`/plan-revision` is the only mechanism that can modify it.

Trigger: a phase reveals a gap, contradiction, or changed requirement in the plan —
not an implementation problem, but a spec problem.

The `/plan-revision` skill:
1. Identifies the specific gap
2. Proposes targeted changes to `implementation-plan.md`
3. Presents changes for human approval (G1-R gate) before overwriting
4. On approval, updates the plan and resumes from RED for the affected phase

The human may also be asked to refine `feature-spec.md` if the gap traces back
to the original spec rather than the planning interpretation.

**Rationale:** A rigid read-only rule without an escape hatch forces a choice
between continuing with a wrong plan or restarting from scratch. Both are worse
than a controlled, gated revision. The G1-R gate preserves human oversight —
plan revision is not a silent mutation.

---

## Consequences

**Positive:**
- Planning has a concrete artifact to challenge — higher-quality plans
- Removing G2 reduces gate count without reducing coverage
- Per-phase loop produces incremental working commits — easier to review, easier
  to bisect if something breaks
- Plan Revision gives a recovery path for discovered gaps without full restart

**Negative:**
- Feature Spec adds a pre-session step — the human must write before planning begins
- Per-phase loop multiplies gate interactions (G3–G6 repeat per phase)
- `/plan-revision` adds complexity — a new skill to build and maintain

**Mitigations:**
- Feature Spec template keeps the writing task lightweight — no formal format required
- Phases are small by design, so per-phase gate overhead is proportionally small
- G1-R is structurally identical to G1 — no new gate mechanics to learn
- Plan Revision is only triggered when needed — it does not run by default

---

## Updated Gate Sequence

| Gate | When | What human reviews |
|---|---|---|
| G1 | End of planning | Feature spec, acceptance criteria, phase breakdown |
| G3 | Per phase — tests written | Tests match intent, fail for right reason |
| G4 | Per phase — implementation done | Tests pass, no regressions, no scope creep |
| G5 | Per phase — self review done | Blocking items resolved or accepted |
| G6 | Per phase — commits proposed | Commit messages accurate and complete |
| G1-R | When plan revision triggered | Proposed plan changes correct and complete |
| G7 | All phases done | PR draft complete, ready to open |

G2 removed. G7 added (previously PR was bundled into G6).

---

## Related

- ADR 0001 — split plan and status (plan read-only rule established here)
- ADR 0002 — TDD as alignment tool (RED gate rationale)
- ADR 0003 — atomic phase commits (per-phase commit discipline)
- ADR 0004 — human review gates (canonical gate format)
- workflow.md — updated to reflect this ADR