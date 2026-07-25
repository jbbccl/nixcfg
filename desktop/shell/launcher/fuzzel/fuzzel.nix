{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.shell.launcher.fuzzel;
in {
  options.desktop.shell.launcher.fuzzel.enable = lib.mkEnableOption "fuzzel launcher";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [fuzzel];

    home-manager.users.${username} = {
      xdg.configFile."fuzzel/fuzzel.ini" = {
        force = true;
        recursive = true;
        source = ./fuzzel.ini;
      };
    };
  };
}
