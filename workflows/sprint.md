---
description: Sprint development workflow — small, controlled iterations, 3–8 Tasks per Sprint
---

# Sprint Development Workflow

Triggered when the user types `/sprint`.

## Core Disciplines

1. **Short-context principle** — each Sprint must complete within a single session. Context passes between Sprints via the filesystem, not conversation history.
2. **Mandatory confirmation** — pause and wait for user confirmation after every Task. Batch execution is forbidden.
3. **Zero fake-test tolerance** — no `assert True`, no mocking the logic being tested, no commenting out failing tests. Tests must verify real behavior.
4. **Verify before developing** — before starting a new Task, run the existing tests to confirm the baseline is green.
5. **Minimal changes** — each Task only changes necessary files. No "while I'm here" improvements.
6. **Research before coding** — before writing any code, study the framework/library capability boundary (read docs, check source). Produce `sprint-{N}-capability-map.md` in Step 1.8. **This file is the only entry pass to Step 2 — if it doesn't exist, no Task may be executed.**
7. **Functional completeness over test pass rate** — tests exist to verify design completeness, not to be gamed. No code smells introduced to pass tests.
8. **Root cause analysis on failures** — never blindly modify test cases to make them pass. Dig into the root cause first.
9. **Audit reports are read-only** — `docs/sprints/audit-sprint-{N}.md` is produced by an independent audit session. It must **never be modified** in a sprint session. Disagreements or notes go into `docs/sprints/sprint-{N+1}-review.md` under "Audit Notes".

---

## Step 1: Load Context (Auto)

// turbo

Read the following files (if any file is missing, alert the user and pause — never silently skip):

```
1. docs/sprint_tracker.md               → Locate current Sprint number, goal, and Task list
2. docs/design_decisions.md             → Past architecture/product decisions, ensure implementation matches
3. docs/sprints/sprint-{N}-review.md    → Previous Sprint's self-review (N = previous Sprint number)
   ⚠️ Missing: warn "sprint-{N}-review.md missing, previous Sprint has no review doc"
4. docs/sprints/audit-sprint-{N}.md     → [REQUIRED] Previous Sprint's independent audit (N = previous Sprint number)
   ⚠️ Missing: warn "audit-sprint-{N}.md missing, skipping fix list phase this Sprint"
   ✅ Found: must read the entire file, enumerate all "Fix List" items — never read only part of it
   🚫 Read-only: audit reports are produced by an independent audit session — writing or modifying is forbidden
```

Report to user:

> "Current: Sprint {N}, goal: {goal}, {n} Tasks total.
> Audit fix list: {k} items outstanding.
> Should we handle the fix list first?"

---

## Step 1.5: Audit Fix Phase (if audit report exists and has open items)

> **Core principle**: Audit fix list takes priority over new Tasks. No new holes before old debt is cleared.

If the audit report loaded in Step 1 has unclosed (un-✅) fix items:

1. **Enumerate all** — list every fix item for the user, each with:
   - File path
   - Problem description (one sentence)
   - Severity (🔴/🟡)
2. **Confirm one by one** — each fix item is an independent sub-Task with its own TDD loop (Section 2.3), user confirms each
3. **All green before continuing** — all fix items closed, full test suite green, then proceed to Step 2

**This phase does not count toward Sprint Task count, but must be written into `sprint-{N+1}-review.md` under "Inherited Fixes".**

---

## Step 1.8: Research Phase (Mandatory — runs once at Sprint start)

> 🔬 **Discipline #6 enforcement point**: No code before studying the full Sprint's framework capability boundary.

Before entering the Task-by-Task loop, produce `docs/sprints/sprint-{N}-capability-map.md`.

**Research steps:**

1. **Scan all Tasks** — go through every Task in the current Sprint, identify all external frameworks/libraries involved
2. **Study capability boundary** — for each dependency, confirm its capabilities via one of:
   - Official docs or CHANGELOG (record version + key APIs)
   - Source code (record key class/function signatures)
   - Existing usage in the project (record file paths)
3. **Create `docs/sprints/sprint-{N}-capability-map.md`** — required structure below

### Document Template

```markdown
# Sprint {N} Capability Map

> **Sprint goal**: {goal}
> **Framework versions**: {main frameworks and versions}
> **Date**: {YYYY-MM-DD}

---

## T01: {Task title}

| Feature | Framework/lib | Decision | Rationale |
|---------|--------------|----------|-----------|
| {sub-feature} | {framework} | ✅/⚠️/❌ | {one-line rationale} |

### Key API Signatures

{Paste verified constructor/method signatures with parameter types and comments}

### Known Issues

{Risks, limitations, incompatibilities found during research. Write "None" if none.}

### Design Decisions (if any)

{If multiple options existed, state what was chosen and why the alternative was rejected}

### Call Architecture (if multiple modules interact)

{Text tree or pseudocode showing the call chain}

---

(Repeat above structure for each Task)

---

## Unused / Not Applicable Framework Features

| Framework feature | Reason not used |
|-------------------|----------------|
| {framework.feature} | {reason} |

---

## Existing Code Reuse

| Existing module (file path) | Sprint {N} usage |
|-----------------------------|-----------------|
| `src/...`                   | {usage}         |

---

## Minimal Change List

| File      | Change type   | Task | Scope         |
|-----------|---------------|------|---------------|
| `src/...` | New / Modify  | T0x  | {one-line description} |
```

