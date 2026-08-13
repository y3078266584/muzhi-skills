# 🧰 沐挚的 Skill 仓库 · MuZhi Skills

<p align="center">
  <i>个人的 <a href="https://github.com/openai/codex">Codex</a> Skill 合集——每个 Skill 独立成仓，本仓库为索引与导航。</i>
  <br>
  <i>A personal collection of <a href="https://github.com/openai/codex">Codex</a> skills — each skill lives in its own repository; this repo is the index and navigation hub.</i>
</p>

---

## 📦 Skill 索引 · Skill Index

| Skill | 独立仓库 Repository | 说明 Description |
| :--- | :--- | :--- |
| 🩺 **codex-plugin-doctor** | [y3078266584/codex-plugin-doctor](https://github.com/y3078266584/codex-plugin-doctor) | 修复 Codex Windows 端 Computer Use / 插件不可用 |
| 🧹 **session-cleaner** | [y3078266584/session-cleaner](https://github.com/y3078266584/session-cleaner) | 清理已删项目的孤儿 Codex 会话 |
| 🐚 **powershell-quoting** | [y3078266584/powershell-quoting](https://github.com/y3078266584/powershell-quoting) | PowerShell 引号转义规则速查 |
| ✍️ **muzhi-writer** | [y3078266584/muzhi-writer](https://github.com/y3078266584/muzhi-writer) | 沐挚的个人写作风格 |
| 🔄 **markitdown-skill** | [y3078266584/markitdown-skill](https://github.com/y3078266584/markitdown-skill) | 转换二进制文件为 Markdown 以便阅读 |

---

## 🔧 安装 · Install

每个 Skill 均为独立 GitHub 仓库，安装方式如下：

```bash
codex skills install --repo y3078266584/<repo-name> --path .
```

示例：

```bash
# codex-plugin-doctor（修复 Windows Computer Use）
codex skills install --repo y3078266584/codex-plugin-doctor --path .

# session-cleaner（清理孤儿会话）
codex skills install --repo y3078266584/session-cleaner --path .

# powershell-quoting（PowerShell 引号规则）
codex skills install --repo y3078266584/powershell-quoting --path .

# muzhi-writer（沐挚写作风格）
codex skills install --repo y3078266584/muzhi-writer --path .

# markitdown-skill（二进制转 Markdown）
codex skills install --repo y3078266584/markitdown-skill --path .
```

> ⚠️ 安装后需重启 Codex 才能识别新 Skill。Restart Codex after installation to pick up new skills.

---

## 🗂️ 本地结构 · Local Layout

本仓库（muzhi-skills）只作为 Skill 索引与说明，不直接包含 Skill 内容。Skill 源码放在本工作区的 `repos/` 子目录下，各自独立维护 Git 仓库：

```
My Skills/
├── AGENTS.md          ← 项目约定
├── README.md          ← 索引文档（本文件）
└── repos/
    ├── codex-plugin-doctor/   ← 独立仓库
    ├── session-cleaner/       ← 独立仓库
    ├── powershell-quoting/    ← 独立仓库
    ├── muzhi-writer/          ← 独立仓库
    └── markitdown-skill/      ← 独立仓库
```

---

## 🤝 贡献 · Contributing

每个 Skill 在 `repos/` 下独立成仓，包含各自的 `SKILL.md`、`agents/openai.yaml` 及可选 `scripts/`。修改或新增 Skill 时，进入对应 `repos/<skill>/` 目录进行独立提交与推送。

---

## ⭐ Star 趋势 · Star History

[![Star History Chart](https://api.star-history.com/svg?repos=y3078266584/muzhi-skills&type=Date)](https://star-history.com/#y3078266584/muzhi-skills&Date)
