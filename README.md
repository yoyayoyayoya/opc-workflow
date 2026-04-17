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

**macOS / Linux**
```bash
bash <(curl -sSL https://raw.githubusercontent.com/yoyayoyayoya/opc-workflow/main/install.sh)
```

**Windows (PowerShell)**
```powershell
iex (iwr -useb 'https://raw.githubusercontent.com/yoyayoyayoya/opc-workflow/main/install.ps1').Content
```

> WSL / Git Bash users on Windows can use the bash command instead.

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

## How to Use

> **The core mechanic: every command runs in a separate AI session.**
> This prevents context drift and eliminates confirmation bias in audits.

---

### Before your first Sprint — set up docs

Create these files in your project's `docs/` folder (templates installed by the setup script):

| File | Purpose |
|------|---------|
| `sprint_tracker.md` | Track Sprint goals, Tasks, and status |
| `design_decisions.md` | Log architecture and product decisions |
| `architecture.md` | Technical design (optional but recommended) |
| `product_vision.md` | Product direction (optional) |

---

### Step 1 — Plan: `/plan_sprint`

**Open a new AI session. Type `/plan_sprint`.**

The AI will:
1. Read your docs and past decisions
2. Show you a gap analysis — what's done vs. what's missing
3. Discuss the next Sprint's goal and Task breakdown with you
4. Ask for your decisions on open architecture questions
5. Write the final plan to `sprint_tracker.md`

At the end you have a Sprint plan with concrete Tasks ready to execute.
**Close this session.**

---

### Step 2 — Build: `/sprint`

**Open a new AI session. Type `/sprint`.**

The AI will:
1. Read the Sprint plan from `sprint_tracker.md`
2. **Research** — study all involved frameworks and produce `docs/sprints/sprint-N-capability-map.md` before writing any code
3. Pause and wait for you to confirm the research conclusions
4. Execute each Task in a TDD loop: write test → confirm it's red → write implementation → confirm it's green
5. Pause after every Task for your approval
6. Generate `docs/sprints/sprint-N-review.md` when all Tasks are done

**Close this session.**

---

### Step 3 — Audit: `/audit`

**Open a new AI session. Type `/audit`.**

The AI will (as an independent reviewer with zero trust in the previous session):
1. Scan for fake tests (empty assertions, over-mocking)
2. Run mutation tests — deliberately break each core function to verify tests catch it
3. Check logic integrity against your design docs
4. Produce `docs/sprints/audit-sprint-N.md` with evidence (file paths + line numbers)

**Read the audit report. Decide: pass or send back for fixes.**

---

### Step 4 — Repeat

Start the next Sprint with `/plan_sprint` in a new session.
The audit findings automatically feed into the next Sprint's fix list.

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
