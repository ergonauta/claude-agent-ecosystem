# ADR 0004 — Explicit Human Review Gates at Critical Transitions

**Date:** 2025  
**Status:** Accepted  
**Deciders:** Gio

---

## Context

Autonomous AI-assisted development workflows typically fail in one of two ways:

**Too little human involvement:** Claude proceeds through the full implementation,
the human reviews at the end, and finds a fundamental misalignment that invalidates
most of the work. The cost of the error compounds with each unchecked step.

**Too much human involvement:** Every micro-decision requires approval. The workflow
becomes slower than writing the code manually. The overhead eliminates the productivity gain.

The goal is to identify the *minimum set of gates* that prevent compounding errors
without creating friction that makes the workflow impractical.

---

## Decision

Six explicit human approval gates are defined. Claude **cannot proceed** past a gate
without explicit human approval. No implicit continuation. No timeout-based progression.

### The six gates

| Gate | Trigger | What human reviews |
|---|---|---|
| **G1: Plan Approval** | End of planning session | Feature spec, acceptance criteria, phase breakdown |
| **G2: Plan Review Approval** | End of plan review | Findings from Tech Lead + PM review lenses |
| **G3: RED Approval** | All tests written and run | Tests match intent, fail for the right reason |
| **G4: GREEN Approval** | All tests passing | Tests pass, no regressions, no scope creep |
| **G5: Self Review Approval** | Self review complete | Blocking items resolved or explicitly accepted |
| **G6: Commit/PR Approval** | Commits proposed, PR drafted | Commit messages, PR content |

### Gate format

Every gate follows the same structure:

```
GATE [N]: [Gate Name]
Status: AWAITING APPROVAL

[Checklist for human to verify]

To approve: respond "APPROVED" or "APPROVED — [any notes]"
To reject: respond "REJECTED — [reason]" to return to previous phase
```

### Critical gates

G3 (RED Approval) is the most important gate in the workflow.
It is the last moment to catch misalignment before implementation exists.
A thorough RED review eliminates the primary failure mode of AI-assisted development.

G4 (GREEN Approval) is the safety net.
If misalignment survived the RED gate, GREEN is the last chance to catch it
before review and commit amplify the problem.

---

## Consequences

**Positive:**
- Errors are caught at the earliest possible stage, minimising rework cost
- The human maintains genuine ownership — they are never just a passive approver
- Each gate is a natural context-clear boundary (clear after approval, reload for next phase)
- The approval record in `implementation-status.md` provides an audit trail

**Negative:**
- Six gates per phase adds overhead — a feature with 3 implementation phases
  has up to 18 gate interactions
- Requires the human to be available and engaged throughout the workflow
- Gates can become rubber-stamp approvals if the human loses focus

**Mitigations:**
- G1 and G2 are one-time per feature, not per phase
- G3, G4, G5, G6 repeat per implementation phase — but each phase is small by design,
  so review time per gate is proportionally small
- Gate checklists are explicit and specific — they resist rubber-stamping by requiring
  concrete verification actions (e.g., "run the tests and confirm they fail")
