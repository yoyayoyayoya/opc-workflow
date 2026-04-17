<div align="center">

# 🔐 OPC Workflow

**给 AI 辅助开发的执行纪律框架**

*让你继续用 Cursor / Claude Code / Kiro，但让 AI 不说谎、不跑偏、不造假。*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Works with Claude](https://img.shields.io/badge/Works%20with-Claude-orange)](https://claude.ai)
[![Works with Cursor](https://img.shields.io/badge/Works%20with-Cursor-blue)](https://cursor.sh)
[![Works with Kiro](https://img.shields.io/badge/Works%20with-Kiro-green)](https://kiro.dev)
[![Works with Antigravity](https://img.shields.io/badge/Works%20with-Antigravity-purple)](https://deepmind.google)

[English](./README.md) | [中文](./README.zh.md)

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

**macOS / Linux**
```bash
bash <(curl -sSL https://raw.githubusercontent.com/yoyayoyayoya/opc-workflow/main/install.sh)
```

**Windows（PowerShell）**
```powershell
iex (iwr -useb 'https://raw.githubusercontent.com/yoyayoyayoya/opc-workflow/main/install.ps1').Content
```

> WSL / Git Bash 用户可以直接使用上面的 bash 命令。

脚本会：
1. 询问你的项目目录路径
2. 选择你的 AI 工具（Claude Code / Antigravity / Cursor / Kiro / 其他）
3. 将工作流文件下载到对应工具的正确位置
4. 如果 `docs/` 不存在，自动安装文档模板

### 安装位置

| 工具 | 工作流文件位置 |
|------|--------------|
| Claude Code / Antigravity | `.agents/workflows/` |
| Cursor | `.agents/workflows/`（通过 `@file` 引用）|
| Kiro | `.kiro/steering/`（自动加载）|
| 其他 | `workflows/` |

文档模板（`sprint_tracker.md`、`design_decisions.md`）始终安装到 `docs/`。

## 如何使用

> **核心机制：每个命令在独立的 AI 会话中执行。**
> 这可以防止上下文漂移，并消除审计中的确认偏差。

---

### 开始前——准备项目文档

在项目的 `docs/` 目录下创建以下文件（安装脚本会自动生成模板）：

| 文件 | 用途 |
|------|------|
| `sprint_tracker.md` | 追踪 Sprint 目标、Task 和状态 |
| `design_decisions.md` | 记录架构和产品决策 |
| `architecture.md` | 技术设计文档（可选，但强烈建议）|
| `product_vision.md` | 产品方向（可选）|

---

### 第 1 步 — 规划：`/plan_sprint`

**打开新的 AI 会话，输入 `/plan_sprint`。**

AI 会：
1. 读取你的文档和历史决策
2. 展示差距分析——已完成了什么、还缺什么
3. 与你讨论下一个 Sprint 的目标和 Task 拆解
4. 就开放的架构问题征求你的决策
5. 将最终计划写入 `sprint_tracker.md`

结束后你将得到一份有具体 Task 的 Sprint 计划，可以直接执行。
**关闭此会话。**

---

### 第 2 步 — 开发：`/sprint`

**打开新的 AI 会话，输入 `/sprint`。**

AI 会：
1. 从 `sprint_tracker.md` 读取 Sprint 计划
2. **研究阶段**——研究所有涉及的框架，在写任何代码之前产出 `docs/sprints/sprint-N-capability-map.md`
3. 暂停，等你确认研究结论
4. 逐个 Task 执行 TDD 循环：写测试 → 确认为红 → 写实现 → 确认为绿
5. 每个 Task 后暂停，等你批准
6. 所有 Task 完成后生成 `docs/sprints/sprint-N-review.md`

**关闭此会话。**

---

### 第 3 步 — 审计：`/audit`

**打开新的 AI 会话，输入 `/audit`。**

AI 会（以对上一个会话零信任的独立审阅者身份）：
1. 扫描假测试（空断言、过度 Mock）
2. 运行变异测试——故意改坏每个核心函数，验证测试能捕获到
3. 对照设计文档检查逻辑完整性
4. 产出 `docs/sprints/audit-sprint-N.md`（含文件路径和行号的证据）

**读取审计报告。**

- ✅ **通过** → 进入下一个 Sprint 的规划（回到第 1 步）
- ❌ **不通过** → 打开新的 `/sprint` 会话修复问题，再次运行 `/audit`

修复循环：
```
/sprint（修复会话）→ 关闭 → /audit → 仍不通过？→ /sprint（修复）→ /audit → ... → 通过
```

重复以上循环，直到 audit 通过为止。通过后才能规划下一个 Sprint。

---

### 第 4 步 — 循环

audit 通过后，在新会话中输入 `/plan_sprint` 开始下一个 Sprint。
已关闭的审计发现作为上下文自动延续到下一轮。

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
