# OPC Workflow — 工作流文件说明

这个目录包含三个核心工作流文件，按顺序使用：

```
/plan_sprint → /sprint → /audit
```

## 如何在你的 AI 工具中使用

### Claude Code
将文件放入 `.agents/workflows/`：
```bash
mkdir -p .agents/workflows
cp plan_sprint.md sprint.md audit.md .agents/workflows/
```
在对话中输入 `/plan_sprint`、`/sprint` 或 `/audit` 触发。

### Cursor
将文件内容添加到 `.cursorrules` 或使用 `@file` 引用：
```
@.agents/workflows/sprint.md 开始执行 Sprint
```

### Kiro
将文件放入 `.kiro/steering/`，Kiro 会自动加载。

### Gemini (Antigravity)
将文件内容添加到 user rules，或在对话中 `@file` 引用。

---

## 文件说明

| 文件 | 作用 | 执行时机 |
|------|------|---------|
| `plan_sprint.md` | Sprint 规划，制定计划 | 每个 Sprint 开始前，单独会话 |
| `sprint.md` | Sprint 开发，TDD 执行 | Sprint 执行阶段，单独会话 |
| `audit.md` | 零信任审计，质量验证 | Sprint 完成后，单独会话 |
