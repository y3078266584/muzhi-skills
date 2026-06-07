---
name: session-cleaner
description: Clean up orphaned Codex session files whose project directories no longer exist on disk. Use when the user asks to clean up Codex sessions, remove unused project conversations, clear orphaned dialogs, tidy up session files, delete old project threads, or says "清理无用对话", "清理 Codex 会话", "删除过期对话", "清理 sessions", "删除不在项目列表的对话", "清理孤儿会话". This skill scans all session jsonl files, extracts their cwd project path, deletes sessions where the project no longer exists, and removes empty date directories.
---

# Session Cleaner

Clean up orphaned Codex session files in `$env:USERPROFILE\.codex\sessions`.

## Workflow

Run the cleanup script:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts/clean_sessions.ps1"
```

The script scans all sessions, reports orphaned projects and their session counts, deletes orphaned files, and removes empty date directories. It prints a summary of deleted vs. remaining sessions.

## How It Works

- Scans all `*.jsonl` files under `$env:USERPROFILE\.codex\sessions`
- Reads the first line of each file to extract the `cwd` project path
- Checks via `Test-Path` whether the project directory still exists on disk
- Deletes sessions whose project directory is missing
- Removes empty date subdirectories afterward
