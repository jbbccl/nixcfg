{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.base;
  mkThemeEnable = name: lib.mkDefault (cfg.theme == name);
in {
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./cursor.nix
    ./stylix.nix
  ];

  options.desktop.base = {
    theme = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["stylix" "manual"]);
      default = null;
    };

    # ── font ────────────────────────────────────
    fontName = lib.mkOption {
      type = lib.types.str;
      default = "Maple Mono NF CN";
    };
    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
    };

    # ── icon ────────────────────────────────────
    iconThemeName = lib.mkOption {
      type = lib.types.str;
      default = "Papirus-Dark";
    };
    iconThemePackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.catppuccin-papirus-folders.override {
        flavor = "macchiato";
        accent = "blue";
      };
    };

    # ── cursor ────────────────────────────────────
    cursorName = lib.mkOption {
      type = lib.types.str;
      default = "breeze_cursors";
    };
    cursorPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kdePackages.breeze;
    };
    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
    };
  };

  config = lib.mkIf (cfg.theme != null) {
    programs.dconf.enable = true;
    desktop.base.gtk.enable = mkThemeEnable "manual";
    desktop.base.qt.enable = mkThemeEnable "manual";
    desktop.base.cursor.enable = mkThemeEnable "manual";
    desktop.base.stylix.enable = mkThemeEnable "stylix";
  };
}
