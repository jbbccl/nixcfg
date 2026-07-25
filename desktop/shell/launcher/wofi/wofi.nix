{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.shell.launcher.wofi;
in {
  options.desktop.shell.launcher.wofi.enable = lib.mkEnableOption "wofi launcher";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [wofi];

    home-manager.users.${username} = {
      xdg.configFile."wofi/" = {
        force = true;
        recursive = true;
        source = ./.;
      };
    };
  };
}
