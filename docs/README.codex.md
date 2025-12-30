# Cuiv-skills for Codex

Complete guide for using Cuiv-skills with OpenAI Codex.

## Quick Install

Tell Codex:

```
Fetch and follow instructions from https://raw.githubusercontent.com/cuivienor/infra/refs/heads/main/ai/claude-plugins/cuiv-skills/.codex/INSTALL.md
```

## Manual Installation

### Prerequisites

- OpenAI Codex access
- Shell access to install files

### Installation Steps

#### 1. Clone the Infra Repository

```bash
mkdir -p ~/.codex
git clone https://github.com/cuivienor/infra.git ~/.codex/infra
```

#### 2. Create Symlink to Plugin

```bash
ln -sf ~/.codex/infra/ai/claude-plugins/cuiv-skills ~/.codex/cuiv-skills
```

#### 3. Verify Installation

Tell Codex:

```
Run ~/.codex/cuiv-skills/.codex/cuiv-skills-codex find-skills to show available skills
```

You should see a list of available skills with descriptions.

## Usage

### Finding Skills

```
Run ~/.codex/cuiv-skills/.codex/cuiv-skills-codex find-skills
```

### Loading a Skill

```
Run ~/.codex/cuiv-skills/.codex/cuiv-skills-codex use-skill cuiv-skills:brainstorming
```

### Bootstrap All Skills

```
Run ~/.codex/cuiv-skills/.codex/cuiv-skills-codex bootstrap
```

This loads the complete bootstrap with all skill information.

### Personal Skills

Create your own skills in `~/.codex/skills/`:

```bash
mkdir -p ~/.codex/skills/my-skill
```

Create `~/.codex/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

Personal skills override cuiv-skills with the same name.

## Architecture

### Codex CLI Tool

**Location:** `~/.codex/cuiv-skills/.codex/cuiv-skills-codex`

A Node.js CLI script that provides three commands:
- `bootstrap` - Load complete bootstrap with all skills
- `use-skill <name>` - Load a specific skill
- `find-skills` - List all available skills

### Shared Core Module

**Location:** `~/.codex/cuiv-skills/lib/skills-core.js`

The Codex implementation uses the shared `skills-core` module (ES module format) for skill discovery and parsing. This is the same module used by the OpenCode plugin, ensuring consistent behavior across platforms.

### Tool Mapping

Skills written for Claude Code are adapted for Codex with these mappings:

- `TodoWrite` → `update_plan`
- `Task` with subagents → Tell user subagents aren't available, do work directly
- `Skill` tool → `~/.codex/cuiv-skills/.codex/cuiv-skills-codex use-skill`
- File operations → Native Codex tools

## Updating

```bash
cd ~/.codex/infra && git pull
```

## Alternative: Direct Path (No Symlink)

If you prefer not to use symlinks, use the full path:
```bash
~/.codex/infra/ai/claude-plugins/cuiv-skills/.codex/cuiv-skills-codex find-skills
```

## Troubleshooting

### Skills not found

1. Verify installation: `ls ~/.codex/cuiv-skills/skills`
2. Check CLI works: `~/.codex/cuiv-skills/.codex/cuiv-skills-codex find-skills`
3. Verify skills have SKILL.md files

### CLI script not executable

```bash
chmod +x ~/.codex/cuiv-skills/.codex/cuiv-skills-codex
```

### Node.js errors

The CLI script requires Node.js. Verify:

```bash
node --version
```

Should show v14 or higher (v18+ recommended for ES module support).

## Getting Help

- Report issues: https://github.com/cuivienor/infra/issues
- Documentation: https://github.com/cuivienor/infra

## Note

Codex support is experimental and may require refinement based on user feedback. If you encounter issues, please report them on GitHub.
