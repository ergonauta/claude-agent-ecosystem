# Skill: /fastapi-agent

> **Type:** Specialist Agent
> **Trigger:** Invoked by `/implementation-plan` during planning when FastAPI stack detected. Can also be invoked directly.
> **Status:** L0 — PLACEHOLDER. Not yet implemented.
> **Maturity:** L0: Draft

---

## Purpose

Expert specialist for FastAPI features. Validates phase scope, surfaces route design,
schema, dependency injection, and async concerns during planning.

---

## Responsibilities (to be specified)

**During spec challenge (Step 2):**
- Are the described behaviours achievable within FastAPI constraints?
- Are auth, validation, and error response behaviours stated or assumed?
- Are there missing edge cases specific to FastAPI (422 validation errors,
  auth dependency failures, background task edge cases, async vs sync handlers)?
- Are acceptance criteria testable with pytest + httpx?

**During phase review (Step 3):**
- Are phases sequenced correctly? (schemas and models before route handlers)
- Are dependency injection trees respected across phases?
- Does any phase assume a schema or dependency that is built in a later phase?

**During self-review (Stage 5):**
- Are response models correct and complete — no unintended field exposure?
- Are status codes semantically correct for each route?
- Are dependencies correctly scoped (request vs. lifespan)?
- Are async handlers used where needed and avoided where not?
- Do the changes follow the route and schema conventions in `repo-context.md`?

---

## Inputs (to be specified)

- `feature-spec.md`
- `context/repo-context.md`
- Proposed phase breakdown from `/implementation-plan`

---

## Output (to be specified)

- Planning findings: structured list of risks, missing phases, sequencing concerns
  (format TBD — not CC, these are planning concerns not code review)
- Self-review findings: Conventional Comments format — `issue (blocking)`, `suggestion`,
  `question`, etc. Tagged with source agent. Returned to `/self-review` orchestrator.

---

## Notes for implementation

<!-- Populate when building this skill in Phase 2 -->
- [ ] Define exact output format
- [ ] Define how feedback integrates into G1 gate output
- [ ] Decide: does this agent write to plan directly or return to orchestrator?