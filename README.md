<div align="center">

# 🔐 OPC Workflow

**给 AI 辅助开发的执行纪律框架**

*让你继续用 Cursor / Claude Code / Kiro，但让 AI 不说谎、不跑偏、不造假。*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Works with Claude](https://img.shields.io/badge/Works%20with-Claude-orange)](https://claude.ai)
[![Works with Cursor](https://img.shields.io/badge/Works%20with-Cursor-blue)](https://cursor.sh)
[![Works with Kiro](https://img.shields.io/badge/Works%20with-Kiro-green)](https://kiro.dev)
[![Works with Antigravity](https://img.shields.io/badge/Works%20with-Antigravity-purple)](https://deepmind.google)

</div>

---

## 问题

你用 AI 工具写代码，但：

- **AI 在执行阶段说谎**：写假测试、写看起来能跑但逻辑错误的代码
- **长上下文退化**：上下文越长，AI 越不听话，越偏离你最初的设计
- **没有执行纪律**：没有任何机制强制 AI 在执行时对照原始设计

现有工具的局限：

| 工具 | 问题 |
|------|------|
| Cursor / Windsurf | 无跨 Sprint 上下文隔离，长项目退化 |
| Claude Code | 单次执行，无设计约束验证 |
| Kiro | Spec 是静态文件，执行时不主动查询约束 |
| GitHub Copilot | 无项目级设计锚定 |

---

## 解决方案

OPC Workflow 是**三个 Markdown 文件**，可以被任意 AI 工具执行：

```
workflows/
  ├── plan_sprint.md   → 与 AI 讨论、制定 Sprint 计划、锁定架构决策
  ├── sprint.md        → TDD + 强制研究先于编码 + 每 Task 必须暂停确认
  └── audit.md         → 零信任审计：变异测试 + 假测试扫描 + 逻辑完整性
```

**核心机制**：

- `/plan_sprint` — AI 读取产品文档 + 历史决策，与你讨论并制定 Sprint 计划
- `/sprint` — 强制 TDD 循环，每 Task 前必须研究框架能力，每 Task 后必须暂停确认
- `/audit` — 独立会话运行，零信任审核上一个 Sprint（变异测试 + 假测试扫描）

---

## 📊 实战数据

> 以下数据来自作者用 OPC Workflow 开发的一个本地实践项目，真实记录，持续更新：

| 指标 | 数据 |
|------|------|
| 已完成 Sprint | 7 个 |
| 累计测试 | 459 个 |
| 变异测试捕获率 | 100%（6/6）|
| 审计发现的致命 Bug | 1 个（Harness 安全边界绕过）|
| 假测试（`assert is not None`）| 27 个被发现并修复 |
| 最近更新 | 2026-04-17 |

这些数字真实，不是演示数据。

致命 Bug 是在第一次独立审计中发现的——某个执行模块直接实例化组件，绕过了注册中心，导致安全边界、工具注入、内存系统全部失效。如果没有 `/audit` 的独立会话机制，这个 Bug 可能永远不会被发现，因为开发者本人写了代码也写了测试，确认偏差导致盲区。

---

## 快速开始

### 1. 复制工作流到你的项目

```bash
mkdir -p .agents/workflows
curl -o .agents/workflows/plan_sprint.md \
  https://raw.githubusercontent.com/yourusername/opc-workflow/main/workflows/plan_sprint.md
curl -o .agents/workflows/sprint.md \
  https://raw.githubusercontent.com/yourusername/opc-workflow/main/workflows/sprint.md
curl -o .agents/workflows/audit.md \
  https://raw.githubusercontent.com/yourusername/opc-workflow/main/workflows/audit.md
```

### 2. 准备项目文档（工作流会读取这些文件）

```
docs/
  ├── sprint_tracker.md    → Sprint 进度追踪（见 docs/templates/sprint_tracker.md）
  ├── design_decisions.md  → 架构/产品决策记录
  ├── product_vision.md    → 产品方向（可选）
  └── architecture.md      → 技术架构（可选）
```

### 3. 开始第一个 Sprint

在你的 AI 工具（Claude / Cursor / Kiro）中输入：

```
/plan_sprint
```

AI 会读取你的项目文档，与你讨论，制定 Sprint 计划。

---

## 工作流说明

### `/plan_sprint` — Sprint 规划

- 读取产品文档 + 历史决策
- 与你讨论 Sprint 目标和 Task 拆解
- 将结论写入 `sprint_tracker.md` 和 `design_decisions.md`
- **必须在独立会话执行**（与 /sprint 分开）

### `/sprint` — Sprint 开发

**9 条核心纪律：**

1. 每个 Sprint 在单次会话内完成（短上下文原则）
2. 每个 Task 完成后暂停等待确认
3. 零假测试容忍（禁止 `assert True`）
4. 先验证基线再开始新 Task
5. 变更最小化（只改必要文件）
6. **研究先于编码**（写代码前必须研究框架能力，产出能力映射表）
7. 功能完整性优于测试通过率
8. 深究测试失败根本原因
9. 审计报告只读（不在 sprint 会话中修改）

### `/audit` — 零信任审计

- **必须在独立会话执行**
- 空断言扫描（`assert True` / `assert is not None`）
- 过度 Mock 扫描（是否 mock 了被测逻辑本身）
- 变异测试（故意改坏代码，测试必须变红）
- 逻辑完整性检查（对照设计文档）
- 产出审计报告（证据驱动，附文件路径和行号）

---

## 设计原则

**短上下文 + 清晰边界**

每个 Sprint 在单次会话内完成，Sprint 之间通过文件系统传递上下文。这解决了 LLM 长上下文退化的根本问题。

**独立审计**

`/audit` 必须在与 `/sprint` 不同的会话中执行。目的是消除开发会话的确认偏差——开发者不能自己审计自己的代码。

**证据驱动**

审计报告中的所有结论必须附带具体文件路径和行号。没有证据的结论不计入。

**研究先于编码**

AI 天生倾向"直接写代码"而不是"先研究框架能力"。`/sprint` 强制在每个 Sprint 开始时产出能力映射表，再进入实现。

---

## 完整 Sprint 生命周期

```
/plan_sprint (会话 A)
    读取产品文档 + 历史决策
    与你讨论 Task 拆解
    写入 sprint_tracker.md
        ↓ 关闭会话
/sprint (会话 B)
    研究框架能力 → 产出能力映射表
    逐 Task 执行 TDD 循环
    每 Task 后暂停确认
    生成 sprint-N-review.md
        ↓ 关闭会话
/audit (会话 C)
    独立审核 Sprint N
    变异测试 + 假测试扫描
    产出 audit-sprint-N.md
        ↓
CEO 验收 → 通过 / 打回修复
```

---

## 活体案例

作者正在用 OPC Workflow 开发一个本地 AI 工程项目，每完成一个 Sprint，README 中的实战数据实时更新。

这是方法论有效性的持续验证——不是 Demo，是真实的开发过程。

---

## 贡献

欢迎以下类型的贡献：

- **工具适配**：为特定 AI 工具优化工作流（Claude Code / Cursor / Kiro）
- **技术栈模板**：针对特定语言或框架的 Sprint 模板
- **案例分享**：你用 opc-workflow 的项目（发 issue）

详见 [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## License

MIT — 自由使用，欢迎改造，请保留原始链接。
