{ config, lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir mkNullOrEnum;
in {
  options.desktop.launcher.select = mkNullOrEnum "app launcher" [ "fuzzel" "rofi" "wofi" ];

  config = lib.mkIf (config.desktop.launcher.select == "fuzzel") {
    environment.systemPackages = with pkgs; [
      fuzzel
    ];

    home-manager.users.${username} = {
      xdg.configFile = mkConfigDir "fuzzel" ./fuzzel;
    };
  };
}
