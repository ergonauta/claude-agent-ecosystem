# Skill: /repo-cartographer

> **Type:** Specialist  
> **Trigger:** `/repo-cartographer`  
> **Status:** DRAFT — to be refined based on usage

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

## What to Read

Claude reads the following, in order:

1. **Project root** — `package.json`, `tsconfig.json`, `README.md`, `.eslintrc`, `.prettierrc`
2. **Directory structure** — top-level layout, `src/` structure, notable folders
3. **Entry points** — `index.ts`, `app.ts`, `main.ts` or equivalent
4. **Component patterns** — sample React components across 2-3 feature areas
5. **API/service patterns** — sample route handlers or service files
6. **Test patterns** — sample test files, test utilities, setup files
7. **Shared utilities** — common helpers, hooks, context providers
8. **Type definitions** — key interfaces and types from `types/` or equivalent
9. **Existing ADRs** — if `docs/adr/` exists in the target project

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

## Notes for refinement

<!-- Add observations from real usage here -->
- [ ] Define how to handle very large codebases (sampling strategy)
- [ ] Define staleness detection — when should the human be prompted to re-run?
- [ ] Consider adding a "recent changes" section from git log
