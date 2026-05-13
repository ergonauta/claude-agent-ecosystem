# Skill: /qa-agent

> **Type:** Specialist Agent
> **Trigger:** Invoked by `/self-review` during Stage 5. Can also be invoked directly.
> **Status:** L0 — PLACEHOLDER. Not yet implemented.
> **Maturity:** L0: Draft

---

## Purpose

QA specialist. Reviews the staged diff for test quality, coverage gaps, and whether
the tests written during RED would actually catch real regressions. Does not review
implementation code — reviews the tests that verify the implementation.

---

## Responsibilities (to be specified)

**During self-review (Stage 5):**
- Do the tests cover the acceptance criteria stated in `implementation-plan.md`?
- Are tests asserting behaviour or implementation details?
- Are there edge cases in the implementation that have no corresponding test?
- Would a passing test suite give genuine confidence, or could it pass while the
  feature is broken in a way users would notice?
- Are error states, empty states, and boundary conditions tested?
- Are test descriptions human-readable and accurate to what they actually assert?

---

## Inputs (to be specified)

- Staged diff (tests + implementation)
- `implementation-plan.md` (AC list for the current phase)
- `implementation-status.md` (current phase context)

---

## Output (to be specified)

- Conventional Comments format — `issue (blocking, test)`, `suggestion (test)`,
  `question`, `note`, etc. Tagged with source agent `*(source: qa-agent)*`.
- Returned to `/self-review` orchestrator for consolidation.

---

## Notes for implementation

<!-- Populate when building this skill in Phase 2 -->
- [ ] Define what "blocking" means for a QA finding (missing AC coverage = blocking?)
- [ ] Define exact output format consistent with other review agents
- [ ] Decide: does this agent ever suggest new tests, or only flag gaps?
