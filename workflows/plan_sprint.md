---
description: Sprint 规划工作流 — 与 CEO 讨论需求、制定下一批 Sprint 计划并写入 sprint_tracker.md（必须在独立会话中执行，执行 /sprint 前的前置步骤）
---

# Sprint Planning Workflow

当用户输入 `/plan_sprint` 时触发此工作流。

## 定位

此 workflow 是完整 Sprint 生命周期的**第一步**：

```
/plan_sprint (本 workflow) → /sprint (开发) → /audit (审计)
```

**核心职责**: 读取产品文档 + 历史决策上下文，与 CEO 讨论并制定下一批 Sprint 计划，最终将结论写入 `docs_v2/sprint_tracker.md` 和 `docs_v2/design_decisions.md`，确保后续会话能无缝接力。

---

## 核心纪律

1. **只规划，不执行**：本 workflow 不写任何业务代码，只产出计划文档
2. **决策必须落地**：所有讨论出的架构/产品决策必须在本会话结束前写入 `design_decisions.md`
3. **Sprint 计划必须标准化**：产出的 Task 表格必须符合 `sprint_tracker.md` 现有格式，可被 `/sprint` 直接消费
4. **依赖关系显式化**：Sprint 之间的依赖必须在表格中注明，不允许隐含假设
5. **验收标准可测试**：每个 Sprint 的验收标准必须可被 `/audit` 量化检查

---

## Step 1: 加载全量上下文（自动执行）

// turbo

按顺序读取以下文件：

```
1. docs_v2/sprint_tracker.md       → 当前以完成到哪个 Sprint，以及已规划的未来 Sprint
2. docs_v2/design_decisions.md     → 历史架构/产品决策，避免重复讨论已定事项
3. docs_v2/product_vision.md       → 产品方向和差异化壁垒，规划时对齐
4. docs_v2/architecture.md         → 技术架构设计，确认规划的可行性
5. docs_v2/sprints/audit-sprint-{最新N}.md  → 最近一次审计报告，了解遗留问题
```

读完后向用户汇报现状摘要：

> "当前已完成：Sprint 1-{N}。已规划待执行：Sprint {N+1}-{M}（共 {k} 个 Sprint，{n} 个 Task）。
> 上次审计遗留问题：{issues}。
> 历史关键决策：{D001/D002/... 摘要}。
> 
> 请告诉我：① 是否调整已规划的 Sprint？② 还是继续规划更后面的 Sprint？③ 有新的产品想法需要讨论？"

---

## Step 2: 现状差距分析

对照 `docs_v2/product_vision.md` 的里程碑和 `docs_v2/architecture.md` 的模块清单：

1. **列出已实现的核心能力**（从 sprint_tracker.md 中已完成的 Sprint 归纳）
2. **列出尚未实现的关键能力**（按优先级排序）
3. **指出优先级依据**：哪些是其他功能的依赖项（必须先做），哪些是独立模块（可并行规划）

向用户展示差距分析表：

```markdown
| 能力 | 设计出处 | 优先级 | 依赖 | 状态 |
|------|---------|--------|------|------|
| ... | ... | P0/P1/P2 | Sprint N | ⬜ 未做 |
```

**暂停，让用户确认或调整优先级**。

---

## Step 3: Sprint 方案讨论

针对用户确认的优先级，逐个 Sprint 与用户讨论：

### 对每个待规划的 Sprint：

**3.1 提出方案**

提出 Sprint 的：
- 核心目标（一句话）
- 为什么现在做（依赖关系 + 产品价值）
- 初步 Task 拆解（3-8 个，每个 Task 预估 3-6 个测试）
- 关键技术/产品决策点（需要 CEO 拍板的问题）

**3.2 讨论开放问题**

将本 Sprint 涉及的**关键决策点**明确列出，逐一与 CEO 讨论：

```
> Q{n}: {问题描述}
> 选项 A: {描述} — 优点: ... 缺点: ...
> 选项 B: {描述} — 优点: ... 缺点: ...
> 推荐: {推荐选项 + 理由}
```

**暂停，等待 CEO 决策。**

**3.3 确认后锁定**

CEO 做出决策后：
- 记录决策结论
- 更新 Task 描述（按决策调整具体实现细节）
- 明确验收标准（可被 `/audit` 量化的具体条件）

---

## Step 4: 将计划写入 sprint_tracker.md

// turbo

按 `sprint_tracker.md` 现有格式追加新 Sprint：

```markdown
### Sprint {N}: {名称}

**目标**: {一句话目标}

**架构依赖**: {需要哪个 Sprint 先完成，或「无依赖」}

**关键设计决策**: {本次规划讨论中确认的决策摘要，供后续会话快速理解上下文}

| Task | 描述 | 文件 | 状态 |
|------|------|------|------|
| T01 | {描述} | {文件路径} | ⬜ |
| ... | ... | ... | ... |

**验收标准**:
- {可被 /audit 量化检查的具体条件}
```

**⚠️ 格式要求**:
- Task 描述必须包含：做什么 + 在哪个文件 + 关键实现方式
- 状态统一用 `⬜`（未开始）
- 验收标准用动词开头，具体可测（不写「完成 X」，写「X 在 DB 持久化 / 测试用例覆盖 Y 场景 / API 返回 Z 格式」）

---

## Step 5: 将新决策写入 design_decisions.md

// turbo

对本次规划讨论中产生的**每一个新的架构/产品决策**，按以下格式追加到 `docs_v2/design_decisions.md`：

```markdown
### D{下一个编号}: {决策标题}

**背景**: {为什么需要做这个决策}

**结论**: {最终选择了什么}

{具体实现细节/示意图}

**选择此方案的理由**: {为什么选这个而不是其他选项}

**影响的文件**: {哪些文件需要按此决策实现}
```

在文件顶部的日期章节下添加，保持倒序排列。

---

## Step 6: 更新 sprint_tracker.md 使用方法

确认「使用方法 → 完整 Sprint 生命周期」章节包含 `/plan_sprint` 的说明（已在 sprint_tracker.md 中持久化，通常不需要修改）。

---

## Step 7: 汇报与交接

向用户发送最终汇报：

> "Sprint 规划完成。
>
> **本次规划了**:
> - Sprint {N}: {目标}（{n} 个 Task）
> - Sprint {N+1}: {目标}（{n} 个 Task）[如有]
>
> **新增决策** {x} 条（D{xxx} - D{yyy}），已写入 design_decisions.md。
>
> **写入 sprint_tracker.md** ✅
>
> **下一步**: 在新会话中输入 `/sprint` 开始执行 Sprint {N}。"

**强制暂停。规划到此结束。执行 `/sprint` 必须在新会话中启动。**
