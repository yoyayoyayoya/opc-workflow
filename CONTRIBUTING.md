# 贡献指南

感谢你对 OPC Workflow 的兴趣！

---

## 贡献类型

### 1. 🔧 工具适配（Tool Adapters）

**目标**：针对特定 AI 工具优化 workflow 行为。

不同工具有不同的指令格式和上下文机制：

| 工具 | 现状 | 适配方向 |
|------|------|---------|
| Claude Code | ✅ 已验证 | slash commands + CLAUDE.md |
| Cursor | 部分验证 | `.cursorrules` 集成 |
| Kiro | 部分验证 | Steering 文件集成 |
| Gemini (Antigravity) | ✅ 已验证 | user_rules 集成 |
| GitHub Copilot Chat | 未验证 | / |

**提交方式**：
1. 在 `workflows/adapters/{tool-name}/` 下创建适配文档
2. 说明适配方式和已验证的场景（说明你在什么真实项目中验证，可以不透露项目名称）
3. 提供 PR

---

### 2. 📦 技术栈模板（Stack Templates）

**目标**：为不同技术栈提供专属 Sprint 模板，减少用户配置负担。

模板位置：`workflows/templates/{stack-name}/`

**已知需求**（来自社区反馈）：

- Python / FastAPI 后端
- React / Next.js 前端
- React Native 移动端
- Rust CLI 工具
- Go microservices

**模板内容**：
- `sprint.md` 变体（针对技术栈的测试命令、lint 工具等）
- `audit.md` 变体（针对技术栈的变异测试策略）
- `docs/` 目录模板（`sprint_tracker.md` + `design_decisions.md` 初始版本）

---

### 3. 📖 案例分享（Case Studies）

**目标**：积累真实的使用数据，构建方法论的可信度。

**提交方式**：
1. 发一个 issue，标题格式：`[Case Study] 你的项目名`
2. 内容包含：
   - 技术栈
   - 已完成的 Sprint 数量
   - 累计测试数量
   - 用 OPC Workflow 发现的有意义的 Bug（如有）
   - 项目链接（可选，可以匿名）

---

## 提交流程

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feat/cursor-adapter`
3. 提交改动（遵循 [Conventional Commits](https://www.conventionalcommits.org/)）
4. 发起 PR，描述你的改动和验证方式

---

## 质量标准

提交的 workflow 变体或模板必须满足：

- [ ] 已在真实项目中验证（不是纸上谈兵）
- [ ] 核心三条纪律不得削弱：**独立审计**、**研究先于编码**、**零假测试容忍**
- [ ] 有具体的使用说明和示例

---

## 版权

贡献的内容遵循本仓库的 MIT 协议。
