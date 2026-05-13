# Implementation Plan — Agent Ecosystem: Phase 1

> **Status:** APPROVED
> **Approved by:** Gio
> **Date approved:** 2025
> **This file is READ-ONLY after approval.**

---

## 1. Feature Summary

Build the agent ecosystem repository to a state where the `/implementation-plan`
orchestrator skill is production-ready (L4), and all supporting workflow skills
(`/self-review`, `/atomic-commits`, `/gh-create-pr`) are human-verified (L3).

This is the foundation. Everything else in the ecosystem depends on these four skills
working correctly before specialist agents and personas are built on top.

---

## 2. Context & Motivation

The repo currently contains:
- ✅ All ADRs written (0001–0006)
- ✅ Workflow docs written (workflow.md, workflow-detailed.md)
- ✅ Skill skeletons at L0 (Draft)
- ✅ Templates written
- ✅ Testing infrastructure templates written
- ❌ No skill is at L1 or above
- ❌ No behavioural tests exist
- ❌ No human checklists have been run
- ❌ No personas exist
- ❌ No specialist agents exist

This plan covers the path from current state to the four core skills at L3+.

---

## 3. Out of Scope

- [ ] Specialist agents (sr-react-agent, sr-backend-agent, qa-agent) — Phase 2
- [ ] Personas (tech-lead, pm-agent, systems-architect) — Phase 2
- [ ] `/repo-cartographer` reaching L3 — Phase 2
- [ ] Multi-agent orchestration — Phase 3
- [ ] Using the system on a real external project — after Phase 1 complete

---

## 4. Acceptance Criteria

### AC-01: `/implementation-plan` skill is complete and self-verified
**Given:** A fresh Claude Code session with CLAUDE.md and repo-context loaded
**When:** Gio runs `/implementation-plan` with a vague feature description
**Then:**
- Claude challenges the description with specific questions
- Claude refuses to accept vague acceptance criteria
- Claude produces a valid `implementation-plan.md` from the template
- Claude creates `implementation-status.md`
- Gate G1 appears in correct format before Claude stops
- Claude does not proceed past G1 without explicit approval
**Edge cases:** Feature description is already precise (skip unnecessary challenges), description has internal contradictions (flag before proceeding)

### AC-02: `/self-review` skill is complete and self-verified
**Given:** A staged diff and implementation-plan.md loaded
**When:** Gio runs `/self-review`
**Then:**
- Claude adopts adversarial reviewer persona
- Output contains Blocking and Non-Blocking sections
- Each blocking item has: location, issue, recommendation
- Gate G5 appears in correct format
- Claude does not execute any changes — review only
**Edge cases:** No blocking items found (still produces structured output), diff is very large (handles without truncating review)

### AC-03: `/atomic-commits` skill is complete and self-verified
**Given:** Staged changes after a GREEN phase
**When:** Claude proposes sub-step commits during GREEN
**Then:**
- Each commit message follows Conventional Commits spec exactly
- Messages include `Refs: implementation-plan.md Phase N`
- Claude proposes before executing — never commits autonomously
- Gate G6 commit block appears in correct format
**Edge cases:** Single logical change (one commit, not forced splitting), changes span multiple concerns (flags and asks how to split)

### AC-04: `/gh-create-pr` skill is complete and self-verified
**Given:** All phase commits complete, plan and status files readable
**When:** Gio runs `/gh-create-pr`
**Then:**
- PR draft populated from template — no empty sections
- AC coverage table populated from plan
- Commit list accurate
- Gate G6 PR block appears before any `gh` command runs
- Claude does not open the PR without explicit approval
**Edge cases:** Some ACs not covered by tests (flagged explicitly in PR), no `gh` CLI available (produces draft for manual creation)

### AC-05: All four skills have behavioural test files (L1)
**Given:** Each skill file
**When:** Behavioural test is written
**Then:**
- At least 3 scenarios per skill (happy path, edge case, gate behaviour)
- Anti-patterns defined for each scenario
- Self-evaluation instructions included

### AC-06: All four skills pass self-evaluation (L2)
**Given:** Skill file + behavioural test file
**When:** Claude performs dry-run and self-evaluates
**Then:** All scenarios result in PASS or PARTIAL (no FAILs)
- PARTIAL results have specific notes on what to fix
- Skill file is updated until all scenarios PASS

---

## 5. Failure Modes

| Scenario | Expected behaviour |
|---|---|
| Claude self-evaluates a skill as PASS when it should FAIL | Human checklist catches it at L3 gate |
| A skill edit fixes one behaviour but breaks another | Re-run full behavioural test suite before promoting |
| Gate format drifts across skill files | ADR 0004 defines canonical format — flag as contradiction |
| Skill file becomes too long and loses coherence | Split into sub-skills, document decision as ADR |

---

## 6. Technical Approach

- **No external dependencies** — all skills are markdown files, no tooling required
- **Self-referential** — the ecosystem is built using its own workflow conventions
  (plan file, status file, gates, ADR notes) even before the skills are production-ready
- **Iterative** — skills move through maturity levels; nothing is "done" in one pass
- **Skill file format:** Each skill uses a consistent header block declaring name, type,
  trigger, maturity level, and last-evaluated date

---

## 7. Phase Breakdown

### Phase 1 — Behavioural tests for all four core skills
**Scope:** Write `tests/behaviours/` files for: implementation-plan, self-review,
atomic-commits, gh-create-pr. Each reaches L1.
**ACs covered:** AC-05
**Dependencies:** None — start here

### Phase 2 — Refine `/implementation-plan` skill to L2
**Scope:** Dry-run the skill against its behavioural test. Identify gaps.
Update skill file until all scenarios PASS. Promote to L2.
**ACs covered:** AC-01, AC-06 (partial)
**Dependencies:** Phase 1

### Phase 3 — Refine `/self-review` skill to L2
**Scope:** Same as Phase 2 for self-review.
**ACs covered:** AC-02, AC-06 (partial)
**Dependencies:** Phase 1

### Phase 4 — Refine `/atomic-commits` and `/gh-create-pr` to L2
**Scope:** Same pattern for remaining two workflow skills.
**ACs covered:** AC-03, AC-04, AC-06 (complete)
**Dependencies:** Phase 1

### Phase 5 — Human verification run (L3)
**Scope:** Run all four skills on a real small feature in an external project.
Complete human checklists. Promote skills that pass to L3.
**ACs covered:** All
**Dependencies:** Phases 2–4 complete

---

## 8. Risks & Open Questions

| Risk / Question | Impact | Resolution |
|---|---|---|
| Self-evaluation has blind spots — skill appears to pass but behaves wrong on real run | High | Human checklist at L3 is the safety net; don't skip it |
| Skill files are too abstract to be executable without more context | Medium | Dry-run in Phase 2–4 will surface this; fix before L2 |
| Gate formats across skills drift from the canonical format in ADR 0004 | Medium | Behavioural tests check format explicitly |
| `/implementation-plan` skill is both the most complex and the one being used to plan its own development | Low | Acceptable — use it manually with awareness of its current L0 state |

---

## 9. Related

- ADR 0001 — split plan and status
- ADR 0002 — TDD as alignment tool
- ADR 0004 — human review gates
- ADR 0006 — skill testing strategy
