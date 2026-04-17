---
description: Sprint audit workflow — zero-trust review of the previous Sprint's code quality (must run in an isolated session)
---

# Sprint Audit Workflow

Triggered when the user types `/audit`.

## Core Principles

1. **Zero trust** — assume all code and tests from the previous Sprint may be fake
2. **Review only, never write** — this workflow modifies no business code, only produces an audit report
3. **Isolated session** — must run in a different session from the development Sprint
4. **Evidence-driven** — every conclusion must include a specific file path and line number

---

## Step 1: Load Context (Auto)

// turbo

Read the following files:
```
1. docs/sprint_tracker.md              → Most recently completed Sprint number
2. docs/sprints/sprint-{N}-review.md   → What the Sprint claimed to have done
3. docs/architecture.md (relevant sections) → What it should look like
```

Confirm with user:
> "Ready to audit Sprint {N}. Sprint claims to have completed {n} Tasks. Start audit?"

---

## Step 2: Test Quality Audit

### 2.1 Empty Assertion Scan
// turbo
Search all test files for suspicious assertions:
```bash
grep -rn "assert True\|assert.*is not None\|assert.*is None\|pass$" tests/
```

Flag all hits as 🔴 suspicious.

### 2.2 Over-Mocking Scan
// turbo
Search for mock/patch usage:
```bash
grep -rn "@patch\|@mock\|MagicMock\|mocker\.patch\|jest\.mock\|vi\.mock\|stub\|sinon" tests/
```

Check each one: is the mocked object the logic being tested? If yes → 🔴 fake test.

### 2.3 Test Coverage Check (Mandatory Gate)

// turbo

Based on the project tech stack (check `pyproject.toml` / `package.json` / `Cargo.toml` / `Makefile` etc.), infer and run the full test suite, saving output for reference:

```bash
# Run the project's test command (e.g. pytest tests/ / npm test / cargo test)
```

> [!CAUTION]
> **Mandatory gate — audit must stop immediately if any of the following conditions fail, do not continue to Step 3+:**
> 1. Command must execute successfully (visible `passed` / `failed` output)
> 2. Audit report must contain actual numbers like `N passed, M failed`
> 3. If command errors (test runner not found, etc.), fix the environment first — skipping is forbidden
> 4. "Code looks right" ≠ "tests pass" — no test output means no evidence

Compare test count claimed in Sprint review vs. actual count run. Discrepancy → 🔴.

---

## Step 3: Mutation Testing (The Deadliest Move)

For each core function modified in the Sprint:

1. **Record the original code**
2. **Deliberately break it** (e.g., `return True` → `return False`, delete a key line)
3. **Run the related tests**
4. **Judge**:
   - Tests go red ✅ → tests are real
   - Tests stay green 🔴 → fake tests — they don't verify this logic at all
5. **Restore the code**

> ⚠️ Code must be restored after every mutation. Mutation testing must leave zero code changes.

---

## Step 4: Logic Integrity Audit

### 4.1 Compare Against Design Docs
Read the relevant module design in `architecture.md` → check if the code actually implements the design.

Key checks:
- Function bodies have real implementations (not `pass`, `TODO`, `NotImplementedError`, empty stubs)
- Imports are actually used
- Parameters are actually consumed (not received and ignored)

### 4.2 Feature Regression Check
For every feature point the Sprint review claims, manually trace the code path to confirm it actually exists.

---

## Step 5: Produce Audit Report

Write to `docs/sprints/audit-sprint-{N}.md`:

```markdown
# Sprint {N} Audit Report

## Audit Scope
Sprint {N}, {n} Tasks, {m} file changes

## Test Baseline (required — report is invalid without this)
```
{Paste the last 3 lines of actual test output, e.g.:}
1 failed, 456 passed in 80.54s
```
> If this section is empty or says "not run", this audit report is automatically invalid.

## Test Quality

### Empty Assertions ({x} total)
| File | Line | Code | Severity |
|------|------|------|----------|
| ...  | ...  | ...  | 🔴/🟡   |

### Over-Mocking ({x} total)
| File | Line | Mocked object | Mocks the logic being tested? |
|------|------|---------------|-------------------------------|
| ...  | ...  | ...           | 🔴/✅                          |

### Mutation Test Results ({x} mutations total)
| Function | Mutation | Tests caught it? | Verdict |
|----------|----------|-----------------|---------|
| ...      | ...      | ...             | ✅/🔴   |

## Logic Integrity

### Fake Implementations ({x} total)
| File | Line | Issue |
|------|------|-------|
| ...  | ...  | ...   |

### Design vs. Implementation Gap
| Design requirement | Implementation status | Gap |
|--------------------|-----------------------|-----|
| ...                | ...                   | ... |

## Summary
- Test credibility: {High / Medium / Low}
- Code completeness: {High / Medium / Low}
- Recommendation: {Pass / Needs fixes before re-audit}

## Fix List (if any)
- [ ] {specific fix item 1}
- [ ] {specific fix item 2}
```

---

## Step 6: Report

Report to user:
> "Sprint {N} audit complete. Found {x} fake tests, {y} fake implementations, {z} design gaps. Recommendation: {Pass / Needs fixes}. See audit-sprint-{N}.md."

**Mandatory stop. Wait for owner decision.**