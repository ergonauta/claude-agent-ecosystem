# Skill: /gh-create-pr

> **Type:** Workflow  
> **Trigger:** `/gh-create-pr`  
> **Status:** DRAFT — to be refined based on usage

---

## Purpose

Draft a pull request from the current branch based on the implementation plan,
status file, and commit history. Present the draft for human approval before opening.

---

## Prerequisites

- `implementation-plan.md` is readable
- `implementation-status.md` is readable (all phases for this feature complete)
- All commits for the feature are in place
- Self-review has been completed and Gate G5 approved
- The branch is pushed to remote

---

## Behaviour

### Step 1 — Gather context

Read:
- `implementation-plan.md` — for feature summary, ACs, phase breakdown
- `implementation-status.md` — for phase outcomes, ADR notes, resolved items
- Git log for the branch — for the list of commits
- Self-review output (from `implementation-status.md`) — for the review summary

### Step 2 — Draft the PR

Populate `templates/pr-template.md` with:

- **Title:** `[type]: [feature name]` following conventional commits style
- **Summary:** From plan's feature summary, written as delivered outcome
- **Changes:** Per phase, from the phase log in `implementation-status.md`
- **AC Coverage table:** From `implementation-plan.md` ACs
- **Test summary:** From GREEN phase gate outcomes
- **Key decisions:** The most significant ADR notes (2-3 maximum, not all of them)
- **Self review summary:** From Gate G5 in `implementation-status.md`
- **Out of scope:** From plan's out-of-scope section, plus anything explicitly deferred
- **How to test:** Practical steps, ending with the test command

### Step 3 — Present draft for review

Present the full PR draft in the chat. Do not open the PR yet.

```
PR Draft — [Feature Name]

[full draft content]

---
GATE G6: PR Approval
Status: AWAITING APPROVAL

To approve and open PR: respond "OPEN PR"
To edit: respond with what needs to change
To save draft only: respond "SAVE DRAFT"
```

### Step 4 — Open PR

After human approves:

```bash
gh pr create \
  --title "[title]" \
  --body "[body]" \
  --base main \
  --head [branch-name]
```

Or if saving as draft:

```bash
gh pr create --draft \
  --title "[title]" \
  --body "[body]" \
  --base main \
  --head [branch-name]
```

### Step 5 — Update status

After PR is created, update `implementation-status.md`:
- Gate G6: ✅ APPROVED
- Final State: PR link, branch name, date

---

## PR Title Format

```
feat(scope): [feature name in imperative mood]
```

Examples:
- `feat(auth): add JWT expiry validation`
- `fix(payments): handle declined card error state`
- `refactor(api): extract pagination logic to shared utility`

---

## Notes for refinement

<!-- Add observations from real usage here -->
- [ ] Define handling for multi-phase features that span multiple PRs
- [ ] Add support for linking to tickets (Jira, Linear, GitHub Issues)
- [ ] Define reviewer assignment logic
- [ ] Consider adding label automation based on commit types
