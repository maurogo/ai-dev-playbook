#!/usr/bin/env bash
# PostToolUse hook: lint + format the file the agent just edited.
# Input: JSON on stdin with tool_input.file_path. Exit 2 sends stderr back to the agent.
set -uo pipefail

FILE="$(node -e 'let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{try{process.stdout.write(JSON.parse(d).tool_input?.file_path??"")}catch{}})')"

[[ -z "$FILE" || ! -f "$FILE" ]] && exit 0

case "$FILE" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs) LINT=1 ;;
  *.css|*.scss|*.json|*.md) LINT=0 ;;
  *) exit 0 ;;
esac

ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
BIN="$ROOT/node_modules/.bin"

if [[ -x "$BIN/prettier" ]]; then
  "$BIN/prettier" --write --log-level warn "$FILE" >/dev/null 2>&1 || true
fi

if [[ $LINT -eq 1 && -x "$BIN/eslint" ]]; then
  if ! OUT="$("$BIN/eslint" --fix "$FILE" 2>&1)"; then
    echo "ESLint errors remain in $FILE — fix them before continuing:" >&2
    echo "$OUT" >&2
    exit 2
  fi
fi

exit 0
