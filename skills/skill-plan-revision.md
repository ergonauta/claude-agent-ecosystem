# Skill: /plan-revision

> **Type:** Orchestrator — Plan Revision
> **Trigger:** Invoked when a phase reveals a gap, contradiction, or changed requirement in `implementation-plan.md`. Can also be invoked directly.
> **Status:** L0 — PLACEHOLDER. Not yet implemented.
> **Maturity:** L0: Draft

---

## Purpose

The only mechanism that can modify `implementation-plan.md` after G1 approval.

Triggered when a phase uncovers a spec problem — not an implementation problem.
Reviews the gap, proposes targeted changes to the plan, and presents them for human
approval (G1-R) before overwriting anything. Prevents the snowball effect of
continuing with a known-wrong plan.

---

## When to invoke

Invoke when, during RED or GREEN of any phase, it becomes clear that:
- An acceptance criterion in the plan is wrong or contradicts another
- A phase assumption is false (a dependency doesn't exist, an API behaves differently)
- The scope of a phase is wrong in a way that affects subsequent phases
- The human has changed their mind about a requirement

Do **not** invoke for implementation problems — only for plan/spec problems.
If the implementation is wrong but the plan is right, fix the implementation.

---

## Behaviour (to be specified)

### Step 1 — Identify and describe the gap

State precisely:
- Which phase and AC triggered the revision
- What the plan currently says
- What is wrong or missing
- Which subsequent phases are affected

### Step 2 — Trace to root cause

Determine whether the gap originates in:
- **`implementation-plan.md`** — a planning error Claude made during breakdown
- **`feature-spec.md`** — an ambiguity or error in the original spec

If the root is in `feature-spec.md`, ask the human to update it before proposing
plan changes. Both files should stay consistent.

### Step 3 — Propose targeted changes

Propose the minimum changes to `implementation-plan.md` that resolve the gap.
Do not rewrite unaffected sections. Present as a diff or clear before/after.

### Step 4 — Gate G1-R

```
GATE G1-R: Plan Revision Approval
Status: AWAITING APPROVAL

Gap identified in: Phase [N] — [brief description]
Root cause: [implementation-plan.md | feature-spec.md]
Phases affected: [list]

Proposed changes to implementation-plan.md:
[before/after or diff]

To approve: respond "APPROVED"
To reject: respond "REJECTED — [reason]" and clarify intent
To request spec update first: respond "UPDATE SPEC — [what needs clarifying]"
```

### Step 5 — Apply and resume

On approval:
- Overwrite `implementation-plan.md` with the revised version
- Update `implementation-status.md` with a G1-R entry and ADR note
- Resume from RED for the affected phase

---

## Inputs (to be specified)

- `implementation-plan.md` (current state)
- `feature-spec.md` (original spec — to trace root cause)
- `implementation-status.md` (which phase triggered the revision)
- Description of the gap from the human or from Claude's observation during RED/GREEN

---

## Output

- Revised `implementation-plan.md` (after G1-R approval)
- Updated `implementation-status.md` with G1-R gate record

---

## Notes for implementation

<!-- Populate when building this skill -->
- [ ] Define how to handle revisions that invalidate already-committed phases
- [ ] Define whether committed work needs to be amended or whether a fixup commit is made
- [ ] Define the ADR note format for G1-R entries in implementation-status.md
- [ ] Consider: should feature-spec.md also be updated when root cause is there?
