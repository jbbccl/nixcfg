{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.shell.launcher.rofi;
in {
  options.desktop.shell.launcher.rofi.enable = lib.mkEnableOption "rofi launcher";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [rofi];

    home-manager.users.${username} = {
      xdg.configFile."rofi/" = {
        force = true;
        recursive = true;
        source = ./.;
      };
    };
  };
}
