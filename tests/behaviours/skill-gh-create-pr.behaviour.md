# Behavioural Tests — /gh-create-pr

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-GP-01: Missing prerequisites block entry

GIVEN `implementation-plan.md` or `implementation-status.md` does not exist  
WHEN `/gh-create-pr` is invoked  
THEN Claude stops and tells the human which files are missing.

---

## BT-GP-02: Branch not pushed blocks PR creation

GIVEN the current branch has not been pushed to remote  
WHEN Claude attempts to create the PR  
THEN Claude stops and tells the human to push the branch first.  
AND Claude provides the push command: `git push -u origin <branch-name>`.

---

## BT-GP-03: PR draft presented before opening

GIVEN all prerequisites are met  
WHEN Claude reaches Step 3  
THEN Claude presents the full PR draft in chat.  
AND Claude does NOT call `gh pr create` yet.  
AND Gate G7 is presented with "OPEN PR", "edit", and "SAVE DRAFT" options.

---

## BT-GP-04: Gate number is G7 not G6

WHEN Gate is presented in the PR flow  
THEN the gate is labelled `GATE G7: PR Approval`, not G6.

---

## BT-GP-05: AC coverage table is accurate

GIVEN `implementation-plan.md` contains 5 acceptance criteria across 2 phases  
WHEN Claude builds the AC coverage table  
THEN all 5 ACs appear in the table.  
AND each AC is mapped to the phase that delivered it.

---

## BT-GP-06: Stacked PR uses correct base branch

GIVEN a stacked feature with 3 PRs and `Current PR Stack: PR 2` in `implementation-status.md`  
WHEN Claude creates the PR for stack 2  
THEN `--base` is set to PR 1's branch name (not `main`).  
AND `--head` is set to PR 2's branch name.

---

## BT-GP-07: Single PR uses main as base

GIVEN `implementation-status.md` `Branching Strategy: single PR`  
WHEN Claude creates the PR  
THEN `--base` is `main`.

---

## BT-GP-08: Reviewer and label flags omitted when not provided

GIVEN the human has not specified reviewers or labels  
WHEN Claude builds the `gh pr create` command  
THEN `--reviewer` and `--label` flags are not included.

---

## BT-GP-09: Reviewer and label flags used when provided

GIVEN the human specifies reviewers and labels at G7  
WHEN Claude builds the `gh pr create` command  
THEN `--reviewer` includes the specified usernames.  
AND `--label` includes the specified labels.

---

## BT-GP-10: implementation-status.md updated after PR opens

GIVEN the human responds "OPEN PR" and the PR is created  
WHEN Claude completes Step 5  
THEN `implementation-status.md` Gate G7 is updated to ✅ APPROVED.  
AND the PR URL and branch name are recorded in `implementation-status.md`.
