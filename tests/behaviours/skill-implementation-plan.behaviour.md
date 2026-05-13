# Behavioural Tests — /implementation-plan

> Format: GIVEN (precondition) / WHEN (action) / THEN (expected output)  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-IP-01: Missing repo-context.md blocks entry

GIVEN `context/repo-context.md` does not exist  
WHEN `/implementation-plan` is invoked  
THEN Claude stops immediately and tells the human to run `/repo-cartographer` first.  
AND Claude does not ask for feature description.

---

## BT-IP-02: Stale repo-context.md triggers warning not block

GIVEN `context/repo-context.md` exists with `Generated: 2025-01-01`  
AND `git log --since="2025-01-01"` returns commits  
WHEN `/implementation-plan` is invoked  
THEN Claude warns that repo-context may be stale.  
AND Claude lists the number of commits since the generated date.  
AND Claude asks the human to confirm or refresh before proceeding.  
AND Claude does NOT block — proceeds if human confirms.

---

## BT-IP-03: Existing plan prompts resume-or-new

GIVEN `implementation-plan.md` exists in the project  
WHEN `/implementation-plan` is invoked  
THEN Claude asks: "Resume existing plan or start a new one?"  
AND Claude does not overwrite the existing plan without explicit confirmation.

---

## BT-IP-04: Vague feature description is challenged

GIVEN the human provides a feature description like "add user settings"  
WHEN Claude processes Step 1 (Feature intake)  
THEN Claude asks at minimum: what settings, who can access them, what data is stored, what happens on invalid input.  
AND Claude does not proceed to acceptance criteria extraction until answers are specific.

---

## BT-IP-05: Acceptance criteria are Given/When/Then

GIVEN the human describes a feature behaviour  
WHEN Claude extracts acceptance criteria in Step 2  
THEN each criterion uses Given / When / Then format.  
AND Claude pushes back on any criterion that is not observable or not testable (e.g., "it should be fast" → rejected until specific).

---

## BT-IP-06: Out-of-scope must be explicit

GIVEN the human has described the feature scope  
WHEN Claude produces Step 3 (Scope boundary challenge)  
THEN the output includes an explicit "Out of scope" list.  
AND if the human has not stated what is out of scope, Claude prompts them to do so.

---

## BT-IP-07: Phase breakdown challenged if too large

GIVEN a phase is proposed that covers more than 3 acceptance criteria or would take >1 sitting to review  
WHEN Claude evaluates the phase breakdown in Step 4  
THEN Claude challenges the phase and proposes a split.

---

## BT-IP-08: G1 gate has machine-parseable checklist items

WHEN Claude presents Gate G1  
THEN each checklist item uses the form `- [ ] KEY: Description` with a machine-parseable key (AC_TESTABLE, SCOPE_EXPLICIT, FAILURE_MODES, PHASE_GRANULAR, RISKS_CAPTURED, PR_STRATEGY).  
AND "To approve" and "To request changes" instructions are present.

---

## BT-IP-09: Approval locks the plan

GIVEN the human responds "APPROVED" to Gate G1  
WHEN Claude processes the approval  
THEN Claude updates `implementation-status.md` with Gate G1 → ✅ APPROVED and a timestamp.  
AND Claude states that `implementation-plan.md` is now read-only and only `/plan-revision` may change it.

---

## BT-IP-10: Scope change mid-implementation triggers plan-revision

GIVEN an approved plan exists  
AND a phase reveals a contradiction in the plan  
WHEN Claude identifies the contradiction during RED or GREEN  
THEN Claude stops implementation.  
AND Claude describes the conflict precisely.  
AND Claude invokes `/plan-revision` rather than silently resolving the contradiction in code.

---

## BT-IP-11: Multi-PR feature invokes stacked-branches

GIVEN Step 3 identifies more than one natural PR boundary  
WHEN Claude finalises the phase breakdown  
THEN Claude invokes `/stacked-branches` before presenting G1.  
AND the `implementation-plan.md` includes a `## Branching Strategy` section.  
AND G1 checklist item PR_STRATEGY references the stacked branch plan.
