# Implementation Plan — [Feature Name]

> **Status:** DRAFT | APPROVED | AMENDED  
> **Approved by:** Gio  
> **Date approved:** [date]  
> **This file is READ-ONLY after approval. Any changes require a new planning session.**

---

## 1. Feature Summary

<!-- 2-3 sentences. What is being built and why. -->

---

## 2. Context & Motivation

<!-- Why now? What problem does this solve? What breaks if we don't build this? -->

---

## 3. Out of Scope

<!-- Explicitly list what is NOT being built in this implementation.
     This is as important as what IS in scope. -->

- [ ] [Item explicitly excluded]
- [ ] [Item explicitly excluded]

---

## 4. Acceptance Criteria

> These are translated directly into RED unit tests.
> Each criterion must be specific, observable, and testable.
> Vague criteria will be challenged during planning.

### AC-01: [Criterion name]
**Given:** [starting state]  
**When:** [action or event]  
**Then:** [observable outcome]  
**Edge cases:** [what else must be true]

### AC-02: [Criterion name]
**Given:**  
**When:**  
**Then:**  
**Edge cases:**

<!-- Add as many ACs as needed. Each AC becomes at least one unit test. -->

---

## 5. Failure Modes

<!-- What should happen when things go wrong? 
     These become RED tests too. -->

| Scenario | Expected behaviour |
|---|---|
| [Failure case] | [What the system should do] |
| [Failure case] | [What the system should do] |

---

## 6. Technical Approach

<!-- High-level architectural decisions. Not implementation details — those emerge during coding.
     Note any constraints from repo-context.md that apply here. -->

- **Approach:**
- **Affected files/modules:**
- **New dependencies required:**
- **Patterns to follow (from repo-context.md):**

---

## 7. Phase Breakdown

> Each phase is one atomic layer of work — small enough to commit independently.
> Phase order should minimise integration risk.

### Phase 1 — [Name]
**Scope:** [What this phase delivers]  
**ACs covered:** AC-01, AC-02  
**Dependencies:** None  

### Phase 2 — [Name]
**Scope:**  
**ACs covered:**  
**Dependencies:** Phase 1 complete  

### Phase 3 — [Name]
**Scope:**  
**ACs covered:**  
**Dependencies:** Phase 2 complete  

---

## 8. Risks & Open Questions

<!-- Things that are uncertain, risky, or need resolution before or during implementation. -->

| Risk / Question | Impact | Resolution |
|---|---|---|
| [Item] | High / Medium / Low | [How it will be resolved] |

---

## 9. Related

- ADR references:
- Linked tickets:
- Related PRs:
