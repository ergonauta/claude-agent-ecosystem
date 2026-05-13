# Behavioural Tests — /repo-cartographer

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-RC-01: Output is under 150 lines

GIVEN any codebase  
WHEN `/repo-cartographer` generates `context/repo-context.md`  
THEN the output is under 150 lines.  
AND every line is actionable — no filler, no section headers with empty content.

---

## BT-RC-02: Generated date is in output header

WHEN `/repo-cartographer` writes `context/repo-context.md`  
THEN the file contains a `Generated: YYYY-MM-DD` line in the header.

---

## BT-RC-03: Large repo triggers sampling strategy

GIVEN a repo with > 50 directories  
WHEN `/repo-cartographer` runs  
THEN Claude uses `git log --stat --since="30 days ago"` to find the most active directories.  
AND Claude samples 2-3 files per active directory rather than attempting full traversal.  
AND the output notes that sampling was used.

---

## BT-RC-04: ADRs are read when present

GIVEN `docs/adr/` exists in the target project and contains ADR files  
WHEN `/repo-cartographer` runs  
THEN all ADR files are read.  
AND the repo context output references relevant ADRs.

---

## BT-RC-05: Recent changes section is appended

WHEN `/repo-cartographer` generates the output  
THEN a `## Recent Changes` section is appended with the last 10 commits from the past 14 days.

---

## BT-RC-06: Human review questions are asked after generation

WHEN `/repo-cartographer` finishes writing `context/repo-context.md`  
THEN Claude asks the human: "Are there conventions I missed?", "Any patterns being phased out?", "Areas I should have sampled that I didn't?"  
AND Claude updates the file based on answers before finalising.

---

## BT-RC-07: Patterns-to-avoid section is present if anti-patterns observed

GIVEN the codebase contains inconsistent patterns (e.g., two different state management approaches)  
WHEN Claude writes the output  
THEN the `## Patterns to Avoid` section documents the inconsistency and recommends which to follow.

---

## BT-RC-08: Stack field is present and accurate

WHEN `/repo-cartographer` generates the output  
THEN the `## Stack` section contains: Language, Framework, Test framework, Package manager.  
AND the values are extracted from actual config files (package.json, pyproject.toml, etc.), not guessed.
