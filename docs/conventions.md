# Conventions

This repo uses two external formatting standards. This document explains what each
is, where it is applied in the workflow, and links to the canonical specification.

---

## Conventional Commits

**What:** A specification for structuring git commit messages to communicate intent
and support automated tooling.

**Canonical spec:** https://www.conventionalcommits.org/en/v1.0.0/

**Format:**
```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

**Where used in this ecosystem:**
- **Stage 4 — GREEN** (sub-step commits during implementation)
- **Stage 6 — Commit** (final phase commit set, proposed at Gate G6)
- **`/atomic-commits` skill** — enforces this format, proposes before executing

**Types used:**

| Type | Use for |
|---|---|
| `feat` | New feature or behaviour |
| `fix` | Bug fix |
| `test` | Adding or modifying tests |
| `refactor` | Code change with no behaviour change |
| `docs` | Documentation only |
| `chore` | Maintenance, config, dependencies |
| `perf` | Performance improvement |
| `style` | Formatting — no logic change |
| `ci` | CI/CD config |
| `build` | Build system or tooling |

**Ecosystem-specific footer:** every commit MUST include:
```
Refs: implementation-plan.md Phase N
```

**Breaking changes:** use `!` after type (`feat!:`) or `BREAKING CHANGE:` footer.
`BREAKING CHANGE` MUST be uppercase.

---

## Conventional Comments

**What:** A specification for structuring code review comments to make intent,
severity, and required action immediately clear.

**Canonical spec:** https://conventionalcomments.org/

**Format:**
```
<label> [decorations]: <subject>

[discussion]
```

**Where used in this ecosystem:**
- **Stage 5 — Self Review** (all findings from the review panel)
- **`/self-review` skill** — each persona produces CC-formatted findings
- **`self-review-phase-N.md`** summary document

**Labels used:**

| Label | Meaning | Blocking by default? |
|---|---|---|
| `issue` | Specific problem | Yes |
| `todo` | Small, necessary change | Yes |
| `chore` | Task required before acceptance | Yes |
| `suggestion` | Improvement proposal | Depends on decoration |
| `question` | Potential concern — ask first | No |
| `nitpick` | Trivial preference | No |
| `thought` | Non-blocking idea | No |
| `note` | Informational, no action needed | No |
| `praise` | Genuine positive | N/A |

**Decorations used:**

| Decoration | Meaning |
|---|---|
| `(blocking)` | Must resolve before commit |
| `(non-blocking)` | Should not prevent acceptance |
| `(if-minor)` | Resolve only if the change is trivial |
| `(security)` | Security domain |
| `(test)` | Test quality domain |
| `(perf)` | Performance domain |
| `(arch)` | Architectural domain |

**Ecosystem-specific addition:** every finding includes a source persona tag:
```
`issue (blocking, security)` `auth/login.ts:42` — JWT not validated *(Security Engineer)*
```
