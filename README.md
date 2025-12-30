# cuiv-skills

Personal skills library for Claude Code. Complementary to [superpowers](https://github.com/obra/superpowers) - add your own domain-specific skills.

## Installation

### Claude Code (Recommended)

```bash
/plugin marketplace add cuivienor/cuiv-skills
/plugin install cuiv-skills@cuiv-skills-marketplace
```

### Codex

See [.codex/INSTALL.md](.codex/INSTALL.md)

### OpenCode

See [.opencode/INSTALL.md](.opencode/INSTALL.md)

## Creating Skills

1. Create directory in `skills/<skill-name>/`
2. Add `SKILL.md` with YAML frontmatter:

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

Instructions for when and how to use this skill.
```

3. Commit and push

## Skill Format

- **name**: Display name for the skill
- **description**: Helps Claude decide when to use the skill (include "Use when..." pattern)
- **body**: Markdown instructions that Claude follows when the skill is invoked

## Structure

```
cuiv-skills/
  .claude-plugin/
    plugin.json           # Plugin manifest
    marketplace.json      # Marketplace config
  skills/
    using-cuiv-skills/    # Meta skill (auto-loaded)
    example/              # Demo skill (delete after adding real skills)
  hooks/
    hooks.json            # Session hooks config
    session-start.sh      # Injects skill context
  lib/                    # Shared utilities
  .codex/                 # Codex integration
  .opencode/              # OpenCode integration
```

## License

MIT
