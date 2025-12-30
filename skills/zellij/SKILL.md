---
name: zellij
description: Use when working with zellij terminal multiplexer - configuration, layouts, keybindings, plugins, sessions, and operational commands
---

# Zellij Expert

## Overview

Comprehensive expertise for zellij terminal multiplexer. Covers configuration (KDL), layouts, keybindings, plugins (zjstatus, etc.), session management, and CLI operations.

**This skill provides generic zellij knowledge.** For project-specific preferences and conventions, check the project's `CLAUDE.md` or zone documentation.

## When to Use

- Creating or modifying zellij configs (KDL or Nix)
- Designing layouts for projects or workflows
- Customizing keybindings
- Setting up plugins (zjstatus, status bar, file picker, etc.)
- Session and workspace management
- Troubleshooting zellij issues
- Learning zellij commands and modes

## Quick Reference

| Need to... | Read This |
|-----------|-----------|
| Understand config structure | `references/official/configuration.md` |
| Config options reference | `references/official/configuration-options.md` |
| Create a layout | `references/official/layouts.md`, `creating-a-layout.md` |
| Layout examples | `references/official/layout-examples.md` |
| Customize keybindings | `references/official/keybindings.md` |
| Available keys | `references/official/keybindings-keys.md` |
| Available actions | `references/official/keybindings-possible-actions.md` |
| Keybinding examples | `references/official/keybindings-examples.md` |
| Configure plugins | `references/official/plugins.md` |
| Plugin development | `references/official/plugin-development.md` |
| CLI commands | `references/official/cli-actions.md` |
| CLI reference | `references/official/cli-commands.md` |
| Session resurrection | `references/official/session-resurrection.md` |
| Themes | `references/official/themes.md` |
| Nix/Home Manager patterns | `references/home-manager-patterns.md` |

## Zellij Concepts

### Modes (Core Paradigm)

Zellij uses a modal interface. Understanding modes is fundamental:

| Mode | Purpose | Enter With |
|------|---------|------------|
| **Normal** | Default mode, most keybindings active | (default) |
| **Locked** | All keys pass through to terminal | `Ctrl+g` |
| **Pane** | Pane operations (split, close, resize) | `Ctrl+p` |
| **Tab** | Tab operations (new, close, rename) | `Ctrl+t` |
| **Scroll** | Scrollback navigation, copy mode | `Ctrl+s` |
| **Resize** | Resize panes with hjkl/arrows | `Ctrl+n` |
| **Move** | Move panes around | `Ctrl+h` |
| **Search** | Search scrollback | `Ctrl+s` then `s` |
| **Session** | Session operations | `Ctrl+o` |

### Default Keybindings

| Action | Keys |
|--------|------|
| Toggle locked mode | `Ctrl+g` |
| Enter pane mode | `Ctrl+p` |
| Enter tab mode | `Ctrl+t` |
| Enter scroll mode | `Ctrl+s` |
| Enter resize mode | `Ctrl+n` |
| Enter session mode | `Ctrl+o` |
| New pane (down) | `Ctrl+p` then `d` |
| New pane (right) | `Ctrl+p` then `r` |
| Close focused pane | `Ctrl+p` then `x` |
| Toggle floating pane | `Ctrl+p` then `w` |
| Toggle fullscreen | `Ctrl+p` then `f` |
| New tab | `Ctrl+t` then `n` |
| Close tab | `Ctrl+t` then `x` |
| Go to tab N | `Ctrl+t` then `1-9` |
| Detach session | `Ctrl+o` then `d` |
| Quit zellij | `Ctrl+q` |

### KDL Configuration Syntax

Zellij uses [KDL](https://kdl.dev) for configuration. Key patterns:

```kdl
// Comments use double slashes

// Simple options
theme "catppuccin-mocha"
default_layout "default"
pane_frames false

// Nested blocks
keybinds {
    normal {
        bind "Ctrl h" { MoveFocus "Left"; }
    }
}

// Plugin configuration in layouts
pane {
    plugin location="file:/path/to/plugin.wasm" {
        option_name "value"
    }
}
```

## Workflows

### Creating a Layout

1. Read `references/official/creating-a-layout.md` for full syntax
2. Start with basic structure:
   ```kdl
   layout {
       tab name="main" {
           pane
       }
   }
   ```
3. Add tabs and panes as needed
4. Use `default_tab_template` for consistent structure across tabs
5. Test with: `zellij --layout ./my-layout.kdl`
6. Set as default: `default_layout "my-layout"` in config.kdl

### Customizing Keybindings

1. Read `references/official/keybindings.md` for structure
2. Check `references/official/keybindings-possible-actions.md` for action names
3. Add to config.kdl:
   ```kdl
   keybinds {
       // Mode-specific bindings
       normal {
           bind "Alt n" { NewPane; }
       }
       // Cross-mode bindings (except locked)
       shared_except "locked" {
           bind "Ctrl h" { MoveFocus "Left"; }
       }
   }
   ```
4. Use `clear-defaults=true` to start fresh, or omit to extend defaults

### Adding Plugins

Common plugins:
- **zjstatus** - Customizable status bar
- **zellij-forgot** - Keybinding helper
- **room** - Session manager

Setup pattern:
1. Obtain plugin WASM file (via Nix, download, or build)
2. Reference in layout:
   ```kdl
   pane size=1 borderless=true {
       plugin location="file:~/.config/zellij/plugins/zjstatus.wasm" {
           format_left "{mode} {tabs}"
           format_right "{session}"
       }
   }
   ```
3. Read plugin's documentation for available options

### Session Management

```bash
# List sessions
zellij list-sessions
zellij ls

# Attach to session
zellij attach <session-name>
zellij a <session-name>

# Create named session
zellij --session <name>

# Create with layout
zellij --session <name> --layout <layout>

# Kill session
zellij kill-session <name>

# Kill all sessions
zellij kill-all-sessions

# Detach (from inside): Ctrl+o then d
```

### Per-Project Layouts

Create `.zellij.kdl` in project root for project-specific layouts. Many session managers (like zesh) detect and use this automatically.

## Updating Documentation

To fetch the latest official zellij docs:

```bash
cd /path/to/cuiv-skills/skills/zellij
./scripts/update-docs.sh
```

This downloads current documentation from the zellij GitHub repository.

## Troubleshooting

### Config Not Loading
- Check location: `~/.config/zellij/config.kdl`
- Verify KDL syntax (missing semicolons, unmatched braces)
- Run `zellij setup --check` to validate

### Layout Not Found
- Use full path: `--layout /absolute/path/to/layout.kdl`
- Or place in `~/.config/zellij/layouts/`

### Plugin Not Loading
- Check WASM file exists at specified path
- Verify permissions on plugin file
- Check zellij logs for errors

### Keybindings Not Working
- Ensure correct mode (some bindings only work in specific modes)
- Check for conflicts with terminal emulator bindings
- Use `Ctrl+g` to toggle locked mode if keys pass through

## Integration with Nix/Home Manager

See `references/home-manager-patterns.md` for patterns on:
- Managing config via `xdg.configFile`
- Using `programs.zellij` module
- Handling plugin WASM files with flake inputs
- Converting between KDL and Nix attribute sets

## Project-Specific Configuration

This skill provides **generic zellij expertise**. For project-specific setup:

1. Check project's `CLAUDE.md` for local conventions
2. Look for design docs in `docs/plans/`
3. Find existing configs in the codebase
4. Personal preferences belong in project documentation, not this skill
