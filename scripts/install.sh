#!/usr/bin/env bash
# install.sh — copy the playbook templates (and an optional stack overlay) into a project.
# Usage: install.sh <target-dir> [--stack <name>] [--name <project name>] [--branch <default branch>] [--force]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET=""
STACK="none"
NAME=""
BRANCH="main"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --stack)  STACK="$2"; shift 2 ;;
    --name)   NAME="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --force)  FORCE=1; shift ;;
    -h|--help) sed -n 2,3p "$0"; exit 0 ;;
    *) TARGET="$1"; shift ;;
  esac
done

[[ -z "$TARGET" ]] && { echo "error: target directory required" >&2; exit 1; }
[[ -d "$TARGET" ]] || { echo "error: $TARGET does not exist" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"
[[ -z "$NAME" ]] && NAME="$(basename "$TARGET")"

if [[ "$STACK" != "none" && ! -d "$ROOT/stacks/$STACK" ]]; then
  echo "error: unknown stack '$STACK'. Available: $(ls "$ROOT/stacks" | tr '\n' ' ')" >&2
  exit 1
fi

copied=()
skipped=()

copy_tree() {
  local src="$1"
  while IFS= read -r -d '' file; do
    local rel="${file#"$src"/}"
    local dest="$TARGET/$rel"
    if [[ -e "$dest" && $FORCE -eq 0 ]]; then
      skipped+=("$rel")
      continue
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"
    copied+=("$rel")
  done < <(find "$src" -type f ! -name '.DS_Store' -print0)
}

copy_tree "$ROOT/templates"
[[ "$STACK" != "none" ]] && copy_tree "$ROOT/stacks/$STACK"

# Mirror skills so Claude Code (.claude/skills) and Copilot (.github/skills) share one source.
if [[ -d "$TARGET/.github/skills" ]]; then
  mkdir -p "$TARGET/.claude/skills"
  cp -Rn "$TARGET/.github/skills/." "$TARGET/.claude/skills/" 2>/dev/null || true
fi

# Fill placeholders only in files we just copied.
for rel in ${copied[@]+"${copied[@]}"}; do
  f="$TARGET/$rel"
  NAME="$NAME" BRANCH="$BRANCH" STACK="$STACK" perl -pi -e '
    s/\{\{PROJECT_NAME\}\}/$ENV{NAME}/g;
    s/\{\{DEFAULT_BRANCH\}\}/$ENV{BRANCH}/g;
    s/\{\{STACK\}\}/$ENV{STACK}/g;
  ' "$f"
done

chmod +x "$TARGET/.husky/pre-commit" "$TARGET/.claude/hooks/"*.sh 2>/dev/null || true

echo "Installed ai-dev-playbook into $TARGET (stack: $STACK)"
echo "  copied:  ${#copied[@]} files"
if [[ ${#skipped[@]} -gt 0 ]]; then
  echo "  skipped (already exist, use --force to overwrite):"
  printf '    %s\n' "${skipped[@]}"
fi

echo
echo "Placeholders still to fill:"
grep -rnoE '\{\{[A-Z_]+\}\}' "$TARGET/AGENTS.md" "$TARGET/CLAUDE.md" "$TARGET/.claude" "$TARGET/.github" 2>/dev/null \
  | sed "s|$TARGET/||" | sort -u || echo "  none"
