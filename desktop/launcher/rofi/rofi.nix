{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.launcher.rofi;
in {
  options.desktop.launcher.rofi.enable = lib.mkEnableOption "rofi launcher";

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
