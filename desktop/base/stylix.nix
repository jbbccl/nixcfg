{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.base.stylix;
  base = config.desktop.base;
in {
  options.desktop.base.stylix = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "Stylix unified theming";
      };
    };
    default = {};
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      fonts = {
        serif = {
          package = pkgs.maple-mono.NF-CN;
          name = "Maple Mono NF CN";
        };
        sansSerif = {
          package = pkgs.maple-mono.NF-CN;
          name = "Maple Mono NF CN";
        };
        monospace = {
          package = pkgs.maple-mono.NF-CN;
          name = "Maple Mono NF CN";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = base.fontSize;
          desktop = base.fontSize;
          terminal = base.fontSize;
        };
      };

      icons = {
        enable = true;
        package = base.iconThemePackage;
        dark = base.iconThemeName;
      };

      cursor = {
        name = base.cursorName;
        package = base.cursorPackage;
        size = base.cursorSize;
      };

      targets = {
        console.enable = false;
        gtk.enable = true;
        qt.enable = true;
        qt.platform = "qtct";
      };
    };
  };
}
