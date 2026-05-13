# Behavioural Tests — /qa-agent

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-QA-01: Missing AC test is blocking

GIVEN an AC in `implementation-plan.md` has no corresponding test in the diff  
WHEN `/qa-agent` reviews the diff  
THEN the finding is `issue (blocking, test)` naming the specific AC.

---

## BT-QA-02: Test asserting implementation detail is blocking

GIVEN a test asserts the value of a private variable or internal method call  
AND that internal state is not the observable output  
WHEN `/qa-agent` reviews the diff  
THEN the finding is `issue (blocking, test)` citing the test file and line.

---

## BT-QA-03: Missing error state test is blocking

GIVEN the implementation has an error path (e.g., 404 on missing resource)  
AND there is no test for that error path  
WHEN `/qa-agent` reviews the diff  
THEN the finding is `issue (blocking, test)` describing the untested error state.

---

## BT-QA-04: Misleading test description is non-blocking

GIVEN a test is named "should work" but actually asserts something specific  
WHEN `/qa-agent` reviews the diff  
THEN the finding is `suggestion (non-blocking, test)` noting the misleading name.

---

## BT-QA-05: Test naming style inconsistency is a nitpick

GIVEN one test uses "it should X" format and another uses "X is returned"  
AND the codebase convention is "it should X"  
WHEN `/qa-agent` reviews the diff  
THEN the finding is `nitpick (test)` — non-blocking.

---

## BT-QA-06: QA agent does not write tests

GIVEN `/qa-agent` finds a missing edge case  
WHEN the finding is produced  
THEN the finding describes what is missing.  
AND the finding does NOT include new test code.

---

## BT-QA-07: No findings produces praise, not silence

GIVEN all ACs have tests, all edge cases are covered, tests assert behaviour  
WHEN `/qa-agent` completes  
THEN it returns: `praise — Test coverage maps to all ACs; no gaps found. *(source: qa-agent)*`  
AND it does not return an empty response.

---

## BT-QA-08: Source tag present on all findings

GIVEN `/qa-agent` produces any finding  
WHEN findings are formatted  
THEN every finding ends with `*(source: qa-agent)*`.

---

## BT-QA-09: All ACs explicitly mapped

GIVEN `implementation-plan.md` Phase 2 has 4 ACs  
WHEN `/qa-agent` reviews the diff  
THEN the agent explicitly checks each of the 4 ACs against the test files.  
AND the review output shows which ACs are covered and which (if any) are missing.
