# Skill: /stacked-branches

> **Type:** Specialist — Branching Strategy Planner
> **Trigger:** Invoked by `/implementation-plan` during Step 3 (phase breakdown) when more than one PR boundary is identified. Can also be invoked directly.
> **Status:** L0 — PLACEHOLDER. Not yet implemented.
> **Maturity:** L0: Draft

---

## Purpose

Formalise a stacked branching plan during planning — not reactively after implementation
reveals scope is too large. Analyses the proposed phase breakdown by concern, identifies
natural PR boundaries, and produces a branch dependency map that drives the full
RED → GREEN → SELF-REVIEW → COMMIT → PR loop per stack level.

---

## When to invoke

During Planning Step 3, Claude identifies PR boundaries by asking:
*what can be merged and used independently, before the rest of the feature exists?*

Invoke `/stacked-branches` when the answer is: more than one PR.

Do **not** invoke based on line count or phase count alone. The trigger is concern
separation — phases that belong to independent, mergeable layers.

---

## Concern layers (typical)

| Layer | What belongs here | Can merge when |
|---|---|---|
| **Generic / shared** | Reusable components, utilities, data structures with no feature-specific knowledge | Immediately — other features may depend on this |
| **Domain / data** | Business logic, data manipulation, parsing, transformations | After generic layer merged (if it depends on it) |
| **Integration** | Feature-specific assembly: wiring components with domain logic, routing, page composition | After both layers above are merged |

These layers are a guide, not a formula. The phase breakdown drives the grouping —
not the other way around.

---

## Responsibilities (to be specified)

1. Receive the proposed phase list from `/implementation-plan`
2. Group phases into PR stacks by concern layer
3. Validate that each stack is independently mergeable (no forward dependencies)
4. Identify dependency order: which PRs must merge before others can open
5. Produce the stacked branch plan (see Output below)
6. Flag any phase that cannot be cleanly assigned to one stack — present to human
   for resolution before G1

---

## Inputs (to be specified)

- Proposed phase list from Step 3
- `feature-spec.md` (to understand delivery intent and reuse expectations)
- `context/repo-context.md` (branching conventions, existing shared component patterns)

---

## Output (to be specified)

Stacked branch plan embedded into `implementation-plan.md` under a `## Branching Strategy` section:

```markdown
## Branching Strategy

Type: stacked (N PRs)

### PR 1 — Generic Components
Branch: `feature/[name]-generic`
Phases: [list]
Depends on: `main`
Merges into: `main`

### PR 2 — Data Layer
Branch: `feature/[name]-data`
Phases: [list]
Depends on: PR 1 merged
Merges into: `main`

### PR 3 — Integration
Branch: `feature/[name]-integration`
Phases: [list]
Depends on: PR 1 + PR 2 merged
Merges into: `main`
```

If single PR: section reads `Type: single PR` — no branch map needed.

---

## Interaction with other skills

- `/implementation-plan` — invokes this skill; embeds output into plan before G1
- `/gh-create-pr` — opens one PR per stack level, in dependency order, after all phases in that stack are committed and approved
- `/atomic-commits` — operates per phase within a stack; `Refs:` footer includes both phase and PR stack level

---

## Notes for implementation

<!-- Populate when building this skill -->
- [ ] Define how to handle phases that span concern layers (e.g. a phase that adds both a generic component and feature-specific wiring)
- [ ] Define what happens when a PR stack has only one phase — is it still worth stacking?
- [ ] Define branching naming conventions
- [ ] Define whether Claude creates branches or instructs human to do so
- [ ] Define how `/gh-create-pr` knows which stack level to open next
