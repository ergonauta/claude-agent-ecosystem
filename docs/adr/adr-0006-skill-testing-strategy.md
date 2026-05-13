# ADR 0006 — Skill Testing Strategy: Behavioural Tests + Human Checklists

**Date:** 2025
**Status:** Accepted
**Deciders:** Gio

---

## Context

Skills in this ecosystem are prompt files — markdown documents that instruct Claude
to behave in a specific way. They cannot be unit tested like code.

A skill "works" when Claude, having read it, produces the correct output for a given
input in the correct format, following the correct sequence, and stopping at the correct
gates.

Two failure modes exist:

**Silent failure:** Claude reads the skill and does something plausible but wrong —
wrong format, missing a gate, skipping a step, misinterpreting a constraint.
Without a reference to compare against, this is invisible.

**Regression:** A skill is edited to fix one problem and silently breaks another
behaviour that was previously working.

Neither is catchable without a testing approach designed specifically for prompt-based systems.

---

## Decision

Two complementary testing mechanisms, used together:

---

### Mechanism 1 — Behavioural Test Files (Automated Self-Evaluation)

Each skill has a corresponding test file in `tests/behaviours/`.

A behavioural test file defines:
- **Context:** what files Claude has loaded (plan, status, repo-context)
- **Input:** the exact prompt or trigger
- **Expected output:** what a correct response looks like (format, content, gates, sequence)
- **Anti-patterns:** what a wrong response looks like (what Claude should NOT do)

Claude Code reads both the skill file and the test file, performs a dry-run,
then self-evaluates its output against the expected behaviour.

Self-evaluation produces a structured result:
```
PASS — [behaviour description]
FAIL — [behaviour description] — [what went wrong]
PARTIAL — [behaviour description] — [what was correct, what was missing]
```

**Limitation:** Claude evaluating its own output has inherent blind spots.
Self-evaluation catches structural failures (wrong format, missing steps, skipped gates)
more reliably than semantic failures (subtly wrong content that looks plausible).

---

### Mechanism 2 — Human Verification Checklists (Manual Sign-off)

Each skill has a corresponding checklist in `tests/checklists/`.

A checklist is a markdown file the human works through after a real or dry-run execution.
It asks specific, observable questions — not "did it seem right?" but
"did it produce a Gate G3 block in exactly this format?"

Checklists are the source of truth. Behavioural tests are the early warning system.

A skill is only considered production-ready when:
- All behavioural tests PASS
- The human has completed the checklist at least once on a real run

---

## Test File Structure

```
tests/
├── behaviours/
│   ├── implementation-plan.behaviour.md
│   ├── self-review.behaviour.md
│   ├── atomic-commits.behaviour.md
│   ├── gh-create-pr.behaviour.md
│   └── repo-cartographer.behaviour.md
└── checklists/
    ├── implementation-plan.checklist.md
    ├── self-review.checklist.md
    ├── atomic-commits.checklist.md
    ├── gh-create-pr.checklist.md
    └── repo-cartographer.checklist.md
```

---

## Skill Maturity Levels

A skill progresses through maturity levels:

| Level | Criteria |
|---|---|
| **L0: Draft** | Skill file exists, no tests |
| **L1: Specified** | Behavioural test file written |
| **L2: Self-verified** | All behavioural tests PASS on dry-run |
| **L3: Human-verified** | Checklist completed on at least one real run |
| **L4: Production** | L3 + no regressions across 3+ real feature deliveries |

Skills are not used in real projects until they reach L3 minimum.

---

## Consequences

**Positive:**
- Regressions are detectable — a skill edit triggers a re-run of its behavioural tests
- The checklist creates a forcing function for the human to actually verify behaviour
- Maturity levels give a clear signal of which skills are ready to use
- The test files double as documentation — they describe exactly what correct behaviour looks like

**Negative:**
- Writing behavioural tests requires thinking carefully about expected output format —
  this is non-trivial for complex skills
- Self-evaluation has limits — Claude will sometimes pass a test it should fail
- Checklist completion requires discipline — easy to skip when the output "looks fine"

**Mitigations:**
- Anti-pattern sections in behavioural tests help catch the most common self-evaluation blind spots
- Maturity levels create a formal gate that makes checklist-skipping visible
- Skills stay at L2 until checklist is done — they are not promoted automatically
