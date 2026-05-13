---
name: skill-implementation-plan
description: Orchestrate the full feature delivery workflow from planning through PR. Invoke to start a new feature, resume work after a context clear, or handle scope changes mid-implementation.
compatibility: Designed for Claude Code
metadata:
  type: Orchestrator
  trigger: /implementation-plan
  maturity: L1: Specified
---

## Purpose

Guide a feature from high-level description to an approved, phased implementation plan.
Challenge the human's requirements until the spec is unambiguous enough to write tests from.
Create `implementation-plan.md` and `implementation-status.md` in the target project.

---

## Prerequisites

Before running this skill:
- `context/repo-context.md` must exist (run `/repo-cartographer` first if missing)
- The human must have a feature in mind (even if loosely defined — the skill will sharpen it)

---

## Session Start Protocol

On every invocation, Claude must:

1. Read `context/repo-context.md`
   - If missing: stop. Tell human to run `/repo-cartographer` first.
   - If stale: warn. Staleness = any file in the repo changed after the date recorded in the
     `context/repo-context.md` header line `Generated: YYYY-MM-DD`. Check with:
     `git log --since="<Generated date>" --oneline | head -5`
     If commits exist since that date, surface the warning and ask human to confirm or refresh
     before proceeding. Do not block — warn and continue if human confirms.
2. Check if `implementation-plan.md` already exists
   - If yes: ask "Resume existing plan or start a new one?"
   - If no: proceed to Planning Mode
3. Check if `implementation-status.md` already exists and read current phase

---

## Planning Mode Behaviour

Claude operates in planning mode — **no code, no file changes** until the plan is approved.

### Step 1 — Feature intake

Ask the human to describe:
- What the feature does (user-facing or system behaviour)
- Why it's needed
- Any constraints or existing patterns to follow

Do not accept vague descriptions. Challenge until each answer is specific.

### Step 2 — Acceptance criteria extraction

For each described behaviour, extract a testable acceptance criterion:
- Format: Given / When / Then
- Push back on criteria that are not observable or not testable
- Ask explicitly about: edge cases, failure modes, unauthenticated states, empty states,
  error states, concurrent access, and performance expectations

### Step 3 — Scope boundary challenge

For each stated requirement, ask:
- "Is [adjacent behaviour] in scope?"
- "What happens if [edge case]?"
- "Does this change affect [related system]?"

Force the human to explicitly state what is OUT of scope.

### Step 4 — Phase breakdown proposal

Propose a phase breakdown where:
- Each phase is one atomic layer (tests → implementation → review → commit)
- Each phase covers a coherent subset of acceptance criteria
- Phases are ordered to minimise integration risk
- No phase is larger than can be reviewed in a single sitting

Challenge the human if they propose phases that are too large.

### Step 5 — Plan file creation

Create `implementation-plan.md` from `templates/implementation-plan.md`.
Create `implementation-status.md` from `templates/implementation-status.md`.

Present the plan to the human.

### Step 6 — Gate G1

```
GATE G1: Plan Approval
Status: AWAITING APPROVAL
Plan file: implementation-plan.md

Checklist:
- [ ] AC_TESTABLE: All acceptance criteria are specific and testable (Given/When/Then)
- [ ] SCOPE_EXPLICIT: Out-of-scope items are explicitly listed
- [ ] FAILURE_MODES: Failure modes documented for each phase
- [ ] PHASE_GRANULAR: Phase breakdown is appropriately granular (reviewable in one sitting)
- [ ] RISKS_CAPTURED: Risks and open questions are captured
- [ ] PR_STRATEGY: PR strategy specified (single | stacked — see Branching Strategy section)

To approve: respond "APPROVED"
To request changes: respond with which checklist item fails and what needs to change
```

After approval:
- Update `implementation-status.md` Gate G1 → ✅ APPROVED with timestamp.
- `implementation-plan.md` is now read-only. Only `/plan-revision` may change it.

---

## Handoff

After G1 approval, this skill's job is done.
Next step: RED (test writing) for Phase 1. Human runs the RED phase or continues in same session.

---

## Scope Change Mid-Implementation

If a phase reveals a requirement that contradicts or expands the approved plan:

1. **Stop.** Do not implement the contradicting requirement.
2. Describe the conflict precisely (what the plan says vs. what reality requires).
3. Invoke `/plan-revision`.
4. Do not proceed to the next phase until G1-R is approved.

Trigger rule: plan/spec is wrong → `/plan-revision`. Implementation is wrong → fix the implementation.

---

## Behavioural Tests

See `tests/behaviours/skill-implementation-plan.behaviour.md`.
