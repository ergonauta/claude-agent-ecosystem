# Behavioural Tests — /self-review

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-SR-01: Missing prerequisites block entry

GIVEN `implementation-plan.md` does not exist  
WHEN `/self-review` is invoked  
THEN Claude stops and tells the human which files are missing.  
AND Claude does not attempt a review.

---

## BT-SR-02: Small diff dispatches all personas in parallel

GIVEN the diff has ≤ 500 lines changed (excluding test files)  
WHEN `/self-review` is invoked  
THEN all five personas are dispatched simultaneously.  
AND the summary is written to `self-review-phase-N.md`.

---

## BT-SR-03: Large diff triggers split strategy

GIVEN the diff has > 500 lines changed (excluding test files)  
WHEN `/self-review` is invoked  
THEN Claude groups changed files by directory or concern area.  
AND runs the full persona panel sequentially per group.  
AND the summary header notes the split and lists the groups reviewed.

---

## BT-SR-04: Senior Engineer falls back when no specialist exists

GIVEN the detected stack in `context/repo-context.md` is not React/Next.js or FastAPI  
WHEN Senior [Stack] Engineer persona is dispatched  
THEN Claude uses a generic senior backend/frontend review lens based on the stack field in `repo-context.md`.  
AND the summary labels the reviewer as "Senior [detected-stack] Engineer" or "Senior Engineer (generic)" if stack is unclear.

---

## BT-SR-05: Empty findings are omitted from summary

GIVEN a persona finds no issues in the diff  
WHEN the summary is written  
THEN that persona is omitted from the summary entirely.  
AND no "Reviewer found nothing" placeholder appears.

---

## BT-SR-06: Duplicate findings across personas are merged

GIVEN two personas both flag the same issue (same file, same behaviour)  
WHEN the summary is written  
THEN the issue appears once, noting both source personas.  
AND the item is not duplicated.

---

## BT-SR-07: Must Resolve section is never omitted

GIVEN the review is complete  
WHEN the summary is written  
THEN the `## Must Resolve` section is always present.  
AND if empty, it contains exactly `None.` — not an empty section, not omitted.

---

## BT-SR-08: Security findings follow severity tiers

GIVEN the Security Engineer persona finds a vulnerability  
WHEN the finding is written to the summary  
THEN Critical/High severity findings appear in Must Resolve as `issue (blocking, security)`.  
AND Medium severity findings appear in Should Consider as `suggestion (non-blocking, security)`.  
AND Low severity findings appear in Notes as `note (security)`.

---

## BT-SR-09: QA persona flags gaps only, does not write tests

GIVEN the QA Engineer persona finds missing test coverage  
WHEN the finding is written to the summary  
THEN the finding describes what is missing (e.g., "no test for empty state on user list").  
AND the finding does NOT include new test code.

---

## BT-SR-10: G5 gate lists Must Resolve count accurately

WHEN Gate G5 is presented  
THEN the count of Must Resolve items matches the items in `self-review-phase-N.md`.  
AND the gate clearly states that questions must be answered before approval.

---

## BT-SR-11: Approval updates implementation-status.md

GIVEN the human responds "APPROVED" to Gate G5  
WHEN Claude processes the approval  
THEN Claude updates `implementation-status.md` Gate G5 → ✅ APPROVED with timestamp.
