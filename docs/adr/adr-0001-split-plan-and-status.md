# ADR 0001 — Split Implementation Plan and Implementation Status

**Date:** 2025  
**Status:** Accepted  
**Deciders:** Gio

---

## Context

The original `/implementation-plan` skill used a single file to serve two purposes:
1. The static specification — what should be built and how
2. The live state — what has been done, what's in progress, what's pending

During execution, Claude reads this file to understand both intent and current state.
When both concerns live in the same document, ambiguity emerges:

- After a context clear, Claude may misread completed phases as pending
- A partially-completed phase leaves the document in an intermediate state that
  is hard to interpret correctly on reload
- The spec (which should be immutable after approval) gets mutated as state is updated
- It is impossible to tell whether a section represents an instruction or a record

This ambiguity becomes a silent failure mode — Claude proceeds with incorrect assumptions
about where the work stands, potentially re-executing completed phases or skipping pending ones.

---

## Decision

Split into two files with clearly separated responsibilities:

### `implementation-plan.md`
- Contains: feature intent, acceptance criteria, phase definitions, architectural notes
- Written by: human (with Claude as challenger during planning)
- Mutated by: nobody after human approval
- Status: **frozen** once the human approves the plan
- Scope changes: require a new planning session and explicit plan amendment

### `implementation-status.md`
- Contains: current phase, completed phases, gate outcomes, ADR notes per phase
- Written by: Claude (after each gate approval)
- Mutated by: Claude after each human-approved gate
- Status: **live document**, updated continuously throughout delivery

---

## Consequences

**Positive:**
- Claude always has an unambiguous source of intent (`plan`) vs. state (`status`)
- Context clears are safe — both files reload independently and serve distinct purposes
- The plan can be used as a reference for PR descriptions, retrospectives, and audits
  without being polluted by execution state
- Debugging a failed phase is easier: the plan shows what was intended, the status
  shows what actually happened

**Negative:**
- Two files to maintain instead of one
- Claude must be explicitly instructed to read both files at session start
- Minor duplication: phase names appear in both files

**Mitigations:**
- The CLAUDE.md for each project enforces the two-file pattern as a loading rule
- Phase names are the only duplicated element; all other content is distinct
