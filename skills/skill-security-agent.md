# Skill: /security-agent

> **Type:** Specialist Agent
> **Trigger:** Invoked by `/self-review` during Stage 5. Can also be invoked directly.
> **Status:** L0 — PLACEHOLDER. Not yet implemented.
> **Maturity:** L0: Draft

---

## Purpose

Security specialist. Reviews the staged diff for vulnerabilities, insecure patterns,
and data exposure risks. Focuses on OWASP Top 10 and common application-level
security issues relevant to the detected stack.

---

## Responsibilities (to be specified)

**During self-review (Stage 5):**
- **Injection** — SQL, command, template, or expression injection vectors
- **Auth** — Broken authentication, missing authorisation checks, privilege escalation paths
- **Data exposure** — Sensitive data in logs, responses, error messages, or client-side code
- **Input validation** — Unvalidated or unsanitised inputs at system boundaries
- **IDOR** — Insecure direct object references (can a user access another user's resources?)
- **Dependency risk** — New dependencies introduced with known vulnerabilities
- **Secrets** — Hardcoded credentials, API keys, or tokens in the diff

Stack-specific checks (to be detailed per stack during implementation):
- React: XSS via dangerouslySetInnerHTML, exposed env vars to client
- FastAPI: unprotected endpoints, unsafe deserialization, CORS misconfiguration

---

## Inputs (to be specified)

- Staged diff
- `context/repo-context.md` (auth patterns, data sensitivity notes)
- `implementation-plan.md` (to understand what data and endpoints are involved)

---

## Output (to be specified)

- Conventional Comments format — `issue (blocking, security)`, `question (security)`,
  `suggestion (security)`, etc. Tagged with source agent `*(source: security-agent)*`.
- Security findings default to `(blocking)` unless clearly cosmetic — then `(non-blocking)`.
- Returned to `/self-review` orchestrator for consolidation.

---

## Notes for implementation

<!-- Populate when building this skill in Phase 2 -->
- [ ] Define stack-specific checklists (React, FastAPI, etc.)
- [ ] Define severity thresholds — all security findings blocking, or graduated?
- [ ] Define exact output format consistent with other review agents
- [ ] Consider: should this agent run on every phase, or only phases touching auth/data?
