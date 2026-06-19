{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.input.fcitx5;
  rimePath = config.desktop.input.rime.shareDir;
in {
  options.desktop.input.fcitx5.enable = lib.mkEnableOption "fcitx5 input method";

  config = lib.mkIf cfg.enable {
    desktop.input.rime.enable = lib.mkDefault true;

    home-manager.users.${username} = {config, ...}: {
      # ── rime ────────────────────────────────────TODO
      xdg.dataFile."fcitx5/rime" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink rimePath;
      };
      # ── config ──────────────────────────────────
      xdg.configFile."fcitx5/" = {
        force = true;
        recursive = true;
        source = ./config;
      };
      # ── theme ────────────────────────────────────
      xdg.dataFile."fcitx5/themes/plasma" = {
        force = true;
        recursive = true;
        source = ./plasma-theme;
      };
    };

    i18n = {
      inputMethod = {
        type = "fcitx5";
        enable = true;
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-rime
            librime-lua
          ];
        };
      };
    };
  };
}
