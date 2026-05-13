# Behavioural Tests — /fastapi-agent

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-FA-01: Not invoked for non-FastAPI stacks

GIVEN `context/repo-context.md` lists Next.js as the framework  
WHEN `/implementation-plan` runs Step 1  
THEN `/fastapi-agent` is NOT invoked.

---

## BT-FA-02: Invoked when FastAPI detected

GIVEN `context/repo-context.md` lists FastAPI as the framework  
WHEN `/implementation-plan` runs Step 1  
THEN `/fastapi-agent` is invoked during spec challenge (Step 2).

---

## BT-FA-03: Unspecified 422 behaviour is surfaced

GIVEN a spec describes a POST endpoint  
AND the spec does not say what the API returns on validation failure  
WHEN `/fastapi-agent` reviews the spec  
THEN Claude flags the missing 422 behaviour as a Blocker.

---

## BT-FA-04: Schema defined after route handler is a phase ordering blocker

GIVEN Phase 1 adds a route handler  
AND Phase 2 defines the Pydantic schema the handler uses  
WHEN `/fastapi-agent` reviews the phase breakdown  
THEN Claude flags the ordering as a Blocker: schemas must be defined before handlers.

---

## BT-FA-05: response_model missing on route is a self-review finding

GIVEN a new FastAPI route has no `response_model` parameter  
WHEN `/fastapi-agent` reviews the diff  
THEN the finding is `issue (blocking)` citing the route file and line.

---

## BT-FA-06: Sync DB call in async handler is a self-review finding

GIVEN an async route handler contains a synchronous database call  
WHEN `/fastapi-agent` reviews the diff  
THEN the finding is `issue (blocking)` describing the blocking I/O risk.

---

## BT-FA-07: CORS wildcard is flagged

GIVEN `allow_origins=["*"]` and `allow_credentials=True` appear in the diff  
WHEN `/fastapi-agent` reviews the diff  
THEN the finding is `issue (blocking, security)` — this check is shared with `/security-agent` but `/fastapi-agent` also catches it.

---

## BT-FA-08: Planning findings returned to orchestrator

GIVEN `/fastapi-agent` produces planning findings  
WHEN the findings are produced  
THEN they are returned to the `/implementation-plan` orchestrator.  
AND `/fastapi-agent` does NOT write directly to `implementation-plan.md`.

---

## BT-FA-09: Self-review findings use correct source tag

GIVEN `/fastapi-agent` produces self-review findings  
WHEN findings are formatted  
THEN every finding ends with `*(source: fastapi-agent)*`.
