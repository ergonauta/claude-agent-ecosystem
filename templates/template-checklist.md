# Human Verification Checklist — [Skill Name]

> **Skill file:** `skills/[path]/[skill-name].md`
> **Maturity target:** L3 (Human-verified)
> **Prerequisite:** Skill must be at L2 before this checklist is run on a real execution

---

## Instructions

Complete this checklist during or immediately after a real execution of this skill
(not a dry-run — an actual feature delivery session).

Be specific. "Seemed fine" is not a valid answer to any item here.
If you cannot answer a question with evidence, mark it ❌ and note what was missing.

---

## Pre-Execution

- [ ] Skill file was read at session start (not assumed from previous session)
- [ ] All prerequisite files were loaded (`CLAUDE.md`, plan, status, repo-context)
- [ ] Maturity level in skill header was L2 or above before starting

---

## During Execution

### Sequence & Gates

- [ ] Claude followed the exact sequence defined in the skill — no steps skipped
- [ ] Every gate appeared in the correct format before Claude paused
- [ ] Claude did not proceed past any gate without explicit approval
- [ ] Context was cleared at the correct point (if applicable)

### Output Quality

- [ ] Output format matched the template defined in the skill
- [ ] Content was accurate and aligned with the input / plan
- [ ] ADR note was written to status file before context clear (if applicable)

### Behavioural Correctness

- [ ] [Skill-specific check 1 — fill in per skill]
- [ ] [Skill-specific check 2]
- [ ] [Skill-specific check 3]

---

## Post-Execution

### What worked well
<!-- Be specific — what made this execution successful? -->

### What didn't work
<!-- Any deviation from expected behaviour, however minor -->

### Regressions from previous run (if applicable)
<!-- Behaviour that was correct before but broke this time -->

### Gaps found
<!-- Scenarios the skill doesn't handle that it should -->

---

## Checklist Result

- **Date:** [date]
- **Feature this was run on:** [feature name]
- **Overall result:** PASS | PASS WITH NOTES | FAIL
- **Action:**
  - PASS → promote skill to L3
  - PASS WITH NOTES → promote to L3, log gaps as issues
  - FAIL → return to L1/L2, fix and re-verify

---

## Run History

| Date | Feature | Result | Notes |
|---|---|---|---|
| [date] | [feature] | PASS | — |
