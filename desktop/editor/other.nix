{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.editor.other;
in {
  options.desktop.editor.other.enable = lib.mkEnableOption "Zed GUI editor";

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.home.packages = [pkgs.zed-editor];
  };
}
