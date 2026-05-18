{ config, lib, pkgs, username, ... }:
{
  options.desktop.lock.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum [ "swaylock" ]);
    default = null;
    description = "lock screen";
  };

  config = lib.mkIf (config.desktop.lock.select == "swaylock") {
    environment.systemPackages = with pkgs; [
      swaylock
    ];

    security.pam.services.swaylock = {};

    home-manager.users.${username} = {
      xdg.configFile."swaylock/" = {
        force = true;
        recursive = true;
        source = ./swaylock;
      };
    };
  };
}
