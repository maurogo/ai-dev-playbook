# ai-dev-playbook

A portable, tool-agnostic setup for **AI-assisted software engineering** with Claude Code,
GitHub Copilot and Codex. Drop it into any repository to get:

- A short **constitution** (`AGENTS.md` / `CLAUDE.md`) that every agent reads first.
- **Scoped instructions** (`.github/instructions/*.instructions.md`) that load only for matching files.
- **Skills**: deep knowledge loaded on demand.
- **Slash commands** covering the full delivery loop: analyze → plan → work → review → PR → finalize.
- **Deterministic guardrails**: hooks that lint/format every agent edit, protected branches, lint-staged, CI.
- **Plan state**: a `*-plan.md` (why) + `*-plan.json` (where we are) pair that survives across sessions.
- **Model tiering**: cheap model for mechanical work, smart model for design work.

## The 8 layers

| # | Layer | Files | Loaded |
|---|-------|-------|--------|
| 1 | Constitution | `AGENTS.md`, `CLAUDE.md` | Always |
| 2 | Scoped instructions | `.github/instructions/*.instructions.md` (`applyTo` glob) | When matching files are touched |
| 3 | Skills | `.github/skills/*/SKILL.md` (mirrored to `.claude/skills/`) | When the task matches the description |
| 4 | Commands | `.claude/commands/*.md` + `_partials/` | When a human invokes `/command` |
| 5 | Subagents | `.claude/agents/*.md` | Delegated by the main agent |
| 6 | Hooks | `.claude/settings.json`, `.husky/`, CI | Automatically — not up to the model |
| 7 | Tools | `.mcp.json`, `gh` CLI | On demand |
| 8 | Plan state | `docs/*-plan.md` + `docs/*-plan.json` | At the start of every session |

**Rule of thumb:** anything that *must* happen goes in a hook or CI (deterministic).
Anything that *should* happen goes in instructions (probabilistic).

## Delivery loop

```
/analyze-issue 123   read-only analysis of a GitHub issue
/create-plan 123     docs/<feature>-plan.md (+ .json when multi-session)
/work-issue 123      branch → phases: implement → test → update plan JSON → commit
/review-code         cheap-tier review of the current diff
/prepare-pr          quality gates (lint, types, tests, build)
/create-pr           push + open PR with template
/finalize-pr         merge, final docs, delete temporary plan files
```

## Install into a project

```bash
git clone git@github.com:<you>/ai-dev-playbook.git ~/development/ai-dev-playbook

~/development/ai-dev-playbook/scripts/install.sh ~/development/my-app \
  --stack nextjs --name "My App" --branch main
```

Options:

| Flag | Default | Meaning |
|------|---------|---------|
| `--stack` | `none` | Overlay from `stacks/` (`nextjs`, `node-express`) |
| `--name` | target folder name | Replaces `{{PROJECT_NAME}}` |
| `--branch` | `main` | Replaces `{{DEFAULT_BRANCH}}` |
| `--force` | off | Overwrite files that already exist |

The installer never overwrites existing files unless `--force` is passed, mirrors
`.github/skills` into `.claude/skills`, and lists any `{{PLACEHOLDER}}` left to fill in.

After installing:

```bash
cd ~/development/my-app
npm i -D husky lint-staged && npx husky init   # then keep the provided .husky/pre-commit
grep -rn "{{" AGENTS.md CLAUDE.md .claude .github docs   # fill remaining placeholders
```

Add to the project's `package.json` so the pre-commit hook has something to run:

```json
"lint-staged": {
  "*.{ts,tsx,js,jsx}": ["eslint --fix", "prettier --write"],
  "*.{css,json,md}": ["prettier --write"]
}
```

The CI workflow expects `lint`, `test` and `build` npm scripts (each is skipped if missing) and an `.nvmrc`.

## Validate a plan file

```bash
node ~/development/ai-dev-playbook/scripts/validate-plan.mjs docs/my-feature-plan.json
```

## Repository layout

```
templates/      files copied into every project (stack-agnostic)
stacks/<name>/  overlays copied on top for a given stack
schemas/        JSON Schema for plan state
scripts/        install.sh, validate-plan.mjs
```

## Adding a stack

Create `stacks/<name>/` mirroring the target repo layout (usually only
`.github/instructions/*.instructions.md`), then install with `--stack <name>`.
