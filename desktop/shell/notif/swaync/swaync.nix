{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.shell.notif.swaync;
in {
  options.desktop.shell.notif.swaync.enable = lib.mkEnableOption "swaync notification daemon";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [swaynotificationcenter];

    home-manager.users.${username} = {
      services.swaync.enable = true;
      xdg.configFile."swaync/" = {
        force = true;
        recursive = true;
        source = ./.;
      };
    };
  };
}
