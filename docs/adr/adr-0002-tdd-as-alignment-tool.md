# ADR 0002 — TDD as an Alignment Tool, Not Just a Testing Practice

**Date:** 2025  
**Status:** Accepted  
**Deciders:** Gio

---

## Context

The conventional failure mode of AI-assisted development:

1. Human gives Claude a vague feature description
2. Claude implements something plausible
3. Claude writes tests that validate the implementation
4. Tests pass — but the implementation was misaligned from the start
5. The tests are now evidence of the wrong behaviour, not the right one

This is not a testing problem. It is an alignment problem.
Tests written *after* implementation can only verify what was built, not what was wanted.

A secondary problem: when Claude writes tests after implementation, it tends to test
implementation details (internal function calls, intermediate state) rather than
observable behaviour. These tests are brittle and provide false confidence.

---

## Decision

Adopt TDD not primarily as a quality practice, but as an **alignment forcing function**.

The RED phase (writing failing tests) serves a specific purpose in this workflow:
**it forces the human to validate their own requirements before implementation begins.**

### The mechanism

1. Human approves the plan — acceptance criteria are written in plain language
2. Claude translates acceptance criteria into executable tests (RED)
3. Human reviews the tests against their original intent
4. Discrepancies between what the human *thought* they specified and what the tests
   *actually* assert surface at this point — before any implementation exists
5. Human approves RED tests — this is the true alignment gate
6. Only then does implementation begin

If the tests don't match the intent, the spec was ambiguous. Fix the spec.
If the tests match the intent but feel wrong, the intent was wrong. Revisit the plan.

### Rules enforced by this decision

- Claude writes tests **before** any implementation code in a phase
- Tests describe **behaviour**, not implementation (`it('returns 401 when token expired')`,
  not `it('calls validateToken()')`)
- The human runs the tests and confirms they fail **for the right reason** before approving
- Claude does not proceed to GREEN until RED is explicitly approved

---

## Consequences

**Positive:**
- Misalignment is caught at the cheapest possible moment (before any code exists)
- The human is forced to think precisely about what they want — not just describe it loosely
- Tests become a living spec, not an afterthought
- Behaviour-focused tests are more resilient to refactoring
- Debugging is easier: failing tests point to behaviour, not implementation internals

**Negative:**
- Slower start — the human must engage deeply with the test review gate
- Some acceptance criteria are hard to express as unit tests
  (UI behaviour, async race conditions, third-party integrations)
- Requires the human to understand the tests well enough to validate them

**Mitigations:**
- For criteria that are hard to unit test, Claude flags them explicitly and proposes
  alternatives (integration test, manual checklist item, or deferred to QA phase)
- The plan review phase (Phase 1) identifies these cases before RED begins
