# 🧰 沐挚的 Skill 仓库 · MuZhi Skills

个人的 [Codex](https://github.com/openai/codex) Skill 合集——即插即用的扩展，提升你的编码体验。

A personal collection of [Codex](https://github.com/openai/codex) skills — plug-and-play extensions that enhance your coding workflow.

---

## 📦 可用 Skill · Available Skills

### 🧹 session-cleaner

> 清理项目目录已不存在（已删除/已移动）的孤儿 Codex 会话文件。
> Clean up orphaned Codex session files whose project directories no longer exist on disk.

长期使用 Codex 后，`~/.codex/sessions` 下会堆积大量已删项目的残留会话，占用磁盘空间。这个 Skill 一键扫干净。

**功能 · What it does:**

- 扫描 `~/.codex/sessions` 下所有 `*.jsonl` 会话文件
- 读取每个文件提取原始项目路径（`cwd`）
- 检查项目目录是否仍存在于磁盘
- 删除项目已消失的会话
- 清理空的日期子目录
- 输出删除/保留数量汇总

**触发词 · Triggers:** "清理无用对话" / "清理 Codex 会话" / "删除过期对话" / "清理孤儿会话" / "clean up Codex sessions"

---

## 🔧 安装 · Install

一行命令安装任意 Skill：

```bash
codex skills install --repo y3078266584/muzhi-skills --path <skill-name>
```

示例：

```bash
codex skills install --repo y3078266584/muzhi-skills --path session-cleaner
```

或使用完整 GitHub URL：

```bash
codex skills install --url https://github.com/y3078266584/muzhi-skills/tree/main/<skill-name>
```

> ⚠️ 安装后需重启 Codex 才能识别新 Skill。Restart Codex after installation to pick up new skills.

---

## 🤝 贡献 · Contributing

有好点子？欢迎 PR！每个 Skill 独立一个目录，至少包含 `SKILL.md`。参考 [session-cleaner](./session-cleaner) 的目录结构即可。

---

## ⭐ Star 趋势 · Star History

[![Star History Chart](https://api.star-history.com/svg?repos=y3078266584/muzhi-skills&type=Date)](https://star-history.com/#y3078266584/muzhi-skills&Date)
