# Behavioural Tests — /atomic-commits

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-AC-01: Sub-step commit proposed before execution

GIVEN Claude completes a sub-step during GREEN phase  
WHEN the sub-step introduces a logical change  
THEN Claude proposes a commit message before executing it.  
AND Claude does not execute the commit without a human response.

---

## BT-AC-02: Commit message uses imperative mood

GIVEN a sub-step commit is proposed  
WHEN Claude writes the description line  
THEN the description uses imperative mood ("add token validation" not "added token validation").  
AND the description is under 72 characters.  
AND there is no trailing period.

---

## BT-AC-03: Refs footer always present

GIVEN any commit is proposed  
WHEN Claude formats the commit message  
THEN the footer contains `Refs: implementation-plan.md Phase N` (where N is the current phase number).

---

## BT-AC-04: Breaking change uses correct format

GIVEN a sub-step introduces a breaking change  
WHEN Claude proposes the commit  
THEN the type uses `!` suffix (e.g., `feat(api)!:`) OR the footer contains `BREAKING CHANGE: <description>` in uppercase.  
AND both MAY be used together.

---

## BT-AC-05: Multi-file cross-concern commit is split

GIVEN a sub-step touches files from independent logical concerns (e.g., migration + model + route)  
WHEN Claude evaluates the commit  
THEN Claude proposes splitting into separate commits (one per concern).  
AND each commit is independently revertible.

---

## BT-AC-06: Inseparable multi-file change stays as one commit

GIVEN a sub-step touches multiple files but all changes are inseparable (reverting one breaks another)  
WHEN Claude evaluates the commit  
THEN Claude keeps them as one commit.  
AND Claude justifies this in the commit body.

---

## BT-AC-07: Merge conflict aborts the skill

GIVEN there is an unresolved merge conflict in the working tree  
WHEN `/atomic-commits` is invoked  
THEN Claude aborts.  
AND Claude tells the human: "Resolve the merge/rebase first, then re-run `/atomic-commits`."  
AND Claude does not attempt to auto-resolve conflicts.

---

## BT-AC-08: Gate G6 lists all phase commits

WHEN Gate G6 is presented  
THEN all commits proposed during the current phase are listed in order.  
AND each commit shows the full message (type, description, refs footer).

---

## BT-AC-09: RED phase tests use test type

GIVEN a commit contains only test files written during the RED phase  
WHEN Claude proposes the commit type  
THEN the type is `test(scope):`.

---

## BT-AC-10: G6 approval does not auto-execute

GIVEN the human approves commits at Gate G6  
WHEN Claude processes the approval  
THEN Claude executes the commits in the approved order.  
AND Claude does not execute commits that were not listed at G6.
