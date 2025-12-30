#!/usr/bin/env bash
#
# update-docs.sh - Fetch latest zellij documentation from GitHub
#
# Usage: ./update-docs.sh
#
# Downloads official zellij documentation from the zellij-org.github.io
# repository and saves to references/official/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
OFFICIAL_DIR="$SKILL_DIR/references/official"

BASE_URL="https://raw.githubusercontent.com/zellij-org/zellij-org.github.io/main/docs/src"

# Core documentation files to fetch
# Curated list of most useful docs for AI assistance
DOCS=(
    # Configuration
    "configuration.md"
    "configuration-options.md"
    "options.md"

    # Keybindings
    "keybindings.md"
    "keybindings-keys.md"
    "keybindings-modes.md"
    "keybindings-binding.md"
    "keybindings-possible-actions.md"
    "keybindings-examples.md"
    "keybindings-overriding.md"
    "keybindings-shared.md"
    "keybinding-presets.md"
    "changing-modifiers.md"
    "rebinding-keys.md"

    # Layouts
    "layouts.md"
    "creating-a-layout.md"
    "layout-examples.md"
    "layouts-templates.md"
    "layouts-with-config.md"
    "swap-layouts.md"

    # Plugins
    "plugins.md"
    "plugin-overview.md"
    "plugin-loading.md"
    "plugin-api.md"
    "plugin-api-commands.md"
    "plugin-api-events.md"
    "plugin-api-permissions.md"
    "plugin-development.md"
    "plugin-examples.md"
    "plugin-lifecycle.md"
    "plugin-pipes.md"
    "plugin-rust.md"
    "plugin-ui-rendering.md"

    # Built-in plugin aliases
    "status-bar-alias.md"
    "tab-bar-alias.md"
    "compact-bar-alias.md"
    "strider-alias.md"
    "filepicker-alias.md"
    "session-manager-alias.md"
    "welcome-screen-alias.md"

    # CLI
    "cli-commands.md"
    "cli-actions.md"
    "cli-plugins.md"
    "command-line-options.md"
    "controlling-zellij-through-cli.md"
    "zellij-run.md"
    "zellij-edit.md"
    "zellij-pipe.md"
    "zellij-plugin.md"

    # Themes
    "themes.md"
    "theme-gallery.md"

    # Sessions
    "session-resurrection.md"

    # Other
    "installation.md"
    "integration.md"
    "compatibility.md"
    "faq.md"
)

echo "Zellij Documentation Updater"
echo "============================"
echo ""

# Ensure output directory exists
mkdir -p "$OFFICIAL_DIR"

# Track results
success=0
failed=0
failed_files=()

echo "Downloading ${#DOCS[@]} documentation files..."
echo ""

for doc in "${DOCS[@]}"; do
    url="$BASE_URL/$doc"
    output="$OFFICIAL_DIR/$doc"

    if curl -sfL "$url" -o "$output" 2>/dev/null; then
        echo "  [OK] $doc"
        success=$((success + 1))
    else
        echo "  [FAIL] $doc"
        failed=$((failed + 1))
        failed_files+=("$doc")
        # Remove empty/partial file if created
        rm -f "$output"
    fi

    # Small delay to be nice to GitHub
    sleep 0.1
done

echo ""
echo "============================"
echo "Download complete!"
echo "  Success: $success"
echo "  Failed:  $failed"

if [[ $failed -gt 0 ]]; then
    echo ""
    echo "Failed files (may not exist upstream):"
    for f in "${failed_files[@]}"; do
        echo "  - $f"
    done
fi

echo ""
echo "Documentation saved to: $OFFICIAL_DIR"
