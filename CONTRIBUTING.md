# Contributing Guide

Thanks for your interest in OPC Workflow!

---

## Types of Contributions

### 1. 🔧 Tool Adapters

**Goal**: Optimize workflow behavior for specific AI tools.

Different tools have different command formats and context mechanisms:

| Tool | Status | Adapter direction |
|------|--------|------------------|
| Claude Code | ✅ Verified | slash commands + CLAUDE.md |
| Cursor | Partially verified | `.cursorrules` integration |
| Kiro | Partially verified | Steering file integration |
| Antigravity (Google Deepmind) | ✅ Verified | `.agents/workflows/` + slash commands |
| GitHub Copilot Chat | Not verified | — |

**How to submit**:
1. Create an adapter doc under `workflows/adapters/{tool-name}/`
2. Describe the adapter approach and the scenarios you verified (no need to name your project)
3. Submit a PR

---

### 2. 📦 Stack Templates

**Goal**: Provide ready-made Sprint templates for different tech stacks, reducing user setup.

Template location: `workflows/templates/{stack-name}/`

**Known demand** (from community feedback):

- Python / FastAPI backend
- React / Next.js frontend
- React Native mobile
- Rust CLI tools
- Go microservices

**Template contents**:
- `sprint.md` variant (stack-specific test commands, lint tools, etc.)
- `audit.md` variant (stack-specific mutation testing strategies)
- `docs/` directory template (`sprint_tracker.md` + `design_decisions.md` starters)

---

### 3. 📖 Case Studies

**Goal**: Accumulate real usage data to build credibility for the methodology.

**How to submit**:
1. Open an issue with the title: `[Case Study] Your project name (or "Anonymous")`
2. Include:
   - Tech stack
   - Number of Sprints completed using OPC Workflow
   - Total test count
   - Any meaningful bugs found by `/audit` (if any)
   - Project link (optional, anonymous is fine)

---

## Submission Process

1. Fork this repository
2. Create a feature branch: `git checkout -b feat/cursor-adapter`
3. Commit your changes (follow [Conventional Commits](https://www.conventionalcommits.org/))
4. Open a PR describing your changes and how you verified them

---

## Quality Standards

Submitted workflow variants or templates must satisfy:

- [ ] Verified in a real project (not theoretical)
- [ ] The three core disciplines must not be weakened: **independent audit**, **research before coding**, **zero fake-test tolerance**
- [ ] Includes clear usage instructions and examples

---

## License

Contributions follow the MIT license of this repository.
