# Nix Config Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize flake structure with clear module boundaries, NixOS module options for desktop components, and consistent naming.

**Architecture:** flat structure with `core/` (base system), `modules/` (dev/services/shells/etc), `desktop/` (DE components), `apps/` (packages). A `modules/options/desktop.nix` defines `<desktop.*>` options. Each submodule uses `mkIf` to self-activate based on host-level option values.

**Tech Stack:** NixOS, flake, home-manager, sops-nix

---

### Task 1: Create options module

**Files:**
- Create: `modules/options/__options__.nix` — index for options directory
- Create: `modules/options/desktop.nix` — defines `desktop.*` options

- [ ] **Create `modules/options/__options__.nix`**

```nix
{ ... }: {
  imports = [
    ./desktop.nix
  ];
}
```

- [ ] **Create `modules/options/desktop.nix`**

```nix
{ lib, ... }: {
  options.desktop = {
    windowManager = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "niri" "labwc" "hypr" "mangowc" null ]);
      default = null;
    };
    displayManager = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "greetd" "sddm" null ]);
      default = null;
    };
    bar = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "waybar" "noctalia" null ]);
      default = null;
    };
    launcher = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "rofi" "wofi" "fuzzel" null ]);
      default = null;
    };
    lockscreen = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "swaylock" null ]);
      default = null;
    };
    notification = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "mako" "swaync" null ]);
      default = null;
    };
  };
}
```

---

### Task 2: Add mkIf guards to all switchable submodules (in-place)

**Files (modify all in their current locations):**
- Modify: `desktopEnv/winMgr/niri/niri.nix` — wrap in `mkIf`
- Modify: `desktopEnv/winMgr/labwc/labwc.nix` — wrap in `mkIf`
- Modify: `desktopEnv/winMgr/hypr/hypr.nix` — wrap in `mkIf`
- Modify: `desktopEnv/winMgr/mangowc/mangowc.nix` — wrap in `mkIf`
- Modify: `desktopEnv/displayMgr/greetd/greetd.nix` — wrap in `mkIf`
- Modify: `desktopEnv/displayMgr/sddm/sddm.nix` — wrap in `mkIf`
- Modify: `desktopEnv/wmAddons/statusBar/waybar/waybar.nix` — wrap in `mkIf`
- Modify: `desktopEnv/wmAddons/statusBar/noctalia/default.nix` — wrap in `mkIf`
- Modify: `desktopEnv/wmAddons/statusBar/barAddons/launcher/default.nix` — wrap in `mkIf`
- Modify: `desktopEnv/wmAddons/statusBar/barAddons/lock/default.nix` — wrap in `mkIf`
- Modify: `desktopEnv/wmAddons/statusBar/barAddons/notice/default.nix` — wrap in `mkIf`

For each WM file, add at the top of the attribute set:
```nix
{ config, lib, pkgs, username, ... }: {
  config = lib.mkIf (config.desktop.windowManager == "niri") {
    # ... existing config ...
  };
}
```

For display-manager:
```nix
# greetd — mkIf (config.desktop.displayManager == "greetd")
# sddm — mkIf (config.desktop.displayManager == "sddm")
```

For status-bar/waybar:
```nix
config = lib.mkIf (config.desktop.bar == "waybar") {
  # ... existing config (keep the let-binding) ...
};
```

For status-bar/noctalia:
```nix
config = lib.mkIf (config.desktop.bar == "noctalia") {
  # ... existing config ...
};
```

For launcher:
```nix
config = lib.mkIf (config.desktop.launcher == "fuzzel") {
  # ... existing config ...
};
```

For lock:
```nix
config = lib.mkIf (config.desktop.lockscreen == "swaylock") {
  # ... existing config ...
};
```

For notification/mako:
```nix
config = lib.mkIf (config.desktop.notification == "mako") {
  # ... existing config ...
};
```

For notification/swaync — note: swaync is currently imported separately in the bar index. Leave its import path for now and add mkIf similarly.

---

### Task 3: Create new directory structure

- [ ] **Create new directories**

```bash
mkdir -p core
mkdir -p desktop/display-manager/greetd
mkdir -p desktop/display-manager/sddm
mkdir -p desktop/window-manager/niri/config
mkdir -p desktop/window-manager/labwc/config/autostart
mkdir -p desktop/window-manager/labwc/config/environment
mkdir -p desktop/window-manager/labwc/themes
mkdir -p desktop/window-manager/hypr
mkdir -p desktop/window-manager/mangowc/config/scripts
mkdir -p desktop/status-bar/waybar/config/scripts
mkdir -p desktop/status-bar/waybar/config/simple
mkdir -p desktop/status-bar/noctalia
mkdir -p desktop/launcher/fuzzel
mkdir -p desktop/launcher/rofi
mkdir -p desktop/launcher/wofi
mkdir -p desktop/lock/swaylock
mkdir -p desktop/lock/wlogout/icons
mkdir -p desktop/lock/wlogout/layout
mkdir -p desktop/notification/mako
mkdir -p desktop/notification/swaync/sound
mkdir -p desktop/input/config/conf
mkdir -p desktop/input/share/rime
mkdir -p desktop/input/share/themes
mkdir -p desktop/wallpaper
mkdir -p desktop/session/plasma
mkdir -p desktop/session/xfce
mkdir -p apps/terminal/config
mkdir -p apps/file-manager
```

