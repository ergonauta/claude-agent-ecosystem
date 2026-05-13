# Behavioural Tests — /react-agent

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-RA-01: Not invoked for non-React stacks

GIVEN `context/repo-context.md` lists FastAPI as the stack  
WHEN `/implementation-plan` runs Step 1  
THEN `/react-agent` is NOT invoked.

---

## BT-RA-02: Invoked when React or Next.js detected

GIVEN `context/repo-context.md` lists Next.js as the framework  
WHEN `/implementation-plan` runs Step 1  
THEN `/react-agent` is invoked during spec challenge (Step 2).

---

## BT-RA-03: Unstated RSC decision is surfaced as blocker

GIVEN a spec describes a page that needs both server data and user interaction  
AND the spec does not state the rendering strategy  
WHEN `/react-agent` reviews the spec  
THEN Claude flags the missing RSC boundary decision as a Blocker in its planning output.

---

## BT-RA-04: Phase ordering violation is flagged

GIVEN Phase 1 creates a consuming page component  
AND Phase 2 creates the reusable component it uses  
WHEN `/react-agent` reviews the phase breakdown  
THEN Claude flags the ordering as a Blocker: reusable components must be built before consuming pages.

---

## BT-RA-05: 'use client' boundary pushed too high is a self-review finding

GIVEN a parent component is marked `'use client'` but only a leaf child needs interactivity  
WHEN `/react-agent` reviews the diff in self-review  
THEN the finding is `issue (blocking)` citing the parent component file and line.

---

## BT-RA-06: Stale closure bug in useEffect is a self-review finding

GIVEN a `useEffect` dependency array is missing a variable used inside the effect  
WHEN `/react-agent` reviews the diff  
THEN the finding is `issue (blocking)` citing the specific hook and the missing dependency.

---

## BT-RA-07: Planning findings returned to orchestrator, not written to plan

GIVEN `/react-agent` produces planning findings  
WHEN the findings are produced  
THEN they are returned to the `/implementation-plan` orchestrator.  
AND `/react-agent` does NOT write directly to `implementation-plan.md`.

---

## BT-RA-08: No findings produces explicit "no blocking concerns" message

GIVEN the spec and phase breakdown have no React-specific issues  
WHEN `/react-agent` completes its review  
THEN it returns: `## React/Next.js Specialist Review — No blocking concerns found.`  
AND it does NOT return an empty response.

---

## BT-RA-09: Self-review findings use correct source tag

GIVEN `/react-agent` produces self-review findings  
WHEN findings are formatted  
THEN every finding ends with `*(source: react-agent)*`.
