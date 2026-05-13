# Behavioural Tests — /tech-lead-agent

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-TL-01: Runs after stack specialists, not before

GIVEN both `/react-agent` and `/tech-lead-agent` are invoked for the same planning session  
WHEN `/tech-lead-agent` produces its planning output  
THEN it reads `/react-agent` findings first.  
AND it does not duplicate concerns already raised by `/react-agent`.

---

## BT-TL-02: Implicit shared infra concern is surfaced as blocker

GIVEN a spec implies a DB schema change but no phase covers the migration  
WHEN `/tech-lead-agent` reviews the spec  
THEN Claude flags the missing migration as a Blocker.

---

## BT-TL-03: Backwards compatibility concern is surfaced

GIVEN a spec adds a new DB column and the old code will run against the new schema during incremental deploy  
WHEN `/tech-lead-agent` reviews the spec  
THEN Claude flags the backwards compatibility risk.  
AND Claude suggests a zero-downtime migration approach (column nullable first, then backfill).

---

## BT-TL-04: Unrealistic scope is flagged

GIVEN a spec covers 8 distinct behavioural areas in a single feature  
WHEN `/tech-lead-agent` reviews the scope  
THEN Claude flags the scope as potentially too large for one delivery.  
AND Claude suggests natural split points.

---

## BT-TL-05: Scope creep in diff is a blocking self-review finding

GIVEN the diff contains changes to a file outside the current phase scope  
WHEN `/tech-lead-agent` reviews the diff in self-review  
THEN the finding is `issue (blocking)` citing the out-of-scope file.

---

## BT-TL-06: Creative interpretation of plan is flagged

GIVEN the implementation deviates from the plan's stated AC without a plan revision  
WHEN `/tech-lead-agent` reviews the diff  
THEN the finding is `issue (blocking)` describing the deviation.

---

## BT-TL-07: Missing observability is a non-blocking finding

GIVEN a new API endpoint has no logging or metrics  
AND no observability AC exists in the plan  
WHEN `/tech-lead-agent` reviews the spec or diff  
THEN the finding is `suggestion (non-blocking)` noting the observability gap.

---

## BT-TL-08: Planning findings returned to orchestrator

GIVEN `/tech-lead-agent` produces planning findings  
WHEN the findings are produced  
THEN they are returned to the `/implementation-plan` orchestrator.  
AND `/tech-lead-agent` does NOT write directly to `implementation-plan.md`.

---

## BT-TL-09: Self-review findings use correct source tag

GIVEN `/tech-lead-agent` produces self-review findings  
WHEN findings are formatted  
THEN every finding ends with `*(source: tech-lead-agent)*`.
