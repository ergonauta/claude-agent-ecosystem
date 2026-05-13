# Behavioural Test — [Skill Name]

> **Skill file:** `skills/[path]/[skill-name].md`
> **Maturity target:** L2 (Self-verified)
> **Last evaluated:** [date]
> **Result:** PENDING | PASS | FAIL | PARTIAL

---

## How to Run This Test

1. Open a fresh Claude Code session in this repo
2. Load: this file + the skill file being tested
3. Say: "Read the skill file and the behavioural test. Perform the dry-run
   described in each scenario. Self-evaluate your output against the expected
   behaviour. Produce a structured result for each scenario."
4. Record results in the `## Results` section at the bottom

---

## Scenarios

### Scenario 1 — [Name: happy path / core behaviour]

**Context loaded:**
```
- [file 1]
- [file 2]
```

**Input:**
```
[Exact prompt or trigger the human would use]
```

**Expected output:**
- [ ] [Specific observable thing that must be present]
- [ ] [Format requirement]
- [ ] [Gate or pause that must appear]
- [ ] [Content requirement]
- [ ] [Sequence requirement — e.g. "X must appear before Y"]

**Anti-patterns (must NOT appear):**
- [ ] [Thing Claude commonly does wrong here]
- [ ] [Shortcut or assumption that would invalidate the output]
- [ ] [Correct-looking but wrong behaviour]

---

### Scenario 2 — [Name: edge case / failure mode]

**Context loaded:**
```
- [file 1]
```

**Input:**
```
[Prompt that tests an edge case]
```

**Expected output:**
- [ ] [What correct handling looks like]

**Anti-patterns:**
- [ ] [What incorrect handling looks like]

---

### Scenario 3 — [Name: rejection / gate behaviour]

**Context loaded:**
```
- [file 1]
```

**Input:**
```
[Prompt that should trigger a gate or refusal to proceed]
```

**Expected output:**
- [ ] [Gate block appears in correct format]
- [ ] [Claude does not proceed past the gate autonomously]

**Anti-patterns:**
- [ ] [Claude proceeds without waiting for approval]

---

## Self-Evaluation Instructions for Claude

After performing each dry-run, produce this block for each scenario:

```
## Scenario [N] — [Name]
Result: PASS | FAIL | PARTIAL

Checklist:
- [✅/❌] [Expected item 1]
- [✅/❌] [Expected item 2]
...

Anti-patterns:
- [✅ avoided / ❌ present] [Anti-pattern 1]
...

Notes: [anything relevant about the output quality]
```

---

## Results

<!-- Filled in after each evaluation run -->

### Run 1 — [date]

[paste self-evaluation output here]

**Overall:** PASS | FAIL | PARTIAL
**Action:** Promote to L2 | Fix skill and re-run | Investigate

---

## Known Limitations

<!-- Things this test cannot catch — record honestly -->
- [Semantic failure this test won't detect]
- [Scenario not covered by these tests]
