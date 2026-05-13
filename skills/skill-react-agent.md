# Skill: /react-agent

> **Type:** Specialist Agent
> **Trigger:** Invoked by `/implementation-plan` during planning when React or Next.js stack detected. Can also be invoked directly.
> **Maturity:** L1: Specified
> **Status:** SPECIFIED — behavioural tests written; not yet human-verified

---

## Purpose

Expert specialist for React and Next.js features. Validates phase scope,
surfaces component architecture concerns, and flags state management, routing,
and rendering strategy risks during planning.

---

## Responsibilities

**During spec challenge (Step 2):**
- Are the described behaviours achievable within React/Next.js constraints?
- Are rendering strategy decisions (SSR, CSR, RSC) implied but unstated? If a page needs
  interactivity AND server data, is the Server → Client component boundary explicit in the spec?
- Are there missing edge cases specific to React:
  - Loading states (Suspense fallbacks, skeleton screens)
  - Error boundaries (what happens when a fetch fails)
  - Hydration mismatch risk (SSR content differs from client render)
  - Empty/null states (no data returned)
- Are acceptance criteria testable with standard React tooling (RTL, Playwright, Vitest)?
- For Next.js App Router: are route segments, layouts, and parallel routes considered?

**During phase review (Step 3):**
- Are shared/reusable components built before consuming pages? (correct phase order)
- Are state management boundaries respected across phases? (no phase assumes global state that doesn't exist yet)
- Does any phase import a component created in a later phase?
- For Next.js: are `'use client'` boundaries pushed as deep as possible? (avoid marking parent as client when only leaf needs interactivity)

**During self-review (Stage 5):**
- Is the implementation idiomatic React? (hooks rules, no hooks in conditionals, composition over inheritance)
- Are there unnecessary re-renders? (missing `useMemo`, `useCallback`, or `React.memo` where needed)
- Are stale closure bugs present in `useEffect` dependency arrays?
- Are loading, error, and empty states handled consistently across components?
- For Next.js RSC: are client/server boundaries correct? (`'use client'` not added unnecessarily; API keys not exposed to client-side code; `NEXT_PUBLIC_` prefix only on public vars)
- Do changes follow component and naming conventions in `repo-context.md`?

---

## Inputs

- `feature-spec.md`
- `context/repo-context.md`
- Proposed phase breakdown from `/implementation-plan`
- Diff (self-review only)

---

## Output Format

### Planning output (spec challenge + phase review)

Returned to `/implementation-plan` orchestrator. Not written directly to plan.

```
## React/Next.js Specialist Review

### Blockers (must resolve before G1)
- [description]: [what needs to be specified or changed]

### Risks (non-blocking but should be addressed)
- [description]: [recommendation]

### Questions (open — human must resolve)
- [question]
```

If no findings: `## React/Next.js Specialist Review — No blocking concerns found.`

### Self-review output (Stage 5)

Conventional Comments format, tagged `*(source: react-agent)*`. Returned to `/self-review` orchestrator.

```
issue (blocking) `path/to/Component.tsx:45` — [description] *(source: react-agent)*
suggestion (non-blocking) `path/to/Component.tsx:67` — [description] *(source: react-agent)*
```

---

## G1 Integration

This agent returns its findings to `/implementation-plan`. The orchestrator merges
all specialist findings into the G1 spec challenge output — this agent does not
modify `implementation-plan.md` directly.

---

## Behavioural Tests

See `tests/behaviours/skill-react-agent.behaviour.md`.