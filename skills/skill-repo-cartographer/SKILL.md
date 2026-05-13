---
name: skill-repo-cartographer
description: Generate a structured snapshot of a codebase at context/repo-context.md. Run once per project onboarding or when repo structure changes significantly. Required before running /implementation-plan.
compatibility: Designed for Claude Code
metadata:
  type: Specialist
  trigger: /repo-cartographer
  maturity: L1: Specified
---

## Purpose

Perform a one-time deep read of a target codebase and produce `context/repo-context.md` —
a dense reference file that all subsequent agent skills load before acting.

This eliminates the need to re-explain codebase conventions, patterns, and structure
at the start of every feature session.

---

## When to Run

- First time using the agent ecosystem in a new project
- After significant architectural changes to the codebase
- When `context/repo-context.md` is more than 30 days old (or feels stale)

---

## Large Codebase Sampling

For repos with >50 directories or >1000 files: do not attempt full traversal.
Sample instead:

1. Read the top-level directory structure only (one level deep).
2. Identify the top 3 most-changed directories from `git log --stat --since="30 days ago" | grep "| " | sort -k3 -rn | head -20` — these are the most active areas.
3. Sample 2-3 files per active directory, prioritising test files and API route files.
4. Note in the output that sampling was used and which areas were covered.

For repos with ≤50 directories: read all.

---

## What to Read

Claude reads the following, in order:

1. **Project root** — `package.json`, `tsconfig.json`, `pyproject.toml`, `README.md`, `.eslintrc`, `.prettierrc`
2. **Directory structure** — top-level layout, `src/` structure, notable folders
3. **Entry points** — `index.ts`, `app.ts`, `main.ts`, `main.py`, `app.py` or equivalent
4. **Component/feature patterns** — sample files across 2-3 feature areas
5. **API/service patterns** — sample route handlers or service files
6. **Test patterns** — sample test files, test utilities, setup files
7. **Shared utilities** — common helpers, hooks, context providers, dependencies
8. **Type definitions** — key interfaces and types from `types/` or equivalent
9. **Existing ADRs** — if `docs/adr/` exists in the target project (read all)

---

## Output: `context/repo-context.md`

The output is a dense, Claude-readable reference — not documentation for humans.
Every line should change how an agent behaves. If it wouldn't affect behaviour, omit it.

Target: under 150 lines. Concise over comprehensive.

```markdown
# Repo Context — [Project Name]
Generated: [date]
Cartographer run by: /repo-cartographer

## Stack
- Language: TypeScript [version]
- Framework: [React / Next.js / Express / etc] [version]
- Test framework: [Jest / Vitest / etc] [version]
- Package manager: [npm / pnpm / yarn]

## Structure
[concise directory map — only what matters for feature work]

## Naming Conventions
- Components: PascalCase, co-located with test file
- Files: kebab-case
- Hooks: camelCase, prefix `use`
- Services: camelCase, suffix `Service`
- Types/interfaces: PascalCase, prefix `I` for interfaces (or not — document actual convention)

## Component Pattern
[actual example from the codebase — abbreviated]

## API/Service Pattern
[actual example — abbreviated]

## Test Pattern
[actual test file example — abbreviated]
- Test files: co-located / in `__tests__/` / in `tests/` [document actual pattern]
- Test command: `[npm test / pnpm test / etc]`
- Mocking approach: [jest.mock / MSW / custom / document actual]

## State Management
[document actual approach — Redux / Zustand / Context / etc]

## Key Shared Utilities
- [utility name]: [what it does, where it is]
- [utility name]: [what it does, where it is]

## Common Patterns to Follow
- [Pattern]: [brief description]
- Error handling: [how errors are handled in this codebase]
- Auth: [how auth is applied]

## Patterns to Avoid
- [Anti-pattern observed in codebase]: [why / what to do instead]

## Dependencies Worth Knowing
- [library]: [how it's used in this project]

## Open Questions / Gaps Observed
- [anything unclear or inconsistent in the codebase]
```

---

## After Generation

Present the generated `context/repo-context.md` to the human for review.

Ask specifically:
- "Are there conventions I missed?"
- "Are there patterns here that are actively being phased out?"
- "Is there any area of the codebase I should have sampled that I didn't?"

Update the file based on feedback before saving.

---

## Recent Changes Section

Append a `## Recent Changes` section to the output using:
```
git log --oneline --since="14 days ago" | head -10
```

This gives skills a quick signal of what areas are actively in flux, without requiring a full re-run.

---

## Behavioural Tests

See `tests/behaviours/skill-repo-cartographer.behaviour.md`.
