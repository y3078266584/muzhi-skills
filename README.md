# MuZhi Skills

My personal collection of [Codex](https://github.com/openai/codex) skills.

## Available Skills

| Skill | Description |
|-------|-------------|
| [session-cleaner](./session-cleaner) | Clean up and manage Codex session files |

## Install

Install any skill from this repo using the Codex skill-installer:

```
codex skills install --repo y3078266584/muzhi-skills --path <skill-name>
```

For example, to install `session-cleaner`:

```
codex skills install --repo y3078266584/muzhi-skills --path session-cleaner
```

You can also use the full GitHub URL:

```
codex skills install --url https://github.com/y3078266584/muzhi-skills/tree/main/<skill-name>
```

After installation, restart Codex to pick up the new skill.
