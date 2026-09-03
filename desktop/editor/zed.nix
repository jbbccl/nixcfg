{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.editor.zed;
in {
  options.desktop.editor.zed.enable = lib.mkEnableOption "Zed GUI editor";

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.home.packages =with pkgs; [
      # zed-editor
      fresh-editor
      mousepad
    ];
  };
}
