# Skill: /implementation-plan

> **Type:** Orchestrator  
> **Trigger:** `/implementation-plan`  
> **Status:** DRAFT — to be refined based on usage

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

Please review implementation-plan.md.

Checklist:
- [ ] All acceptance criteria are specific and testable
- [ ] Out-of-scope items are explicitly listed
- [ ] Failure modes are documented
- [ ] Phase breakdown is appropriately granular
- [ ] Risks and open questions are captured

To approve: respond "APPROVED"
To request changes: respond with what needs to change
```

After approval: update `implementation-status.md` Gate G1 → ✅ APPROVED.
Proceed to Plan Review (or instruct human to run `/implementation-plan` again for next phase).

---

## Handoff

After G1 approval, this skill's job is done.
The next step is Plan Review — either as part of this session or a new session.
The human should run the plan review skill or continue in the same session.

---

## Notes for refinement

<!-- Add observations from real usage here -->
- [ ] Define how to handle scope changes mid-implementation
- [ ] Define behaviour when repo-context.md is stale
- [ ] Consider adding a "complexity estimate" per phase
