{
  config,
  lib,
  username,
  ...
}: let
  cfg = config.desktop.shell.noctalia;
in {
  options.desktop.shell.noctalia.enable = lib.mkEnableOption "noctalia shell (bar, launcher, wallpaper, lock, notif)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      config.programs.noctalia.package
    ];

    services = {
      upower.enable = true;
      power-profiles-daemon.enable = true;
    };
    home-manager.users.${username} = {
      xdg.configFile."noctalia" = {
        force = true;
        recursive = true;
        source = ./config;
      };
    };
  };
}
