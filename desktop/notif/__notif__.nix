{ config, lib, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir mkNullOrEnum;
in {
  options.desktop.notif.select = mkNullOrEnum "notification daemon" [ "mako" "swaync" ];

  config = lib.mkIf (config.desktop.notif.select == "mako") {
    home-manager.users.${username} = {
      services.mako.enable = true;
      xdg.configFile = mkConfigDir "mako" ./mako;
    };
  };
}
