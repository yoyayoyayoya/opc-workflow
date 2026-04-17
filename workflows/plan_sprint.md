---
description: Sprint planning workflow — discuss requirements, define the next Sprint plan, write to sprint_tracker.md (must run in an isolated session, required before /sprint)
---

# Sprint Planning Workflow

Triggered when the user types `/plan_sprint`.

## Role

This workflow is the **first step** of the full Sprint lifecycle:

```
/plan_sprint (this workflow) → /sprint (development) → /audit (audit)
```

**Core responsibility**: Read product docs + historical decision context, discuss and define the next Sprint plan with you, then write conclusions to `docs/sprint_tracker.md` and `docs/design_decisions.md` so the next session can pick up seamlessly.

---

## Core Disciplines

1. **Plan only, never execute** — this workflow writes no business code, only plan documents
2. **Decisions must be committed** — all architecture/product decisions discussed must be written to `design_decisions.md` before the session ends
3. **Sprint plan must be standardized** — the output Task table must match the `sprint_tracker.md` existing format so `/sprint` can consume it directly
4. **Dependencies must be explicit** — dependencies between Sprints must be stated in the table, no implicit assumptions
5. **Acceptance criteria must be testable** — every Sprint's acceptance criteria must be quantifiably checkable by `/audit`

---

## Step 1: Load Full Context (Auto)

// turbo

Read the following files in order:

```
1. docs/sprint_tracker.md            → Which Sprint is done, and which future Sprints are already planned
2. docs/design_decisions.md          → Past architecture/product decisions, avoid re-discussing settled matters
3. docs/product_vision.md            → Product direction and moats, align planning with this
4. docs/architecture.md              → Technical architecture design, validate feasibility of the plan
5. docs/sprints/audit-sprint-{N}.md  → Most recent audit report, understand outstanding issues
```

After reading, report status to the user:

> "Done: Sprint 1–{N}. Planned but not started: Sprint {N+1}–{M} ({k} Sprints, {n} Tasks).
> Outstanding issues from last audit: {issues}.
> Key past decisions: {D001/D002/... summaries}.
>
> Tell me: ① Adjust already-planned Sprints? ② Plan further Sprints? ③ New product ideas to discuss?"

---

## Step 2: Gap Analysis

Compare `docs/product_vision.md` milestones against `docs/architecture.md` module list:

1. **List implemented capabilities** (summarize from completed Sprints in sprint_tracker.md)
2. **List unimplemented key capabilities** (sorted by priority)
3. **Explain priority rationale** — which are blockers for other features (must go first), which are independent (can be planned in parallel)

Show the user a gap analysis table:

```markdown
| Capability | Design source | Priority | Depends on | Status |
|------------|--------------|----------|------------|--------|
| ...        | ...           | P0/P1/P2 | Sprint N   | ⬜ Not started |
```

**Pause. Wait for user to confirm or adjust priorities.**

---

## Step 3: Sprint Plan Discussion

For each Sprint the user wants to plan, discuss one by one:

### For each Sprint to plan:

**3.1 Propose the plan**

Propose for the Sprint:
- Core goal (one sentence)
- Why now (dependency chain + product value)
- Initial Task breakdown (3–8 Tasks, each Task estimated at 3–6 tests)
- Key technical/product decision points (questions needing owner sign-off)

**3.2 Discuss open questions**

Explicitly list each **key decision point** in this Sprint, discuss one by one:

```
> Q{n}: {question description}
> Option A: {description} — Pros: ... Cons: ...
> Option B: {description} — Pros: ... Cons: ...
> Recommendation: {recommended option + rationale}
```

**Pause. Wait for owner decision.**

**3.3 Lock after confirmation**

After the owner decides:
- Record the decision
- Update Task descriptions (adjust implementation details per the decision)
- Define acceptance criteria (specific, quantifiable conditions for `/audit`)

---

## Step 4: Write Plan to sprint_tracker.md

// turbo

Append new Sprints in the existing format of `sprint_tracker.md`:

```markdown
### Sprint {N}: {name}

**Goal**: {one-sentence goal}

**Depends on**: {which Sprint must complete first, or "none"}

**Key design decisions**: {summary of decisions confirmed in this planning session, for fast context in future sessions}

| Task | Description | File | Status |
|------|-------------|------|--------|
| T01  | {description} | {file path} | ⬜ |
| ...  | ...           | ...         | ... |

**Acceptance criteria**:
- {specific, quantifiable condition checkable by /audit}
```

**⚠️ Format requirements**:
- Task description must include: what + which file + key implementation approach
- Status always `⬜` (not started)
- Acceptance criteria start with a verb, are specific and testable (not "complete X", write "X persisted in DB / test covers Y scenario / API returns Z format")

---

## Step 5: Write New Decisions to design_decisions.md

// turbo

For every new architecture/product decision made in this planning session, append to `docs/design_decisions.md` in this format:

```markdown
### D{next number}: {decision title}

**Background**: {why this decision was needed}

**Conclusion**: {what was chosen}

{implementation details / diagrams}

**Why this approach**: {why this over the alternatives}

**Affected files**: {which files must implement per this decision}
```

Add under the current date section at the top, in reverse chronological order.

---

## Step 6: Update sprint_tracker.md Usage Section

Confirm the "Usage → Full Sprint Lifecycle" section in `sprint_tracker.md` includes the `/plan_sprint` description (persisted there already, usually no update needed).

---

## Step 7: Report & Hand Off

Send the user a final report:

> "Sprint planning complete.
>
> **This session planned:**
> - Sprint {N}: {goal} ({n} Tasks)
> - Sprint {N+1}: {goal} ({n} Tasks) [if any]
>
> **New decisions:** {x} entries (D{xxx}–D{yyy}), written to design_decisions.md.
>
> **Written to sprint_tracker.md** ✅
>
> **Next step:** In a new session, type `/sprint` to start executing Sprint {N}."

**Mandatory stop. Planning ends here. `/sprint` must be started in a new session.**
