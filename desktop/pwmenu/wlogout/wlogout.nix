{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.pwmenu.wlogout;
in {
  options.desktop.pwmenu.wlogout.enable = lib.mkEnableOption "wlogout session menu";

  config = lib.mkIf cfg.enable {
    desktop.lock.swaylock.enable = lib.mkDefault true;

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
