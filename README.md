# 🧰 沐挚的 Skill 仓库 · MuZhi Skills

<p align="center">
  <i>个人的 <a href="https://github.com/openai/codex">Codex</a> Skill 合集——即插即用的扩展，提升你的编码体验。</i>
  <br>
  <i>A personal collection of <a href="https://github.com/openai/codex">Codex</a> skills — plug-and-play extensions that enhance your coding workflow.</i>
</p>

---

## 🌟 为什么需要？ · Why?

Coding Agent 用久了，总有些"家务活"让人头疼。这些 Skill 就是你的自动化小帮手，**一句话触发，自动搞定**。

After weeks of using a coding agent, the housekeeping piles up. These skills are your one-command fix — **say the word, and it's handled**.

| 痛点 Pain Point | 解决方案 Solution |
| :--- | :--- |
| 💔 Codex Windows 端 Computer Use 不可用 / 插件报 "not installed" | [codex-plugin-doctor](#-codex-plugin-doctor) 自动诊断修复 |
| 🗑️ 已删项目的 Codex 会话残留，白白占空间 | [session-cleaner](#-session-cleaner) 一键扫描清理 |
| 🐚 在 PowerShell 里写命令，引号嵌套总翻车 | [powershell-quoting](#-powershell-quoting) 规则速查，告别犯错 |
| ✍️ 想用沐挚的温和风格写文章，但每次都手调 | [muzhi-writer](#-muzhi-writer) 一键套用写作风格 |

---

## 📦 可用 Skill · Available Skills

### 🩺 codex-plugin-doctor

> 诊断并修复 Codex Windows 端 openai-bundled 插件（Browser、Chrome、**Computer Use**）不可用的问题——包括重启后 Computer Use 无法启动、插件显示 "not installed" 等高频故障。
> Diagnose and repair Codex openai-bundled plugins (Browser, Chrome, **Computer Use**) on Windows — including the common "Computer Use won't start after restart" and "not installed" issues.

**🐧 特别针对 Windows Computer Use 修复 · Windows Computer Use fix:**
这是目前 Codex Windows 用户遇到最多的问题之一——重启后 Computer Use 消失、无法控制桌面应用。本 Skill 自动处理根因并恢复。

**修复项 · What it fixes:**

- 🖥️ **Computer Use 不可用** —— 自动注册 computer-use@openai-bundled 到 config.toml，确保 Codex 能发现并启动该插件
- Chrome latest 目录链接 —— 指向错误或缺失，导致原生消息主机路径解析失败
- 插件注册 —— chrome@openai-bundled 和 computer-use@openai-bundled 未写入 config.toml
- 市场损坏 —— .codex\.tmp\bundled-marketplaces\ 目录不完整（Codex 启动时从 WindowsApps 拷贝失败）
- 市场持久化 —— 将市场从临时目录迁移到 .codex\marketplaces\，避免重启后被清除
- 支持 -DryRun 预览模式，改动前先看影响范围

**触发词 · Triggers:** "修复插件" / "插件坏了" / "Computer Use 用不了" / "plugin not working" / "插件未安装" / "Codex plugin doctor" / "plugin repair"

---

### 🧹 session-cleaner

> 清理项目目录已不存在（已删除/已移动）的孤儿 Codex 会话文件。
> Clean up orphaned Codex session files whose project directories no longer exist on disk.

长期使用 Codex 后，~/.codex/sessions 下会堆积大量已删项目的残留会话，占用磁盘空间。这个 Skill 一键扫干净。

**功能 · What it does:**

- 扫描 ~/.codex/sessions 下所有 *.jsonl 会话文件
- 读取每个文件提取原始项目路径（cwd）
- 检查项目目录是否仍存在于磁盘
- 删除项目已消失的会话
- 清理空的日期子目录
- 输出删除/保留数量汇总

**触发词 · Triggers:** "清理无用对话" / "清理 Codex 会话" / "删除过期对话" / "清理孤儿会话" / "clean up Codex sessions"

---

### 🐚 powershell-quoting

> PowerShell 引号转义规则与最佳实践——在 Windows/PowerShell 环境中编写命令时，帮你避免嵌套引号翻车。
> PowerShell quoting rules and best practices — avoid nested-quote disasters when writing commands on Windows.

**功能 · What it does:**

- 引号行为速查（单引号 / 双引号 / 反引号）
- 常见错误场景与正确写法：外部 exe 传参、JSON 传递、cmd /c 嵌套、Start-Process splatting
- 安全检查清单，写命令前逐条对照

**触发词 · Triggers:** 在 Windows/PowerShell 环境中编写命令时自动触发，避免嵌套引号错误

---

### ✍️ muzhi-writer

> 沐挚的个人写作风格 Skill。以"像写信给朋友一样"的温和底色浸润任何文字——无论写什么，风格始终如一。
> MuZhi's personal writing style. A warm, letter-to-a-friend tone that permeates anything you write.

基于卡兹克（Khazix）的 [khazix-writer](https://github.com/KKKKhazix/khazix-skills) 方法论进行个人风格化改写。采用**反向构建法**：先手写风格规则 + 四层自检体系（L1硬性规则 → L2风格一致性 → L3内容质量 → L4活人感终审），再通过 AI 迭代补全。

**核心特点 · Core features:**
- 🎨 **温和克制**的中文写作底色，融合古典词汇与现代口语
- 🔍 **微观古典替换**——不靠大段文言，靠一字一词的选择（于、愈、而、终而、并非、抑或等）
- 🧠 **自然的思考推进**——从不确定走向理解，而非硬塞"模板式转折"
- ✅ **四层自检**输出格式，产出后可一键质检
- 🧩 附完整风格示例库（含证据对照表）+ 内容方法论
- 🙏 框架方法论源自 [khazix-writer](https://github.com/KKKKhazix/khazix-skills)

**触发词 · Triggers:** "写文章" / "帮我写" / "续写" / "按我的风格写" / "沐挚风格" / "写成笔记" / "帮我表达"

---

## 🔧 安装 · Install

一行命令安装任意 Skill：

`ash
codex skills install --repo y3078266584/muzhi-skills --path <skill-name>
`

示例：

`ash
# codex-plugin-doctor（最高频，推荐先装）
codex skills install --repo y3078266584/muzhi-skills --path codex-plugin-doctor

# session-cleaner
codex skills install --repo y3078266584/muzhi-skills --path session-cleaner

# powershell-quoting
codex skills install --repo y3078266584/muzhi-skills --path powershell-quoting

# muzhi-writer
codex skills install --repo y3078266584/muzhi-skills --path muzhi-writer
`

或使用完整 GitHub URL：

`ash
codex skills install --url https://github.com/y3078266584/muzhi-skills/tree/main/<skill-name>
`

> ⚠️ 安装后需重启 Codex 才能识别新 Skill。Restart Codex after installation to pick up new skills.

---

## 🤝 贡献 · Contributing

有好点子？欢迎 PR！每个 Skill 独立一个目录，至少包含 SKILL.md。参考现有 Skill 的目录结构即可。

---

## ⭐ Star 趋势 · Star History

[![Star History Chart](https://api.star-history.com/svg?repos=y3078266584/muzhi-skills&type=Date)](https://star-history.com/#y3078266584/muzhi-skills&Date)
