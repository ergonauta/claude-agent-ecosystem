# Skill: /stacked-branches

> **Type:** Specialist — Branching Strategy Planner
> **Trigger:** Invoked by `/implementation-plan` during Step 3 (phase breakdown) when more than one PR boundary is identified. Can also be invoked directly.
> **Maturity:** L1: Specified
> **Status:** SPECIFIED — behavioural tests written; not yet human-verified

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

## Behaviour

### Step 1 — Receive phase list

Accept the proposed phase list from `/implementation-plan` Step 3.
Read `context/repo-context.md` for existing branching conventions (use them if present;
fall back to conventions below if not defined).
Read `feature-spec.md` for delivery intent and reuse expectations.

### Step 2 — Assign phases to concern layers

For each phase, assign it to one concern layer:

| Layer | What belongs here |
|---|---|
| **generic** | Reusable components, utilities, data structures with no feature-specific knowledge |
| **domain** | Business logic, data manipulation, parsing, transformations dependent on generic layer |
| **integration** | Feature-specific assembly: routing, page composition, wiring domain + generic |

If a phase spans two layers (adds both a generic component AND feature-specific wiring),
split the phase — flag this to the human before finalising. Do not silently assign to the
larger layer.

If the concern layer model does not fit (e.g., backend-only feature), use the natural
dependency order instead: phases that can be merged without others go first.

### Step 3 — Validate independent mergeability

For each proposed PR (set of phases), verify:
- No phase in this PR depends on an unmerged phase from a later PR.
- The PR can be code-reviewed in isolation without requiring context from later PRs.

If a dependency crosses PR boundaries in the wrong direction (later PR is a prerequisite
for an earlier one), flag and propose a reorder.

### Step 4 — Assign branch names

Convention (if no project convention exists in `repo-context.md`):

```
feature/<feature-name>/pr-<N>-<layer>
```

Examples:
```
feature/user-auth/pr-1-generic
feature/user-auth/pr-2-domain
feature/user-auth/pr-3-integration
```

If single PR: branch is `feature/<feature-name>` — no layer suffix needed.

### Step 5 — Define branch creation responsibility

Claude proposes branch names. Human creates branches, OR Claude creates them
if `git` Bash permission is available in the session.

At the end of this skill, Claude states which branches need to exist before RED starts
for the first phase, and instructs the human to create them (or offers to do so).

### Step 6 — Produce the stacked plan

Embed the plan into `implementation-plan.md` under `## Branching Strategy`.
Also record the current active branch in `implementation-status.md` (updated per phase as work progresses).

### Step 7 — Flag single-phase PRs

If a PR stack contains only one phase, flag it: stacking may not be worth the overhead.
Ask the human whether to merge the phases into adjacent stacks or keep them separate.

---

## How `/gh-create-pr` Knows Which Stack Level to Open

`implementation-status.md` tracks the current active PR stack. After all phases in a stack
are committed and G6-approved, `/gh-create-pr` reads the `Current PR Stack` field from
`implementation-status.md` to determine which branch and PR template to use.

Format in `implementation-status.md`:
```
Current PR Stack: PR 1 — Generic (feature/user-auth/pr-1-generic → main)
```

After that PR merges, update this field to the next stack.

---

## Inputs

- Proposed phase list from `/implementation-plan` Step 3
- `feature-spec.md` (delivery intent, reuse expectations)
- `context/repo-context.md` (branching conventions)

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

## Behavioural Tests

See `tests/behaviours/skill-stacked-branches.behaviour.md`.
