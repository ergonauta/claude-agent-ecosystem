# Behavioural Tests — /stacked-branches

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-SB-01: Not invoked for single-PR features

GIVEN all phases in the feature belong to one concern layer  
WHEN `/implementation-plan` Step 3 completes  
THEN `/stacked-branches` is NOT invoked.  
AND `implementation-plan.md` `## Branching Strategy` reads `Type: single PR`.

---

## BT-SB-02: Invoked when >1 PR boundary detected

GIVEN phases span multiple concern layers (e.g., generic + integration)  
WHEN `/implementation-plan` Step 3 identifies multiple PR boundaries  
THEN `/stacked-branches` is invoked before G1 is presented.  
AND the stacked plan is embedded in `implementation-plan.md` before G1.

---

## BT-SB-03: Phase spanning two layers triggers split

GIVEN a phase adds both a reusable component (generic) and feature-specific routing (integration)  
WHEN `/stacked-branches` processes it  
THEN Claude flags the phase as spanning two layers.  
AND Claude proposes a split of the phase into two.  
AND Claude does not silently assign it to one layer.  
AND Claude presents the split to the human for resolution before finalising.

---

## BT-SB-04: Branching convention uses repo-context first

GIVEN `context/repo-context.md` defines a branching convention  
WHEN `/stacked-branches` assigns branch names  
THEN the branch names follow the project convention.

---

## BT-SB-05: Falls back to default convention when none defined

GIVEN `context/repo-context.md` does not define a branching convention  
WHEN `/stacked-branches` assigns branch names  
THEN branch names follow `feature/<feature-name>/pr-<N>-<layer>`.

---

## BT-SB-06: Dependency order is validated

GIVEN PR 2 (domain) depends on PR 1 (generic)  
WHEN `/stacked-branches` validates mergeability  
THEN PR 1 is listed as `Depends on: main`.  
AND PR 2 is listed as `Depends on: PR 1 merged`.  
AND no forward dependency exists (PR 1 does not reference PR 2).

---

## BT-SB-07: Wrong-direction dependency triggers reorder

GIVEN a phase in PR 1 imports a component only defined in PR 2  
WHEN `/stacked-branches` validates mergeability  
THEN Claude flags the dependency crossing.  
AND Claude proposes a reorder or phase reassignment before finalising.

---

## BT-SB-08: Single-phase PR is flagged

GIVEN a PR stack would contain only one phase  
WHEN `/stacked-branches` produces the plan  
THEN Claude flags that stacking may not be worth the overhead.  
AND Claude asks the human whether to merge it into an adjacent stack or keep it separate.

---

## BT-SB-09: implementation-status.md tracks active PR stack

GIVEN the stacked plan is approved at G1  
WHEN the first RED phase begins  
THEN `implementation-status.md` contains a `Current PR Stack` field naming the active branch and merge target.

---

## BT-SB-10: Branch creation is instructed or offered

GIVEN the stacked plan is finalised  
WHEN `/stacked-branches` completes  
THEN Claude either instructs the human to create the branches, OR offers to create them if git Bash permission is available.  
AND Claude states which branches must exist before RED for Phase 1 begins.
