# Skill: /react-agent

> **Type:** Specialist Agent
> **Trigger:** Invoked by `/implementation-plan` during planning when React or Next.js stack detected. Can also be invoked directly.
> **Status:** L0 — PLACEHOLDER. Not yet implemented.
> **Maturity:** L0: Draft

---

## Purpose

Expert specialist for React and Next.js features. Validates phase scope,
surfaces component architecture concerns, and flags state management, routing,
and rendering strategy risks during planning.

---

## Responsibilities (to be specified)

**During spec challenge (Step 2):**
- Are the described behaviours achievable within React/Next.js constraints?
- Are rendering strategy decisions (SSR, CSR, RSC) implied but unstated?
- Are there missing edge cases specific to React (loading states, error boundaries,
  suspense, hydration, SSR/CSR split)?
- Are acceptance criteria testable with standard React testing tools (RTL, Playwright)?

**During phase review (Step 3):**
- Are phases sequenced correctly for React? (shared components before consuming pages)
- Are state management boundaries respected across phases?
- Does any phase assume a component exists that is built in a later phase?

**During self-review (Stage 5):**
- Is the implementation idiomatic React? (hooks rules, component composition, prop patterns)
- Are there unnecessary re-renders, missing memoisation, or stale closure bugs?
- Are loading, error, and empty states handled consistently?
- Are client/server boundaries respected (Next.js RSC, use client, env vars)?
- Do the changes follow the component and naming conventions in `repo-context.md`?

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