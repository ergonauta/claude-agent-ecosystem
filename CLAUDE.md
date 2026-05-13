# Claude Agent Ecosystem — Project Context

## What This Repo Is

This is not a project that _uses_ the agent workflow system.
This is the project that _builds_ it.

You are the engineer working on this codebase.
The deliverable is a complete, tested, production-ready set of skills, workflows,
personas, and agents that can be used to deliver software features in other projects.

---

## Your Role in This Repo

You are building the system described in `docs/workflow.md`.
The docs describe the target state. Your job is to implement it.

When working in this repo you:

- Read the docs and ADRs to understand intent before writing anything
- Implement skill files that precisely match their specifications
- Write behavioural tests for every skill you implement
- Self-evaluate your output against those tests
- Flag gaps, contradictions, or missing specs before proceeding

You do not use the workflow to deliver features to other projects from here.
You build and refine the system itself.

---

## Repo Structure

```
claude-agent-ecosystem/
├── CLAUDE.md                          ← This file
├── README.md
├── docs/
│   ├── workflow.md                    ← High-level workflow (N stages)
│   ├── workflow-detailed.md           ← Phase-by-phase operational reference
│   └── adr/                           ← Architectural decision records
├── skills/
│   ├── orchestrators/                 ← Master workflow skills
│   ├── specialists/                   ← Domain-specific agents
│   └── workflow/                      ← Per-step skills (review, commits, PR)
├── personas/                          ← Advisory persona prompts (TODO)
├── tests/
│   ├── behaviours/                    ← Automated self-evaluation test files
│   └── checklists/                    ← Human verification checklists
├── templates/                         ← Reusable output file templates
├── .claude/commands/                  ← Symlinks to skills/ for slash commands
└── context/                           ← Generated repo context (gitignored)
```

---

## Skill Maturity Levels

Every skill file declares its maturity level in its header.
Never promote a skill without meeting the criteria.

| Level                  | Criteria                                              |
| ---------------------- | ----------------------------------------------------- |
| **L0: Draft**          | Skill file exists, no tests                           |
| **L1: Specified**      | Behavioural test file written                         |
| **L2: Self-verified**  | All behavioural tests PASS on dry-run                 |
| **L3: Human-verified** | Human checklist completed on at least one real run    |
| **L4: Production**     | L3 + no regressions across 3+ real feature deliveries |

---

## Session Start Protocol

Every session in this repo:

1. Read this file
2. Read `docs/workflow.md`
3. Check `implementation-status.md` for current state
4. Read the specific skill or doc being worked on before touching it

---

## Non-Negotiable Rules

- **Read before writing.** Always read relevant ADRs before modifying a skill.
- **No skill ships without a behavioural test file.** L0 → L1 before anything else.
- **No self-promotion of maturity levels.** Only the human promotes L2 → L3.
- **Contradictions are bugs.** If a skill contradicts an ADR, flag it — don't silently resolve it.
- **The docs are the spec.** If something isn't documented, it needs an ADR before being built.

---

## How to Evolve This System

When a pattern works or fails:

1. Discuss — don't silently change behaviour
2. Write a new ADR in `docs/adr/`
3. Update the affected skill and its behavioural test
4. Commit: `docs: update [component] — [reason]`
