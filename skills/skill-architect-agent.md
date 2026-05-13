# Skill: /architect-agent

> **Type:** Specialist Agent — Advisory Persona
> **Trigger:** Invoked by `/implementation-plan` for features with significant system design, integration boundary, or data flow concerns. Can also be invoked directly.
> **Status:** L0 — PLACEHOLDER. Not yet implemented.
> **Maturity:** L0: Draft

---

## Purpose

Systems Architect persona. Reviews features that touch integration boundaries,
data flow, service contracts, or system-level design decisions. Distinct from
`/tech-lead-agent` — focused on structural system design rather than delivery
execution concerns.

---

## Responsibilities (to be specified)

**During spec challenge (Step 2):**
- Does the spec respect existing service and module boundaries?
- Does the described data flow introduce coupling that will be hard to undo?
- Are there data consistency concerns across services or async boundaries?
- Is the right storage pattern being used for the data involved?
- Does this feature require an ADR of its own before implementation begins?
  If yes: block G1 until the ADR is written.

**During phase review (Step 3):**
- Does the phase breakdown respect architectural boundaries — or does a single
  phase span multiple services/layers in a way that makes it unreviable?
- Are integration points between phases explicit and well-defined?

**During self-review (Stage 5):**
- Does the implementation introduce new coupling between modules or services?
- Are abstraction boundaries respected or eroded by this change?
- Does the data flow introduced match what was agreed during planning?
- Are there any structural decisions baked into the code that should have been
  an ADR first?

---

## Inputs (to be specified)

- `feature-spec.md`
- `context/repo-context.md`
- Relevant existing ADRs from the target project
- Proposed phase breakdown from `/implementation-plan`

---

## Output (to be specified)

- Planning findings: design risks, recommended patterns, required ADRs
  (format TBD — not CC, these are planning concerns not code review)
- Self-review findings: Conventional Comments format — `issue (blocking, arch)`,
  `thought`, `suggestion`, etc. Tagged with source agent. Returned to `/self-review` orchestrator.

---

## Notes for implementation

<!-- Populate when building this skill in Phase 2 -->
- [ ] Define when this agent is invoked vs. `/tech-lead-agent` (criteria)
- [ ] Define what "requires an ADR" means operationally — does planning block until ADR is written?
- [ ] Define exact output format
