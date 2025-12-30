# Zellij with Nix / Home Manager

Patterns for managing zellij configuration declaratively with Nix and Home Manager.

## Approaches

There are two main approaches to managing zellij config with Home Manager:

### 1. Using `programs.zellij` Module

Home Manager has a built-in zellij module:

```nix
{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    # Settings are converted to KDL
    settings = {
      theme = "catppuccin-mocha";
      default_layout = "default";
      pane_frames = false;
      mouse_mode = true;
      scroll_buffer_size = 50000;
      copy_on_select = true;
    };
  };
}
```

**Pros:**
- Native Nix syntax
- Type checking
- Easy to integrate with other Home Manager options

**Cons:**
- Not all KDL features map cleanly to Nix attrsets
- Complex keybindings/layouts can be awkward
- May lag behind upstream zellij features

### 2. Using `xdg.configFile` with KDL Files

Manage KDL files directly:

```nix
{ config, pkgs, ... }:

{
  home.packages = [ pkgs.zellij ];

  # Copy KDL files to ~/.config/zellij/
  xdg.configFile = {
    "zellij/config.kdl".source = ./zellij/config.kdl;
    "zellij/layouts/default.kdl".source = ./zellij/layouts/default.kdl;
  };
}
```

**Pros:**
- Full KDL syntax support
- Native syntax highlighting in editors
- Copy examples directly from zellij docs
- Easier to iterate on complex layouts

**Cons:**
- Less "Nix-native"
- No type checking from Nix

### 3. Hybrid Approach

Use `programs.zellij` for simple settings, `xdg.configFile` for complex layouts:

```nix
{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      default_layout = "default";
    };
  };

  # Complex layouts as separate KDL files
  xdg.configFile."zellij/layouts/default.kdl".source = ./zellij/layouts/default.kdl;
}
```

## Managing Plugins with Flake Inputs

For plugins distributed as WASM files (like zjstatus), use flake inputs:

### flake.nix

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    # Plugin inputs
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zjstatus, ... }:
  {
    # Pass inputs to home-manager
    homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
      # ...
      extraSpecialArgs = { inherit zjstatus; };
    };

    # Or for NixOS with home-manager module
    nixosConfigurations.host = nixpkgs.lib.nixosSystem {
      # ...
      modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit zjstatus; };
        }
      ];
    };
  };
}
```

### Home Manager Config

```nix
{ config, pkgs, zjstatus, ... }:

let
  zjstatusPlugin = zjstatus.packages.${pkgs.system}.default;
in
{
  home.packages = [ pkgs.zellij ];

  xdg.configFile = {
    "zellij/config.kdl".source = ./zellij/config.kdl;
    "zellij/layouts/default.kdl".source = ./zellij/layouts/default.kdl;

    # Plugin WASM from flake input
    "zellij/plugins/zjstatus.wasm".source = "${zjstatusPlugin}/bin/zjstatus.wasm";
  };
}
```

## Layout Referencing Plugins

In your KDL layout, reference the plugin:

```kdl
layout {
    default_tab_template {
        // zjstatus at top
        pane size=1 borderless=true {
            plugin location="file:~/.config/zellij/plugins/zjstatus.wasm" {
                format_left "{mode} {tabs}"
                format_right "{session}"
                // ... more options
            }
        }
        children
    }

    tab name="main" {
        pane
    }
}
```

## Converting Nix to KDL

When moving from `programs.zellij.settings` to KDL files:

| Nix | KDL |
|-----|-----|
| `theme = "name";` | `theme "name"` |
| `default_layout = "name";` | `default_layout "name"` |
| `pane_frames = false;` | `pane_frames false` |
| `scroll_buffer_size = 50000;` | `scroll_buffer_size 50000` |
| `copy_command = "xclip";` | `copy_command "xclip"` |

For keybindings (complex nested structure):

```nix
# Nix (programs.zellij.settings)
keybinds = {
  normal = {
    "bind \"Alt n\"" = { NewPane = {}; };
  };
};
```

```kdl
// KDL (much cleaner)
keybinds {
    normal {
        bind "Alt n" { NewPane; }
    }
}
```

## Directory Structure

Recommended structure in your Nix config repo:

```
home/users/yourname/
├── default.nix           # Main home-manager config
├── tools.nix             # Tool configs including zellij
└── zellij/
    ├── config.kdl        # Main zellij config
    └── layouts/
        └── default.kdl   # Default layout
```

## Tips

1. **Use KDL for layouts** - The nested structure maps poorly to Nix
2. **Use flake inputs for plugins** - Reproducible, version-locked
3. **Keep config.kdl minimal** - Put complex layouts in separate files
4. **Test locally first** - `zellij --config ./test.kdl --layout ./test-layout.kdl`
5. **Check zellij version** - Some options are version-specific
