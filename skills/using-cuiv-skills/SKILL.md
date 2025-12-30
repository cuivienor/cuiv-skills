---
name: using-cuiv-skills
description: Introduction to Peter's personal skills - auto-loaded at session start
---

# Peter's Personal Skills

This plugin contains personal workflow skills and patterns.

## How to Use

Use the `Skill` tool to invoke skills by name:
- `cuiv-skills:example` - Example/demo skill

## Available Skills

Check the skill list in your available tools - skills from this plugin are prefixed with `cuiv-skills:`.

## Adding New Skills

Skills live in `ai/claude-plugins/cuiv-skills/skills/<skill-name>/SKILL.md`

Format:
```yaml
---
name: skill-name
description: "When to use this skill..."
---

# Skill content in markdown
```
