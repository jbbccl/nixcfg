{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.shell.pwmenu.wlogout;
in {
  options.desktop.shell.pwmenu.wlogout.enable = lib.mkEnableOption "wlogout session menu";

  config = lib.mkIf cfg.enable {
    desktop.shell.lock.swaylock.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      wlogout
    ];

    home-manager.users.${username} = {
      xdg.configFile."wlogout" = {
        force = true;
        recursive = true;
        source = ./config;
      };
    };
  };
}
