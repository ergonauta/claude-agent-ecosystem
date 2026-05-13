# Behavioural Tests — /architect-agent

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-AA-01: Invoked for features touching integration boundaries

GIVEN a spec describes a feature that calls an external service or crosses module boundaries  
WHEN `/implementation-plan` runs Step 2  
THEN `/architect-agent` is invoked.

---

## BT-AA-02: ADR requirement blocks G1

GIVEN `/architect-agent` determines the feature introduces a structural decision not yet captured  
WHEN the planning output is produced  
THEN Claude blocks G1 and tells the human an ADR is needed before proceeding.  
AND Claude states what the ADR should capture (e.g., "Choice of event bus for async notifications").

---

## BT-AA-03: G1 unblocked after ADR written

GIVEN G1 was blocked pending an ADR  
AND the human writes the ADR in `docs/adr/`  
WHEN `/architect-agent` reads the ADR  
THEN Claude removes the block and allows G1 to proceed.

---

## BT-AA-04: Coupling concern flagged in planning

GIVEN a spec describes data flow that creates tight coupling between two modules  
WHEN `/architect-agent` reviews the spec  
THEN the coupling is flagged as a Risk (non-blocking if solvable in plan, Blocker if it requires redesign).

---

## BT-AA-05: Phase spanning multiple services flagged

GIVEN a phase covers both a database schema change and an API route change in different services  
WHEN `/architect-agent` reviews the phase breakdown  
THEN Claude flags the phase as spanning multiple architectural layers and suggests a split.

---

## BT-AA-06: Self-review finding uses (arch) decoration

GIVEN `/architect-agent` finds a boundary violation in the diff  
WHEN the finding is formatted  
THEN the finding uses `issue (blocking, arch)` and ends with `*(source: architect-agent)*`.

---

## BT-AA-07: Distinct from tech-lead concerns

GIVEN a spec has both delivery sequencing concerns and architectural boundary concerns  
WHEN both agents review the spec  
THEN `/architect-agent` surfaces the boundary concern.  
AND `/tech-lead-agent` surfaces the sequencing concern.  
AND neither agent duplicates the other's finding.

---

## BT-AA-08: Planning findings returned to orchestrator

GIVEN `/architect-agent` produces planning findings  
WHEN the findings are produced  
THEN they are returned to the `/implementation-plan` orchestrator.  
AND `/architect-agent` does NOT write directly to `implementation-plan.md`.
