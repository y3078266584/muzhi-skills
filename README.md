# 🧰 沐挚的 Skill 仓库 · MuZhi Skills

<p align="center">
  <i>个人的 <a href="https://github.com/openai/codex">Codex</a> Skill 合集——即插即用的扩展，提升你的编码体验。</i>
  <br>
  <i>A personal collection of <a href="https://github.com/openai/codex">Codex</a> skills — plug-and-play extensions that enhance your coding workflow.</i>
</p>

---

## 🌟 为什么需要？ · Why?

Coding Agent 用久了，总有些"家务活"让人头疼：会话文件越堆越多占磁盘、插件莫名失效查半天……这些 Skill 就是你的自动化小帮手，**一句话触发，自动搞定**。

After weeks of using a coding agent, the housekeeping piles up: orphaned session files eating disk space, plugins mysteriously breaking… These skills are your one-command fix — **say the word, and it's handled**.

| 痛点 Pain Point | 解决方案 Solution |
| :--- | :--- |
| 🗑️ 已删项目的 Codex 会话残留，白白占空间 | [`session-cleaner`](#-session-cleaner) 一键扫描清理 |
| 💔 Codex 插件重启后报 "not installed" | [`codex-plugin-doctor`](#-codex-plugin-doctor) 自动诊断修复 |

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

### 🩺 codex-plugin-doctor

> 诊断并修复 Codex 的 openai-bundled 插件（Browser、Chrome、Computer Use）在 Windows 上不可用的问题。
> Diagnose and repair Codex openai-bundled plugins (Browser, Chrome, Computer Use) on Windows.

Codex 重启后插件显示 "not installed"？Browser / Chrome / Computer Use 突然用不了？这个 Skill 自动排查根因并修复。

**修复项 · What it fixes:**

- Chrome `latest` 目录链接 —— 指向错误或缺失，导致原生消息主机路径解析失败
- 插件注册 —— `chrome@openai-bundled` 和 `computer-use@openai-bundled` 未写入 `config.toml`
- 市场损坏 —— `.codex\.tmp\bundled-marketplaces\` 目录不完整（Codex 启动时从 WindowsApps 拷贝失败）
- 市场持久化 —— 将市场从临时目录迁移到 `.codex\marketplaces\`，避免重启后被清除
- 支持 `-DryRun` 预览模式，改动前先看影响范围

**触发词 · Triggers:** "修复插件" / "插件坏了" / "plugin not working" / "插件未安装" / "Codex plugin doctor" / "plugin repair"

---

## 🔧 安装 · Install

一行命令安装任意 Skill：

```bash
codex skills install --repo y3078266584/muzhi-skills --path <skill-name>
```

示例：

```bash
# session-cleaner
codex skills install --repo y3078266584/muzhi-skills --path session-cleaner

# codex-plugin-doctor
codex skills install --repo y3078266584/muzhi-skills --path codex-plugin-doctor
```

或使用完整 GitHub URL：

```bash
codex skills install --url https://github.com/y3078266584/muzhi-skills/tree/main/<skill-name>
```

> ⚠️ 安装后需重启 Codex 才能识别新 Skill。Restart Codex after installation to pick up new skills.

---

## 🤝 贡献 · Contributing

有好点子？欢迎 PR！每个 Skill 独立一个目录，至少包含 `SKILL.md`。参考现有 Skill 的目录结构即可。

---

## ⭐ Star 趋势 · Star History

[![Star History Chart](https://api.star-history.com/svg?repos=y3078266584/muzhi-skills&type=Date)](https://star-history.com/#y3078266584/muzhi-skills&Date)
