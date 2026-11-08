@AGENTS.md

# Claude Code specifics

## Model tiers

Each command in `.claude/commands/` pins `model:` in its frontmatter. The pin wins over `/model`.

- **haiku** — checklist or mechanical work: `/review-code`, `/add-tests`, `/fix-issues`,
  `/prepare-pr`, `/finalize-pr`, `/analyze-issue`.
- **sonnet** — design and orchestration: `/create-plan`, `/work-issue`, `/create-pr`.
- **opus** — only for long, unstructured reasoning (new architecture across many layers,
  cross-repo changes with unknown blast radius). Edit the command's `model:` line, then revert.

## Subagents

- `Explore` (`.claude/agents/explore.md`) is pinned to haiku and is read-only. Delegate wide
  searches to it instead of reading dozens of files in the main context.

## Hooks

`.claude/settings.json` runs `.claude/hooks/format-changed-file.sh` after every `Edit`/`Write`.
It runs ESLint `--fix` and Prettier on the touched file and prints remaining errors back to you.
Fix what it reports before moving on; do not disable the hook.
