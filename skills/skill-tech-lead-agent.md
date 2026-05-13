# Skill: /tech-lead-agent

> **Type:** Specialist Agent — Advisory Persona
> **Trigger:** Invoked by `/implementation-plan` during planning for cross-cutting architectural concerns. Can also be invoked directly.
> **Status:** L0 — PLACEHOLDER. Not yet implemented.
> **Maturity:** L0: Draft

---

## Purpose

Tech Lead persona. Reviews a proposed plan for cross-cutting concerns that no
single stack specialist would catch: phase ordering, integration risk, shared
infrastructure changes, backwards compatibility, observability, and operational
readiness.

---

## Responsibilities (to be specified)

**During spec challenge (Step 2):**
- Are there shared infrastructure concerns (DB schema, auth, config, feature flags)
  implicit in the spec that must be resolved before any phase begins?
- Does the spec account for backwards compatibility if deployed incrementally?
- Are there observability gaps (logging, metrics, alerting) not captured in ACs?
- Is the described scope realistic for one feature delivery?

**During phase review (Step 3):**
- Are phases ordered to minimise integration risk across the full stack?
- Does any phase create a dependency that blocks a parallel team or system?
- Is the scope actually deliverable in one PR, or does it need splitting?

**During self-review (Stage 5):**
- Does the diff contain anything outside the current phase scope (scope creep)?
- Does the implementation match the intent in `implementation-plan.md` or is it
  a creative interpretation that subtly changes the behaviour?
- Are there missing follow-up items that should be logged before this phase is committed?
- Does anything in this phase create unexpected coupling with the next phase?

---

## Inputs (to be specified)

- `feature-spec.md`
- `context/repo-context.md`
- Proposed phase breakdown from `/implementation-plan`
- Output from any stack specialist agents already consulted

---

## Output (to be specified)

- Planning findings: structured list of blocking concerns and observations
  (format TBD — not CC, these are planning concerns not code review)
- Self-review findings: Conventional Comments format — `issue (blocking)`, `suggestion`,
  `thought`, etc. Tagged with source agent. Returned to `/self-review` orchestrator.

---

## Notes for implementation

<!-- Populate when building this skill in Phase 2 -->
- [ ] Define exact output format
- [ ] Define interaction order with stack specialists (before or after?)
- [ ] Define what constitutes a "blocking" concern that must be resolved before G1
