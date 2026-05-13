# Skill: /fastapi-agent

> **Type:** Specialist Agent
> **Trigger:** Invoked by `/implementation-plan` during planning when FastAPI stack detected. Can also be invoked directly.
> **Maturity:** L1: Specified
> **Status:** SPECIFIED — behavioural tests written; not yet human-verified

---

## Purpose

Expert specialist for FastAPI features. Validates phase scope, surfaces route design,
schema, dependency injection, and async concerns during planning.

---

## Responsibilities

**During spec challenge (Step 2):**
- Are the described behaviours achievable within FastAPI constraints?
- Are auth, validation, and error response behaviours explicitly stated, or assumed?
  If assumed: surface them as open questions that must be resolved before G1.
- FastAPI-specific edge cases to probe:
  - What should the API return on 422 (Pydantic validation failure)? Is this in the ACs?
  - If auth is involved: what dependency is used? Is the failure mode specified?
  - Are background tasks used? What happens if they fail — are errors observable?
  - Are there sync handlers that should be async (blocking I/O in sync handlers = starvation)?
- Are acceptance criteria testable with pytest + HTTPX (async test client)?

**During phase review (Step 3):**
- Schemas and Pydantic models must be defined before route handlers that use them — enforce this ordering.
- Dependency injection trees: no phase assumes a Depends() target that is built in a later phase.
- Are router includes in the correct order? (auth dependencies before data routes)

**During self-review (Stage 5):**
- Response models: is `response_model` set on all routes? Are all sensitive fields excluded from the schema?
- Status codes: 201 for creation, 204 for no-content deletes, 422 for validation, 401/403 for auth — check against ACs.
- Dependency scope: request-scoped vs. lifespan-scoped dependencies correctly assigned.
- Async hygiene: no `time.sleep()`, no sync DB calls in async handlers.
- 422 handling: does the route have a custom exception handler or does Pydantic's default schema leak?
- Do changes follow route and schema conventions in `repo-context.md`?

---

## Inputs

- `feature-spec.md`
- `context/repo-context.md`
- Proposed phase breakdown from `/implementation-plan`
- Diff (self-review only)

---

## Output Format

Same structure as `/react-agent`. See that skill for format specification.
Tag all self-review findings with `*(source: fastapi-agent)*`.

---

## G1 Integration

Same as `/react-agent` — returns findings to `/implementation-plan` orchestrator for merging. Does not write to plan directly.

---

## Behavioural Tests

See `tests/behaviours/skill-fastapi-agent.behaviour.md`.