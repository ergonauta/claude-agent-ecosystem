# Behavioural Tests — /plan-revision

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-PR-01: Not invoked for implementation errors

GIVEN a test is failing because Claude wrote wrong code  
AND the plan correctly describes the expected behaviour  
WHEN Claude identifies the failure  
THEN Claude does NOT invoke `/plan-revision`.  
AND Claude fixes the implementation.

---

## BT-PR-02: Invoked for plan errors

GIVEN an AC in `implementation-plan.md` is logically contradictory  
AND this is discovered during RED for Phase N  
WHEN Claude identifies the contradiction  
THEN Claude stops implementation.  
AND Claude invokes `/plan-revision`.

---

## BT-PR-03: Gap type is classified before any changes

GIVEN `/plan-revision` is invoked  
WHEN Step 1 begins  
THEN Claude classifies the gap as: plan error, spec error, or new requirement.  
AND Claude states the classification explicitly.  
AND Claude does not propose plan changes until the human agrees with the classification.

---

## BT-PR-04: Spec error requires spec update before plan changes

GIVEN the gap type is "spec error"  
WHEN Step 2 runs  
THEN Claude asks the human to update `feature-spec.md` first.  
AND Claude does not propose changes to `implementation-plan.md` until `feature-spec.md` is updated.

---

## BT-PR-05: Plan changes are minimal

GIVEN the gap affects only Phase 3's AC  
WHEN Step 3 proposes changes  
THEN only the Phase 3 section of `implementation-plan.md` is modified.  
AND unaffected sections are not rewritten or reformatted.

---

## BT-PR-06: Changes presented as before/after blocks

WHEN Gate G1-R presents the proposed changes  
THEN each changed section appears as a BEFORE block and an AFTER block.  
AND the gate clearly labels which sections are affected.

---

## BT-PR-07: Compatible committed phases are noted but not blocked

GIVEN Phase 1 is already committed  
AND the revision to Phase 3 is compatible with the Phase 1 commit  
WHEN the invalidation check runs  
THEN Claude lists Phase 1 as "compatible" in the G1-R gate.  
AND Claude does not request a fixup commit for Phase 1.

---

## BT-PR-08: Incompatible committed phases require fixup commit approval

GIVEN Phase 2 is already committed  
AND the revision to Phase 2's AC contradicts that commit  
WHEN the invalidation check runs  
THEN Claude lists Phase 2 as "incompatible".  
AND Claude proposes fixup commit message(s) following Conventional Commits format.  
AND Claude does not proceed until the human acknowledges the fixup strategy.

---

## BT-PR-09: G1-R gate output is complete

WHEN Gate G1-R is presented  
THEN the gate contains: gap type, triggered-by phase, root cause, phases affected, committed phases affected, fixup commits.  
AND "To approve", "To reject", and "To request spec update first" responses are defined.

---

## BT-PR-10: Approval applies only affected sections

GIVEN the human approves G1-R  
WHEN Claude applies the revision  
THEN only the affected sections of `implementation-plan.md` are overwritten.  
AND the rest of the file is unchanged.

---

## BT-PR-11: G1-R entry written to implementation-status.md

GIVEN the human approves G1-R  
WHEN Claude applies the revision  
THEN `implementation-status.md` gains a G1-R entry with: date, phase, gap type, root cause, changes, phases affected, fixup commits, timestamp.

---

## BT-PR-12: RED resumes for affected phase after approval

GIVEN G1-R is approved and fixup commits (if any) are done  
WHEN Step 6 completes  
THEN Claude resumes from RED for the affected phase.  
AND Claude does not skip back to the phase where the gap was discovered.