### Quality Checklist (document must satisfy all of the following)

- [ ] **Sectioned by Task** — each Task has its own section, not one big table for everything
- [ ] **API signatures verified** — key API signatures come from actually reading source/docs, not from memory
- [ ] **Known issues recorded** — risks, limitations, incompatibilities listed (explicitly write "None" if none)
- [ ] **Design decisions justified** — wherever multiple options existed, state what was chosen and why
- [ ] **Call architecture drawn** — Tasks involving multiple modules have a text call chain diagram
- [ ] **Minimal change list complete** — all files to be created/modified listed, with owning Task
- [ ] **Unused capabilities explained** — explicitly list framework features researched but decided against, with reason

**Pause after this step. Wait for user to confirm research conclusions before entering Step 2.**

---

## Step 2: Task-by-Task Execution (Strict Loop)

> [!CAUTION]
> **🚦 Capability Map Gate (mandatory — must execute every time before entering Step 2)**
>
> Before executing any Task, verify that `docs/sprints/sprint-{N}-capability-map.md` exists and has substantive content (not an empty file).
>
> - ✅ File exists → proceed to 2.1
> - ❌ File missing → **stop immediately, return to Step 1.8 to complete research, then continue**
> - ❌ File exists but is an empty template → **same as above — must fill in research conclusions first**
>
> No exceptions. "I already know this framework" is not a reason to skip — research conclusions must be written to a file, not kept only in AI session memory.

For each Task in the current Sprint from sprint_tracker.md, execute the following loop:

### 2.1 Verify Baseline

// turbo

Based on the files and tech stack in the Sprint Tasks, infer and run the project's full test suite (check `pyproject.toml` / `package.json` / `Cargo.toml` / `Makefile` etc. to confirm the correct command). Confirm baseline is green.

If baseline is not green, fix it first. Never write new code on a red baseline.

### 2.2 Present Task Plan

Open `docs/sprints/sprint-{N}-capability-map.md`, find the section for the current Task, and based on its **verified API signatures and design decisions**, show the user:

- Which files to change (must already be listed in capability-map's "Minimal Change List")
- How to change them (use APIs recorded in capability-map — no unverified APIs)
- What tests to write
- Expected results

⚠️ If the plan uses APIs or files not in the capability-map, update the capability-map first (research those additions), then present the plan.

**Pause. Wait for user approval.**

### 2.3 TDD Execution

1. **Write tests first** — write test cases (must test real behavior, no empty assertions)
2. **Run tests to confirm red** — new tests must fail (proves they're actually testing something)
3. **Write implementation** — make the tests green
4. **Run full test suite** — confirm no regressions

### 2.4 Validate & Commit

// turbo

Based on the Sprint's tech stack, run the full test suite and linter, show results to user. **Pause. Wait for user to confirm this Task passes.**

### 2.5 Update Progress

Mark the corresponding Task as `[x]` in sprint_tracker.md.

### 2.6 Loop

Return to 2.1 for the next Task. Repeat until all Tasks in the current Sprint are complete.

---

## Step 3: Sprint Review (Auto)

> **Responsibility**: `sprint-{N}-review.md` is generated by **Sprint N's sprint workflow (this step)**, not by the audit session.

After all Tasks complete, generate the Sprint review doc. Write to `docs/sprints/sprint-{N}-review.md`:

> **Timing note**:
>
> - Sprint N ends → this step generates `sprint-N-review.md` (audit-sprint-N does not exist yet)
> - Independent audit → generates `audit-sprint-N.md`
> - Sprint N+1 starts → reads audit-sprint-N.md → if there are notes, write to `sprint-(N+1)-review.md` under "Audit Notes"
>
> Therefore: the "Audit Notes" section in `sprint-N-review.md` addresses **audit-sprint-(N-1).md** (the previous audit), not the current one.

```markdown
# Sprint {N} Review

## Goal

{Sprint goal}

## Inherited Fixes (from audit-sprint-{N-1}.md)

- [x] {fix item description} (if any)

## Audit Notes (for audit-sprint-{N-1}.md, if there is additional context)

- {If there is a supplement or disagreement with an audit finding, record it here — do not modify the audit report}

## Completed Tasks

- [x] T01: {description} (tests: {passed}/{total})
- [x] T02: ...

## Code Changes

- `{file path}` — {change description}

## Validation Results

Tests: {passed}/{total} pass
Lint: {error count} errors

## Known Issues

- {if any}

## Prerequisites for Next Sprint

- {if any}
```

Update `docs/sprint_tracker.md` to mark the current Sprint as complete.
Confirm `docs/sprints/sprint-{N}-capability-map.md` contains research conclusions for all Tasks in this Sprint.

---

## Step 4: Await Review

Report to user:

> "Sprint {N} complete. {n} Tasks all passed, tests {x}/{y} pass. Review the code or run `/audit` to start the independent audit."

**Mandatory stop. Sprint ends here. The next Sprint must be started in a new session.**
