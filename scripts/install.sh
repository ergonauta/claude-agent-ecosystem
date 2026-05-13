#!/usr/bin/env bash
# Install Claude Agent Ecosystem skills into a target project.
#
# Usage:
#   ./scripts/install.sh <target-project-dir> [skill ...]
#
# If no skills are specified, the default set is installed.
# Skill names match the slash command (e.g. "atomic-commits", "self-review").
#
# Flags:
#   --force   Overwrite existing symlinks
#   --copy    Copy files instead of symlinking (use when ecosystem is not on every machine)
#   --list    Print available skills and exit

set -euo pipefail

ECOSYSTEM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$ECOSYSTEM_DIR/skills"

DEFAULT_SKILLS=(
  atomic-commits
  gh-create-pr
  implementation-plan
  repo-cartographer
  self-review
)

# --- flags ---
FORCE=0
COPY=0
LIST=0
TARGET=""
REQUESTED_SKILLS=()

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --copy)  COPY=1 ;;
    --list)  LIST=1 ;;
    -*) echo "Unknown flag: $arg" >&2; exit 1 ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$arg"
      else
        REQUESTED_SKILLS+=("$arg")
      fi
      ;;
  esac
done

# --- list mode ---
if [[ "$LIST" -eq 1 ]]; then
  echo "Available skills:"
  for f in "$SKILLS_DIR"/skill-*.md; do
    name="$(basename "$f" .md | sed 's/^skill-//')"
    printf "  %s\n" "$name"
  done
  exit 0
fi

# --- validate target ---
if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <target-project-dir> [skill ...]" >&2
  echo "       $0 --list" >&2
  exit 1
fi

if [[ ! -d "$TARGET" ]]; then
  echo "Error: target directory does not exist: $TARGET" >&2
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"
COMMANDS_DIR="$TARGET/.claude/commands"

# --- resolve skill list ---
if [[ "${#REQUESTED_SKILLS[@]}" -gt 0 ]]; then
  SKILLS=("${REQUESTED_SKILLS[@]}")
else
  SKILLS=("${DEFAULT_SKILLS[@]}")
fi

# --- install ---
mkdir -p "$COMMANDS_DIR"

installed=0
skipped=0
errors=0

for skill in "${SKILLS[@]}"; do
  src="$SKILLS_DIR/skill-${skill}.md"
  dst="$COMMANDS_DIR/${skill}.md"

  if [[ ! -f "$src" ]]; then
    echo "  SKIP  $skill  (skill file not found: $src)" >&2
    ((errors++)) || true
    continue
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ "$FORCE" -eq 0 ]]; then
      echo "  SKIP  $skill  (already exists — use --force to overwrite)"
      ((skipped++)) || true
      continue
    fi
    rm "$dst"
  fi

  if [[ "$COPY" -eq 1 ]]; then
    cp "$src" "$dst"
    echo "  COPY  $skill"
  else
    ln -s "$src" "$dst"
    echo "  LINK  $skill  →  $src"
  fi
  ((installed++)) || true
done

echo ""
echo "Done. $installed installed, $skipped skipped, $errors errors."
echo "Skills land in: $COMMANDS_DIR"

if [[ "$COPY" -eq 0 ]]; then
  echo ""
  echo "Note: symlinks point to $ECOSYSTEM_DIR"
  echo "      If this path differs on other machines, re-run with --copy."
fi
