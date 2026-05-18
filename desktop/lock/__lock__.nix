{ config, lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir mkNullOrEnum;
in {
  options.desktop.lock.select = mkNullOrEnum "lock screen" [ "swaylock" ];

  config = lib.mkIf (config.desktop.lock.select == "swaylock") {
    environment.systemPackages = with pkgs; [
      swaylock
    ];

    security.pam.services.swaylock = {};

    home-manager.users.${username} = {
      xdg.configFile = mkConfigDir "swaylock" ./swaylock;
    };
  };
}
