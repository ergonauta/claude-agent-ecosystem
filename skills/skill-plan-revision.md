# Skill: /plan-revision

> **Type:** Orchestrator — Plan Revision
> **Trigger:** Invoked when a phase reveals a gap, contradiction, or changed requirement in `implementation-plan.md`. Can also be invoked directly.
> **Maturity:** L1: Specified
> **Status:** SPECIFIED — behavioural tests written; not yet human-verified

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

## Gap Classification

Before anything else, classify the gap into one of three types:

| Type | Description | Action |
|---|---|---|
| **Plan error** | Claude made a wrong assumption or breakdown during planning | Propose targeted changes to `implementation-plan.md` |
| **Spec error** | `feature-spec.md` is ambiguous, contradictory, or wrong | Ask human to update `feature-spec.md` first, then update plan to match |
| **New requirement** | Human has changed their mind since G1 | Treat same as spec error — human must explicitly acknowledge the scope change before plan changes |

State the classification at the start of Step 1. Do not proceed to Step 3 (plan changes)
until the classification is agreed with the human.

---

## Behaviour

### Step 1 — Identify, classify, and describe the gap

State precisely:
- Which phase and AC triggered the revision
- Gap type: plan error / spec error / new requirement
- What the plan currently says vs. what reality requires
- Which subsequent phases are affected

### Step 2 — Spec update (if spec error or new requirement)

If root is in `feature-spec.md`: ask the human to update it before proposing plan changes.
Both files must stay consistent. Do not update the plan until the spec is updated.

If root is a plan error: proceed directly to Step 3.

### Step 3 — Propose targeted changes

Propose the minimum changes to `implementation-plan.md` that resolve the gap.
Format: before/after blocks for each affected section. Do not rewrite unaffected sections.

### Step 4 — Invalidation check

If already-committed phases are affected by the proposed changes:

1. List the committed phases that conflict with the revision.
2. Classify each as:
   - **Compatible** — committed work is still valid; revision only adds or clarifies.
   - **Incompatible** — committed work contradicts the revision; a fixup commit is needed.
3. For incompatible phases: do not proceed until human acknowledges and approves a fixup
   commit strategy. Propose the fixup commit message(s) following Conventional Commits.

### Step 5 — Gate G1-R

```
GATE G1-R: Plan Revision Approval
Status: AWAITING APPROVAL

Gap type: [plan error | spec error | new requirement]
Triggered by: Phase [N] — [AC identifier]
Root cause: [one sentence]
Phases affected: [list]
Committed phases affected: [list or "none"]
Fixup commits needed: [list or "none"]

Proposed changes to implementation-plan.md:

BEFORE:
[original section]

AFTER:
[revised section]

To approve: respond "APPROVED"
To reject: respond "REJECTED — [reason]"
To request spec update first: respond "UPDATE SPEC — [what needs clarifying]"
```

### Step 6 — Apply and resume

On approval:
- Overwrite only the affected sections of `implementation-plan.md`.
- If `feature-spec.md` was updated, confirm it is consistent with the plan.
- Update `implementation-status.md` with a G1-R entry (see ADR Note Format below).
- If fixup commits were needed: make them now before resuming RED.
- Resume from RED for the affected phase.

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

## ADR Note Format for G1-R Entries

In `implementation-status.md`, G1-R entries follow this format:

```
### G1-R: [date] — [Phase N: brief description]
- Gap type: [plan error | spec error | new requirement]
- Root cause: [one sentence]
- Changes: [which sections of implementation-plan.md were updated]
- Phases affected: [list]
- Fixup commits: [list or "none"]
- Approved: [timestamp]
```

---

## Behavioural Tests

See `tests/behaviours/skill-plan-revision.behaviour.md`.
