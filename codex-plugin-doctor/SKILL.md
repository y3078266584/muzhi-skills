---
name: codex-plugin-doctor
description: Diagnose and repair Codex openai-bundled plugins (browser@, chrome@, computer-use@) on Windows. Use when Codex plugins become unavailable, show as "not installed" after restart, or when browser/Chrome/Computer Use plugins fail to work. Triggers on: plugin repair, fix plugins, plugin not working, plugin not installed, openai-bundled repair, Codex plugin doctor.
---

# Codex Plugin Doctor

Repair openai-bundled plugins on Windows Codex desktop. This skill fixes the root causes that lead to `browser@openai-bundled`, `chrome@openai-bundled`, and `computer-use@openai-bundled` showing as "not installed" or failing to work.

## Quick Repair

Run the repair script. It auto-detects all Codex paths and handles the fixes:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-root>/scripts/repair-openai-bundled.ps1"
```

Use `-DryRun` first to preview without making changes:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-root>/scripts/repair-openai-bundled.ps1" -DryRun
```

The script is idempotent — safe to run multiple times.

## What It Fixes

The script diagnoses and repairs four known issues:

1. **Chrome `latest` junction** — Points to the wrong directory or is missing, breaking native messaging host path resolution
2. **Plugin registration** — `chrome@openai-bundled` and `computer-use@openai-bundled` missing from `config.toml` `[plugins]` section
3. **Corrupted marketplace** — The `openai-bundled` marketplace in `.codex\.tmp\bundled-marketplaces\` is incomplete (Codex fails to copy all plugins from WindowsApps on startup)
4. **Marketplace persistence** — Moves the marketplace from `.codex\.tmp\` (wiped on restart) to `.codex\marketplaces\` (persistent) and updates `config.toml` accordingly

## After Repair

- **Restart Codex** for changes to take effect. `codex-computer-use.exe` will be auto-started by Codex on next launch.
- Verify with: `codex plugin list` — all three plugins should show `installed, enabled`.

## Manual Verification

```powershell
# Check marketplace registration
codex plugin marketplace list

# Check plugin status
codex plugin list | Select-String "openai-bundled"

# Check Chrome extension
node <codex-home>\plugins\cache\openai-bundled\chrome\latest\scripts\check-extension-installed.js --json
```

## Troubleshooting

- If script fails to find WindowsApps: ensure Codex desktop is installed. The script uses `Get-AppxPackage` for detection.
- If `robocopy` fails: the WindowsApps source may be locked. Restart the machine and retry.
- If plugins still show "not installed": open Codex Plugin settings and enable them manually, then re-run the script.
