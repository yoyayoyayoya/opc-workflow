# OPC Agents — 活体案例

> OPC Agents 是一个 AI Agent 协作平台，使用 OPC Workflow 进行开发。
> 它是 opc-workflow 方法论有效性的持续验证。

## 项目概况

- **仓库**: [opc-agents](https://github.com/yourusername/opc-agents)
- **技术栈**: Python / FastAPI / CrewAI
- **开始使用 OPC Workflow**: 2025-10-xx（Sprint 1 起）

## 实战数据（持续更新）

| 指标 | 数据 | 最后更新 |
|------|------|---------|
| 已完成 Sprint | 7 | 2026-04-17 |
| 累计测试 | 459 | 2026-04-17 |
| 变异测试捕获率 | 100%（6/6）| 2026-04-17 |
| 审计发现致命 Bug | 1 | Sprint 3 |
| 假测试被清除 | 27 | 累计 |

## 关键发现

### Sprint 3 审计：Harness 安全边界绕过

**现象**：`sprint_executor.py` 直接实例化 Agent，绕过了 `AgentRegistry`。

**影响**：Harness 安全边界、工具注入、内存系统全部失效。

**被发现方式**：独立 `/audit` 会话，变异测试捕获。

**为什么开发者自己没发现**：开发者在开发会话中写了代码也写了测试，确认偏差导致盲区。独立审计会话消除了这个偏差。

## Sprint 历史

| Sprint | 目标 | 测试数 | 审计状态 |
|--------|------|--------|---------|
| Sprint 1 | Agent 基础框架 | 45 | ✅ 通过 |
| Sprint 2 | 任务调度系统 | 78 | ✅ 通过 |
| Sprint 3 | Harness 系统 | 112 | ✅ 通过（发现 1 致命 Bug）|
| Sprint 4 | 记忆系统 | 89 | ✅ 通过 |
| Sprint 5 | 工具注入 | 67 | ✅ 通过 |
| Sprint 6 | 星级系统 | 34 | ✅ 通过 |
| Sprint 7 | TUI + MCP | 34 | ✅ 通过 |
