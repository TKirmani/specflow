# specflow

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shell + Python](https://img.shields.io/badge/stack-shell%20%2B%20python3-informational)](#requirements)

**Agent-agnostic tooling for spec-driven development.** Bootstraps [spec-kit](https://github.com/github/spec-kit) in any project and gives you an at-a-glance progress view across every feature, without locking you into a specific AI coding assistant.

---

## Why specflow?

Spec-driven development — specify → plan → break into tasks → implement — produces excellent artifacts (`spec.md`, `plan.md`, `tasks.md`), but spec-kit itself has **no built-in way to see progress at a glance**, and **no integration with the TDD + multi-agent workflows** that tools like [superpowers](https://github.com/obra/superpowers) introduce.

specflow fills that gap. It is deliberately minimal: a single CLI that bootstraps the spec-kit workflow in any project and reports task completion by reading the same markdown files spec-kit already writes. No daemons. No hidden state. `tasks.md` remains the source of truth.

## Features

- **One-command bootstrap.** `specflow init` installs and runs `specify init` via `uvx` if needed — no global Python packages required.
- **Agent-agnostic.** Works with Claude Code, Cursor, GitHub Copilot, OpenAI Codex, Gemini CLI, or no agent at all.
- **At-a-glance progress.** `specflow progress` parses every `specs/*/tasks.md` and prints per-feature, per-phase completion with colored progress bars.
- **Live watch mode.** `specflow progress --watch` refreshes whenever a `tasks.md` changes — useful when an agent is executing `/speckit.implement` and you want to monitor from a second pane.
- **Zero runtime dependencies.** POSIX shell + Python 3 stdlib. No pip install, no node_modules.

## Requirements

- POSIX shell (`sh`, `bash`, `zsh`, `dash` all fine)
- Python 3.8+
- [`uv` / `uvx`](https://docs.astral.sh/uv/) *only* if `specify` is not already installed globally
- Git (recommended, used by the installer)

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/TKirmani/specflow/main/install.sh | sh
```

Installs `specflow` and its `specflow-progress` helper to `~/.local/bin`. Override with `PREFIX=/usr/local curl ... | sudo sh` if preferred.

Verify:

```sh
specflow --help
```

## Usage

### Bootstrap a project

```sh
cd path/to/project
specflow init                  # agent-neutral
specflow init --agent claude   # or cursor, copilot, codex, gemini, none
```

This runs `specify init --here --ai <agent>` (unless `.specify/` already exists) and ensures `.sdd/` is gitignored.

### Drive the spec-kit workflow

Use whatever coding agent you installed for in step 1. The standard spec-kit flow is:

```
/speckit.specify  →  /speckit.plan  →  /speckit.tasks  →  /speckit.implement
```

### Check progress

One-shot report:

```sh
specflow progress
```

```
001-user-auth   ████████████████░░░░ 24/30 (80%)
  ✓ Phase: Setup                            3/3  (100%)
  ✓ Phase: Foundational                     5/5  (100%)
    Phase: US1 — Login                     10/12 (83%)
    Phase: US2 — Password reset             6/10 (60%)

002-billing     ████░░░░░░░░░░░░░░░░ 4/20 (20%)
  ✓ Phase: Setup                            4/4  (100%)
    Phase: US1 — Stripe integration         0/16 (0%)

TOTAL           ████████████░░░░░░░░ 28/50 (56%)
```

Live mode (re-renders on every `tasks.md` change — put this in a split pane):

```sh
specflow progress --watch
```

## How it fits with the rest of the ecosystem

| Tool                                                         | Role                                                       |
| ------------------------------------------------------------ | ---------------------------------------------------------- |
| [spec-kit](https://github.com/github/spec-kit)               | Defines the SDD workflow and slash commands                |
| [superpowers](https://github.com/obra/superpowers)           | Optional: adds TDD + subagent-driven-development skills    |
| **specflow**                                                 | Bootstraps the workflow and reports progress               |

specflow does not replace spec-kit or superpowers; it **composes** with them. Install superpowers for your agent separately if you want the TDD discipline.

## Roadmap

- `specflow status` — richer per-task view (assignees, timestamps, blocked items)
- JSON output mode for dashboards and CI
- Optional git hook to gate commits on spec compliance
- Multi-feature orchestrator: run `/speckit.implement` in parallel across features with isolated worktrees

## Contributing

Issues and PRs welcome. Please keep the project dependency-free and agent-agnostic.

## License

[MIT](LICENSE)
