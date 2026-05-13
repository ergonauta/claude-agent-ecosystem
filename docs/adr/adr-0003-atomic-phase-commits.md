# ADR 0003 — Atomic Commits During Implementation, Not After

**Date:** 2025  
**Status:** Accepted  
**Deciders:** Gio

---

## Context

A known failure pattern with LLM-assisted development over extended sessions:

1. Claude implements Step A — it works
2. Claude implements Step B — it works
3. Claude implements Step C — something goes wrong
4. Claude attempts to fix C, inadvertently breaks A or B
5. By the time the session ends, working code from earlier steps has been degraded
   and there is no clean rollback point

This is the **LLM drift problem**: the model's context grows, it loses precise awareness
of earlier decisions, and fixing later problems introduces regressions in earlier work.

The conventional solution (committing at the end of implementation) does not help here —
the damage is already done before any commit happens.

A second concern: the original workflow had `/atomic-commits` as a post-implementation step,
where Claude would retroactively split a large diff into logical commits. This is unreliable.
Retroactive atomicity requires Claude to reason about the history of changes it made —
which is harder than committing atomically in the first place.

---

## Decision

Atomic commits are a **during-implementation** constraint, not a post-implementation cleanup step.

### The rule

Within a phase, each logical sub-step is committed before the next sub-step begins.

A "logical sub-step" is the smallest piece of work that:
- Makes a meaningful change (not a half-implemented feature)
- Leaves the codebase in a valid state (tests still pass)
- Can be described in one conventional commit message

### Enforcement

- Claude proposes a sub-step breakdown at the start of each GREEN phase
- Human approves the breakdown
- After each sub-step: Claude runs tests, confirms they pass, then commits
- Only after commit does Claude proceed to the next sub-step

### `/atomic-commits` skill scope redefined

The `/atomic-commits` skill is retained but its scope changes:

**Before this decision:** Generate commits from a large staged diff
**After this decision:** Review proposed sub-step commits for message quality and
conventional commits compliance before they are executed

---

## Consequences

**Positive:**
- Working code is protected at each sub-step — rollback is always one clean commit away
- LLM drift is bounded: if Claude goes sideways on sub-step N, sub-steps 1 through N-1
  are already committed and safe
- Retroactive commit splitting is eliminated — commits reflect actual development history
- The commit log becomes a meaningful record of how the feature was built

**Negative:**
- More overhead per phase — each sub-step requires a commit before proceeding
- Sub-step breakdown adds a step to phase startup
- Risk of over-granular commits if sub-steps are defined too narrowly

**Mitigations:**
- Sub-step breakdown is proposed by Claude and approved by human — granularity is a
  human judgment call
- Claude is instructed to err toward slightly coarser sub-steps (a meaningful change,
  not every file save)
