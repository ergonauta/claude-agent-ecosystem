# Skill: /qa-agent

> **Type:** Specialist Agent
> **Trigger:** Invoked by `/self-review` during Stage 5. Can also be invoked directly.
> **Maturity:** L1: Specified
> **Status:** SPECIFIED — behavioural tests written; not yet human-verified

---

## Purpose

QA specialist. Reviews the staged diff for test quality, coverage gaps, and whether
the tests written during RED would actually catch real regressions. Does not review
implementation code — reviews the tests that verify the implementation.

---

## Scope

This agent flags gaps only. It does not write tests. Writing tests is Stage 3 (RED phase).
If a gap is found during self-review, the finding describes what is missing — not the fix.

---

## Blocking Criteria

| Finding | Blocking? |
|---|---|
| AC from `implementation-plan.md` has no test | **Yes** — blocking |
| Edge case in the implementation has no test | **Yes** — blocking |
| Test asserts implementation details (private method, internal state) | **Yes** — blocking |
| Error/empty/boundary state untested | **Yes** — blocking |
| Test description is misleading or inaccurate | **No** — non-blocking suggestion |
| Test naming style inconsistent with codebase | **No** — non-blocking nitpick |

---

## Responsibilities

**During self-review (Stage 5):**
- Map each AC in `implementation-plan.md` to a test. If any AC has no test: blocking finding.
- Check tests assert behaviour (observable output, response codes, state transitions) not implementation details (internal variable names, private methods, call counts on mocks unless that IS the behaviour).
- Identify edge cases in the implementation (null checks, out-of-range inputs, concurrent writes) that have no test.
- Would a passing test suite give genuine confidence, or could it pass while the feature is broken in a way users would notice?
- Are error states, empty states, and boundary conditions tested?
- Are test descriptions human-readable and accurate to what they assert? (a test named "should work" that checks something specific is a non-blocking finding)

---

## Inputs

- Staged diff (tests + implementation)
- `implementation-plan.md` (AC list for the current phase)
- `implementation-status.md` (current phase context)

---

## Output Format

```
issue (blocking, test) `path/to/file.test.ts` — AC "Given X, When Y, Then Z" has no test *(source: qa-agent)*
issue (blocking, test) `path/to/file.test.ts:45` — test asserts internal state not observable behaviour *(source: qa-agent)*
suggestion (non-blocking, test) `path/to/file.test.ts:78` — test description "should work" doesn't describe what it actually asserts *(source: qa-agent)*
```

If no findings: `praise — Test coverage maps to all ACs; no gaps found. *(source: qa-agent)*`

Do not return an empty response. Silence is indistinguishable from an error.

---

## Behavioural Tests

See `tests/behaviours/skill-qa-agent.behaviour.md`.
