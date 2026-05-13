# ADR 0005 — Deliberate Context Clearing Between Phases

**Date:** 2025  
**Status:** Accepted  
**Deciders:** Gio

---

## Context

Large language models degrade in a predictable way as context windows fill:

- Earlier instructions receive less attention than recent ones
- Contradictions introduced later in the conversation can override earlier decisions
- The model's reasoning becomes less precise as it tries to hold more state
- Long sessions accumulate "conversational drift" — the model subtly shifts its
  interpretation of requirements based on the accumulated conversation

In a multi-phase implementation workflow, this means:
- Phase 1 decisions can be silently overridden by Phase 3 conversation
- The model may lose track of the original acceptance criteria
- Self-imposed constraints (code style, architectural patterns) erode over time

The naive solution — keeping context open across all phases — maximises convenience
but accumulates these risks progressively.

---

## Decision

Context is deliberately cleared after each approved gate. This is not a workaround
for context limits — it is a quality control mechanism.

### What survives a context clear

Three files are always reloaded at the start of each new phase session:

1. `implementation-plan.md` — the frozen spec (survives compaction in Claude Code)
2. `implementation-status.md` — current state, last ADR note, completed phases
3. `context/repo-context.md` — codebase conventions

Everything else is reconstructed from these three files.

### What is lost and why that is acceptable

Conversational history from previous phases is intentionally discarded.
This is acceptable because:

- All decisions made during a phase are recorded in `implementation-status.md` before clearing
- The ADR note appended after each gate captures the *why* behind decisions
- The plan file captures the *what*
- Code written during the phase is committed before clearing — it's in git, not in context

Nothing valuable lives only in the conversation. If it matters, it was written down.

### The ADR note as context bridge

Before every context clear, Claude appends a brief note to `implementation-status.md`:

```markdown
## Phase N ADR Note — [date]
**Decision:** <what was decided or implemented>
**Rationale:** <why this approach, not alternatives>
**Trade-offs:** <what was accepted or deferred>
**Next phase starts with:** <any critical context the next session must know>
```

The "Next phase starts with" field is specifically designed to bridge context clears —
it captures anything that would otherwise be lost and is needed in the next session.

---

## Consequences

**Positive:**
- Each phase starts with a clean, focused context — model quality is reset
- No conversational drift accumulating across phases
- Forces discipline: anything important must be written down, not held in conversation
- Makes the workflow resilient to interruptions — any phase can be resumed by any
  Claude Code session with the same three files

**Negative:**
- Requires discipline to reload the three files at the start of every session
- Subtle context that *wasn't* captured in the ADR note is lost
- Can feel disjointed if the human is used to continuous conversation-based workflows

**Mitigations:**
- CLAUDE.md for each project enforces the three-file loading rule
- The ADR note format includes a mandatory "Next phase starts with" field
  to surface implicit context before it's lost
- The `/implementation-plan` skill includes a session-start checklist that
  verifies the three files are loaded before proceeding