---

### Task 4: Move files from setting/ → core/

- [ ] **Move setting/ to core/**

```bash
mv setting/__setting__.nix core/__core__.nix
mv setting/audio.nix core/
mv setting/font-i8n.nix core/
mv setting/network-time.nix core/
mv setting/nix-ld.nix core/
mv setting/tty-xkb.nix core/
mv setting/user.nix core/
# setting/ directory will be removed after
```

---

### Task 5: Move files from desktopEnv/wmAddons/pty/ → apps/terminal/

- [ ] **Move pty files to apps/terminal/**

```bash
cp desktopEnv/wmAddons/pty/default.nix apps/terminal/__terminal__.nix
cp desktopEnv/wmAddons/pty/alacritty.nix apps/terminal/
cp desktopEnv/wmAddons/pty/kitty.nix apps/terminal/
cp desktopEnv/wmAddons/pty/config apps/terminal/config -r
```

---

### Task 6: Move files from desktopEnv/wmAddons/fileMgr/ → apps/file-manager/

- [ ] **Move fileMgr files to apps/file-manager/**

```bash
cp desktopEnv/wmAddons/fileMgr/default.nix apps/file-manager/__fileMgr__.nix
cp desktopEnv/wmAddons/fileMgr/dolphin.nix apps/file-manager/
cp desktopEnv/wmAddons/fileMgr/thunar.nix apps/file-manager/
```

---

### Task 7: Move files from desktopEnv/wmAddons/inputMth/ → desktop/input/

- [ ] **Move inputMth files to desktop/input/**

```bash
cp desktopEnv/wmAddons/inputMth/default.nix desktop/input/__input__.nix
cp desktopEnv/wmAddons/inputMth/config desktop/input/ -r
cp desktopEnv/wmAddons/inputMth/share desktop/input/ -r
```

---

### Task 8: Move files from desktopEnv/wmAddons/statusBar/ → desktop/status-bar/

- [ ] **Move statusBar files**

```bash
cp desktopEnv/wmAddons/statusBar/__bar__.nix desktop/status-bar/__bar__.nix
cp desktopEnv/wmAddons/statusBar/waybar desktop/status-bar/ -r
cp desktopEnv/wmAddons/statusBar/noctalia desktop/status-bar/ -r
```

---

### Task 9: Move files from barAddons/ → desktop/launcher/, desktop/lock/, desktop/notification/

- [ ] **Move launcher files**

```bash
cp desktopEnv/wmAddons/statusBar/barAddons/launcher/default.nix desktop/launcher/__launcher__.nix
cp desktopEnv/wmAddons/statusBar/barAddons/launcher/fuzzel desktop/launcher/ -r
cp desktopEnv/wmAddons/statusBar/barAddons/launcher/rofi desktop/launcher/ -r
cp desktopEnv/wmAddons/statusBar/barAddons/launcher/wofi desktop/launcher/ -r
```

- [ ] **Move lock files**

```bash
cp desktopEnv/wmAddons/statusBar/barAddons/lock/default.nix desktop/lock/__lock__.nix
cp desktopEnv/wmAddons/statusBar/barAddons/lock/swaylock desktop/lock/ -r
cp desktopEnv/wmAddons/statusBar/barAddons/lock/wlogout desktop/lock/ -r
```

- [ ] **Move notification files**

```bash
cp desktopEnv/wmAddons/statusBar/barAddons/notice/default.nix desktop/notification/__notification__.nix
cp desktopEnv/wmAddons/statusBar/barAddons/notice/mako desktop/notification/ -r
cp desktopEnv/wmAddons/statusBar/barAddons/notice/swaync desktop/notification/ -r
```

---

### Task 10: Move files from desktopEnv/wmAddons/wallpaper/ → desktop/wallpaper/

- [ ] **Move wallpaper files**

```bash
cp desktopEnv/wmAddons/wallpaper/default.nix desktop/wallpaper/__wallpaper__.nix
```

---

### Task 11: Move files from desktopEnv/ → desktop/

- [ ] **Move remaining desktopEnv files**

```bash
cp desktopEnv/__desktopEnv__.nix desktop/__desktop__.nix
cp desktopEnv/theme.nix desktop/
cp desktopEnv/displayMgr desktop/ -r
cp desktopEnv/winMgr desktop/window-manager/ -r
cp desktopEnv/deSession desktop/session/ -r
cp desktopEnv/deSession desktop/session/ -r
```

Actually — displayMgr and winMgr need special handling since their index files reference subpaths. Let me keep it simpler by moving the whole directories and then adjusting index files.

Wait, the structure in the plan has `desktop/display-manager/` but the source is `desktopEnv/displayMgr/`. Since I'm moving, I should either:
a) Move as-is and rename index files, OR
b) Use the new name directly

Let me use option (b) — create the new structure with new names.

Actually, let me think about this more carefully. Copying files is safer than moving (we keep the originals as backup until everything is verified). Then after verification, we delete the old directories.

---

### Task 12: Create new index files

- [ ] **Create `apps/__apps__.nix`**

```nix
{
  imports = [
    ./gui.nix
    ./broser.nix
    ./wireshark.nix
    ./VMManagers.nix
    ./toolkit.nix
    ./terminal/__terminal__.nix
    ./file-manager/__fileMgr__.nix
  ];
}
```

- [ ] **Create `core/__core__.nix`** (renamed from `setting/__setting__.nix`)

Same content, just at new path:
```nix
{
imports = [
    ./audio.nix
    ./font-i8n.nix
    ./network-time.nix
    ./nix-ld.nix
    ./tty-xkb.nix
    ./user.nix
];
}
```

- [ ] **Create `desktop/__desktop__.nix`**

```nix
{
  imports = [
    ./theme.nix
    ./portal.nix
    ./display-manager/__displayMgr__.nix
    ./window-manager/__winMgr__.nix
    ./status-bar/__bar__.nix
    ./launcher/__launcher__.nix
    ./lock/__lock__.nix
    ./notification/__notification__.nix
    ./input/__input__.nix
    ./wallpaper/__wallpaper__.nix
    # ./session/__session__.nix  # plasma/xfce full DE, conflicts with WM
  ];
}
```

- [ ] **Create `desktop/portal.nix`** — copy from `desktopEnv/winMgr/protal.nix` (no content change)

- [ ] **Create `desktop/display-manager/__displayMgr__.nix`** — copy from `desktopEnv/displayMgr/__displayMgr__.nix`

- [ ] **Create `desktop/window-manager/__winMgr__.nix`** — copy from `desktopEnv/winMgr/__winMgr__.nix`, remove portal config (moved to `desktop/portal.nix`)

In the new `__winMgr__.nix`, remove the portal block (now in `desktop/portal.nix`) — keep only the imports and common WM packages:

```nix
{ config, lib, pkgs, ... }: {
  imports = [
    ./niri/niri.nix
    ./hypr/hypr.nix
    ./labwc/labwc.nix
    # ./mangowc/mangowc.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    xauth
    polkit_gnome
    seahorse
  ];

  # portal base
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  # policy
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = {};

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
```

---

### Task 13: Update host import chain

- [ ] **Update `host/common.nix`** — replace old paths with new ones, add `modules/options/`

```nix
{
  imports = [
    ../core/__core__.nix
    ../modules/options/__options__.nix
    ../modules/__modules__.nix
    ../desktop/__desktop__.nix
    ../apps/__apps__.nix
    ../secrets/__sops__.nix
  ];
}
```

- [ ] **Update `host/lap/configuration.nix`** — add desktop.* options

```nix
{ config, lib, pkgs, username, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./driver.nix
    ./boot.nix
    ../common.nix
  ];

  system.stateVersion = "25.11";
  home-manager.users.${username}.home.stateVersion = "25.11";

  # Desktop component selection
  desktop.windowManager = "niri";
  desktop.bar = "waybar";
  desktop.launcher = "fuzzel";
  desktop.lockscreen = "swaylock";
  desktop.notification = "mako";
  desktop.displayManager = "greetd";
}
```

- [ ] **Update `host/pc/configuration.nix`** — add desktop.* options (same values if same setup, or different if desired)

```nix
{ config, lib, pkgs, username, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./driver.nix
    ./boot.nix
    ../common.nix
  ];

  system.stateVersion = "25.11";
  home-manager.users.${username}.home.stateVersion = "25.11";

  # Desktop component selection
  desktop.windowManager = "labwc";
  desktop.bar = "waybar";
  desktop.launcher = "fuzzel";
  desktop.lockscreen = "swaylock";
  desktop.notification = "mako";
  desktop.displayManager = "greetd";
}
```

---

### Task 14: Clean up old directories

- [ ] **Remove old directories after verifying they've been fully copied**

```bash
rm -rf desktopEnv
rm -rf guiToolkit
rm -rf setting
rm -rf modules/services/remote
rm -rf modules/services/system
```

---

### Task 15: Verify with nix flake check

- [ ] **Run `nix flake check` to validate the new structure**

```bash
cd /home/e/nixcfg && nix flake check
```

Expected: No errors.

If errors: check import paths, index file names, and mkIf syntax.

---

### Task 16: Git commit

- [ ] **Stage and commit the restructuring**

```bash
git add -A
git commit -m "refactor: restructure flake with NixOS module options and clear module boundaries

- setting/ → core/ (clearer naming)
- desktopEnv/ → desktop/ (shorter, NixOS options for component selection)
- guiToolkit/ → apps/ (accurate naming, includes terminal/file-manager)
- wmAddons/ dissolved: pty→apps/terminal, fileMgr→apps/file-manager,
  inputMth→desktop/input, barAddons→desktop/{launcher,lock,notification}
- modules/options/desktop.nix: desktop.* options for per-host selection
- All switchable modules use mkIf for self-activation
- Removed empty modules/services/{remote,system} dirs

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
"
```
