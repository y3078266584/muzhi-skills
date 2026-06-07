# 🧰 MuZhi Skills

My personal collection of [Codex](https://github.com/openai/codex) skills — plug-and-play extensions that enhance your coding workflow.

---

## Available Skills

### 🧹 session-cleaner

> Clean up orphaned Codex session files whose project directories no longer exist on disk.

Over time, Codex accumulates session files for projects you've deleted or moved. These orphaned sessions clutter your `~/.codex/sessions` directory and waste disk space.

**What it does:**

- Scans all `*.jsonl` session files under `~/.codex/sessions`
- Reads each file to extract the original project path (`cwd`)
- Checks whether that project directory still exists on disk
- Deletes sessions whose project is gone
- Removes empty date subdirectories to keep things tidy
- Prints a summary of deleted vs. remaining sessions

**Trigger phrases:** "清理无用对话" / "清理 Codex 会话" / "删除过期对话" / "清理孤儿会话" / "clean up Codex sessions"

---

## Install

Install any skill from this repo with a single command:

```bash
codex skills install --repo y3078266584/muzhi-skills --path <skill-name>
```

For example:

```bash
codex skills install --repo y3078266584/muzhi-skills --path session-cleaner
```

Or use the full GitHub URL:

```bash
codex skills install --url https://github.com/y3078266584/muzhi-skills/tree/main/<skill-name>
```

> ⚠️ Restart Codex after installation to pick up new skills.

---

## Contributing

Have an idea for a skill? PRs are welcome! Each skill lives in its own directory with a `SKILL.md` at minimum. See [session-cleaner](./session-cleaner) for an example structure.

---

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=y3078266584/muzhi-skills&type=Date)](https://star-history.com/#y3078266584/muzhi-skills&Date)
