# Live Case Study

> The author is using OPC Workflow to develop a local AI engineering project. Real-world data below, updated continuously.

## Real-World Data

| Metric | Data | Last updated |
|--------|------|-------------|
| Sprints completed | 7 | 2026-04-17 |
| Total tests | 459 | 2026-04-17 |
| Mutation test capture rate | 100% (6/6) | 2026-04-17 |
| Critical bugs found by audit | 1 | Sprint 3 |
| Fake tests found & fixed | 27 | cumulative |

## Key Finding

### Sprint 3 Audit: Security Boundary Bypass

**What happened**: An execution module directly instantiated components, bypassing the registry.

**Impact**: Security boundaries, tool injection, and the memory system all failed silently.

**How it was found**: Independent `/audit` session — caught by mutation testing.

**Why the developer didn't catch it**: The developer wrote both the code and the tests in the same Sprint session. Confirmation bias creates blind spots. An isolated audit session eliminates that bias.

## Sprint History

| Sprint   | Goal                  | Tests | Audit status |
|----------|-----------------------|-------|--------------|
| Sprint 1 | Agent base framework  | 45    | ✅ Passed    |
| Sprint 2 | Task scheduling       | 78    | ✅ Passed    |
| Sprint 3 | Harness system        | 112   | ✅ Passed (1 critical bug found) |
| Sprint 4 | Memory system         | 89    | ✅ Passed    |
| Sprint 5 | Tool injection        | 67    | ✅ Passed    |
| Sprint 6 | Star rating system    | 34    | ✅ Passed    |
| Sprint 7 | TUI + MCP             | 34    | ✅ Passed    |
