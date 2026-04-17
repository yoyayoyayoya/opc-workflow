<div align="center">

# 🔐 OPC Workflow

**Execution discipline framework for AI-assisted development**

*Keep using Cursor / Claude Code / Kiro — but make the AI stop lying, drifting, and faking.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Works with Claude](https://img.shields.io/badge/Works%20with-Claude-orange)](https://claude.ai)
[![Works with Cursor](https://img.shields.io/badge/Works%20with-Cursor-blue)](https://cursor.sh)
[![Works with Kiro](https://img.shields.io/badge/Works%20with-Kiro-green)](https://kiro.dev)
[![Works with Antigravity](https://img.shields.io/badge/Works%20with-Antigravity-purple)](https://deepmind.google)

[English](./README.md) | [中文](./README.zh.md)

</div>

---

## The Problem

You use AI tools to write code, but:

- **AI lies during execution** — writes fake tests, writes code that looks right but has broken logic
- **Long-context degradation** — the longer the context, the more the AI drifts from your original design
- **No execution discipline** — nothing forces the AI to check against the original design while coding

Limitations of existing tools:

| Tool | Problem |
|------|---------|
| Cursor / Windsurf | No cross-Sprint context isolation, degrades on long projects |
| Claude Code | Single-session execution, no design constraint validation |
| Kiro | Spec files are static, not actively checked during execution |
| GitHub Copilot | No project-level design anchoring |

---

## The Solution

OPC Workflow is **three Markdown files** that any AI tool can execute:

```
workflows/
  ├── plan_sprint.md   → Discuss with AI, define Sprint plan, lock architecture decisions
  ├── sprint.md        → TDD + mandatory research before coding + pause after every Task
  └── audit.md         → Zero-trust audit: mutation testing + fake test scan + logic integrity
```

**Core mechanisms:**

- `/plan_sprint` — AI reads your docs + past decisions, discusses with you, produces a Sprint plan
- `/sprint` — Enforced TDD loop: research framework capabilities first, pause after every Task
- `/audit` — Runs in an isolated session, zero-trust review of the previous Sprint

---

## 📊 Real-World Data

> The following data comes from the author's local practice project using OPC Workflow — real numbers, continuously updated:

| Metric | Data |
|--------|------|
| Sprints completed | 7 |
| Total tests | 459 |
| Mutation test capture rate | 100% (6/6) |
| Critical bugs found by audit | 1 (security boundary bypass) |
| Fake tests found & fixed | 27 |
| Last updated | 2026-04-17 |

These numbers are real, not demo data.

The critical bug was found during the first independent audit — an execution module directly instantiated components, bypassing the registry, causing security boundaries, tool injection, and the memory system to all fail silently. Without `/audit`'s isolated session mechanism, this bug would never have been caught, because the developer wrote both the code and the tests — confirmation bias creates blind spots.

---

## Quick Start

```bash
bash <(curl -sSL https://raw.githubusercontent.com/yoyayoyayoya/opc-workflow/main/install.sh)
```

The script will:
1. Ask for your project directory path
2. Let you choose your AI tool (Claude Code / Antigravity / Cursor / Kiro / Other)
3. Download the workflow files into the correct location for your tool
4. Set up `docs/` templates if they don't already exist

### Resulting file locations

| Tool | Workflow files |
|------|----------------|
| Claude Code / Antigravity | `.agents/workflows/` |
| Cursor | `.agents/workflows/` (reference via `@file`) |
| Kiro | `.kiro/steering/` (auto-loaded) |
| Other | `workflows/` |

Doc templates (`sprint_tracker.md`, `design_decisions.md`) always go to `docs/`.

## Workflow Reference

### `/plan_sprint` — Sprint Planning

- Reads product docs + past decisions
- Discusses Sprint goal and Task breakdown with you
- Writes conclusions to `sprint_tracker.md` and `design_decisions.md`
- **Must run in an isolated session** (separate from `/sprint`)

### `/sprint` — Sprint Development

**9 core disciplines:**

1. Each Sprint completes within a single session (short-context principle)
2. Pause and wait for confirmation after every Task
3. Zero fake-test tolerance (no `assert True`)
4. Verify baseline is green before starting a new Task
5. Minimal changes (only touch necessary files)
6. **Research before coding** (must study framework capabilities first, produce a capability map)
7. Functional completeness over test pass rate
8. Dig into the root cause of every test failure
9. Audit reports are read-only (never modify them in a sprint session)

### `/audit` — Zero-Trust Audit

- **Must run in an isolated session**
- Empty assertion scan (`assert True` / `assert is not None`)
- Over-mocking scan (did you mock the logic being tested?)
- Mutation testing (deliberately break code — tests must go red)
- Logic integrity check (against design docs)
- Produces an audit report (evidence-driven, with file paths and line numbers)

---

## Design Principles

**Short context + clear boundaries**

Each Sprint completes in a single session. Context passes between Sprints via the filesystem. This solves the root cause of LLM long-context degradation.

**Independent audit**

`/audit` must run in a different session from `/sprint`. This eliminates confirmation bias — developers cannot audit their own code.

**Evidence-driven**

Every conclusion in an audit report must include a specific file path and line number. Conclusions without evidence don't count.

**Research before coding**

AI naturally tends to "just write code" instead of "study framework capabilities first." `/sprint` forces a capability map to be produced at the start of every Sprint before any implementation begins.

---

## Full Sprint Lifecycle

```
/plan_sprint  (Session A)
    Read product docs + past decisions
    Discuss Task breakdown with you
    Write to sprint_tracker.md
        ↓ Close session
/sprint  (Session B)
    Research framework capabilities → produce capability map
    Execute TDD loop per Task
    Pause for confirmation after each Task
    Generate sprint-N-review.md
        ↓ Close session
/audit  (Session C)
    Independently audit Sprint N
    Mutation testing + fake test scan
    Produce audit-sprint-N.md
        ↓
Owner review → Pass / Send back for fixes
```

---

## Live Case Study

The author is using OPC Workflow to develop a local AI engineering project. Real-world data in this README updates after every Sprint.

This is ongoing validation of the methodology — not a demo, but an actual development process.

---

## Contributing

Contributions welcome in these areas:

- **Tool adapters** — optimize workflows for specific AI tools (Claude Code / Cursor / Kiro)
- **Stack templates** — Sprint templates for specific languages or frameworks
- **Case studies** — share your project using opc-workflow (open an issue)

See [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## License

MIT — free to use, free to adapt, please keep the original link.
