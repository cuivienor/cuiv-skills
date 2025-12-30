# Cuiv-skills for OpenCode

Complete guide for using Cuiv-skills with [OpenCode.ai](https://opencode.ai).

## Quick Install

Tell OpenCode:

```
Clone https://github.com/cuivienor/infra to ~/.config/opencode/infra, then symlink ~/.config/opencode/infra/ai/claude-plugins/cuiv-skills to ~/.config/opencode/cuiv-skills, then create directory ~/.config/opencode/plugin, then symlink ~/.config/opencode/cuiv-skills/.opencode/plugin/cuiv-skills.js to ~/.config/opencode/plugin/cuiv-skills.js, then restart opencode.
```

## Manual Installation

### Prerequisites

- [OpenCode.ai](https://opencode.ai) installed
- Node.js installed
- Git installed

### Installation Steps

#### 1. Clone the Infra Repository

```bash
mkdir -p ~/.config/opencode
git clone https://github.com/cuivienor/infra.git ~/.config/opencode/infra
```

#### 2. Create Symlink to Plugin

```bash
ln -sf ~/.config/opencode/infra/ai/claude-plugins/cuiv-skills ~/.config/opencode/cuiv-skills
```

#### 3. Register the Plugin

OpenCode discovers plugins from `~/.config/opencode/plugin/`. Create a symlink:

```bash
mkdir -p ~/.config/opencode/plugin
ln -sf ~/.config/opencode/cuiv-skills/.opencode/plugin/cuiv-skills.js ~/.config/opencode/plugin/cuiv-skills.js
```

Alternatively, for project-local installation:

```bash
# In your OpenCode project
mkdir -p .opencode/plugin
ln -sf ~/.config/opencode/cuiv-skills/.opencode/plugin/cuiv-skills.js .opencode/plugin/cuiv-skills.js
```

#### 4. Restart OpenCode

Restart OpenCode to load the plugin. Cuiv-skills will automatically activate.

## Usage

### Finding Skills

Use the `find_skills` tool to list all available skills:

```
use find_skills tool
```

### Loading a Skill

Use the `use_skill` tool to load a specific skill:

```
use use_skill tool with skill_name: "cuiv-skills:brainstorming"
```

Skills are automatically inserted into the conversation and persist across context compaction.

### Personal Skills

Create your own skills in `~/.config/opencode/skills/`:

```bash
mkdir -p ~/.config/opencode/skills/my-skill
```

Create `~/.config/opencode/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

### Project Skills

Create project-specific skills in your OpenCode project:

```bash
# In your OpenCode project
mkdir -p .opencode/skills/my-project-skill
```

Create `.opencode/skills/my-project-skill/SKILL.md`:

```markdown
---
name: my-project-skill
description: Use when [condition] - [what it does]
---

# My Project Skill

[Your skill content here]
```

## Skill Priority

Skills are resolved with this priority order:

1. **Project skills** (`.opencode/skills/`) - Highest priority
2. **Personal skills** (`~/.config/opencode/skills/`)
3. **Cuiv-skills** (`~/.config/opencode/cuiv-skills/skills/`)

You can force resolution to a specific level:
- `project:skill-name` - Force project skill
- `skill-name` - Search project → personal → cuiv-skills
- `cuiv-skills:skill-name` - Force cuiv-skills

## Features

### Automatic Context Injection

The plugin automatically injects cuiv-skills context via session hooks. No manual configuration needed.

### Message Insertion Pattern

When you load a skill with `use_skill`, it's inserted as a user message with `noReply: true`. This ensures skills persist throughout long conversations, even when OpenCode compacts context.

### Compaction Resilience

The plugin listens for `session.compacted` events and automatically re-injects the core bootstrap to maintain functionality after context compaction.

### Tool Mapping

Skills written for Claude Code are automatically adapted for OpenCode. The plugin provides mapping instructions:

- `TodoWrite` → `update_plan`
- `Task` with subagents → OpenCode's `@mention` system
- `Skill` tool → `use_skill` custom tool
- File operations → Native OpenCode tools

## Architecture

### Plugin Structure

**Location:** `~/.config/opencode/cuiv-skills/.opencode/plugin/cuiv-skills.js`

**Components:**
- Two custom tools: `use_skill`, `find_skills`
- Session hooks for initial context injection
- Event handler for session.compacted re-injection
- Uses shared `lib/skills-core.js` module (also used by Codex)

### Shared Core Module

**Location:** `~/.config/opencode/cuiv-skills/lib/skills-core.js`

**Functions:**
- `extractFrontmatter()` - Parse skill metadata
- `stripFrontmatter()` - Remove metadata from content
- `findSkillsInDir()` - Recursive skill discovery
- `resolveSkillPath()` - Skill resolution with shadowing
- `checkForUpdates()` - Git update detection

This module is shared between OpenCode and Codex implementations for code reuse.

## Updating

```bash
cd ~/.config/opencode/infra && git pull
```

Restart OpenCode to load the updates.

## Alternative: Direct Path (No Symlink)

If you prefer not to use symlinks, use the full path everywhere:
```
~/.config/opencode/infra/ai/claude-plugins/cuiv-skills/...
```

## Troubleshooting

### Plugin not loading

1. Check plugin file exists: `ls ~/.config/opencode/cuiv-skills/.opencode/plugin/cuiv-skills.js`
2. Check symlink: `ls -l ~/.config/opencode/plugin/cuiv-skills.js`
3. Check OpenCode logs: `opencode run "test" --print-logs --log-level DEBUG`
4. Look for: `service=plugin path=file:///.../cuiv-skills.js loading plugin`

### Skills not found

1. Verify skills directory: `ls ~/.config/opencode/cuiv-skills/skills`
2. Use `find_skills` tool to see what's discovered
3. Check skill structure: each skill needs a `SKILL.md` file

### Tools not working

1. Verify plugin loaded: Check OpenCode logs for plugin loading message
2. Check Node.js version: The plugin requires Node.js for ES modules
3. Test plugin manually: `node --input-type=module -e "import('file://~/.config/opencode/plugin/cuiv-skills.js').then(m => console.log(Object.keys(m)))"`

### Context not injecting

1. Check if session hooks are working
2. Verify using-cuiv-skills skill exists
3. Check OpenCode version (requires recent version with plugin support)

## Getting Help

- Report issues: https://github.com/cuivienor/infra/issues
- Documentation: https://github.com/cuivienor/infra
- OpenCode docs: https://opencode.ai/docs/
