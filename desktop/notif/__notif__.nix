{ config, lib, username, ... }:
{
  options.desktop.notif.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum [ "mako" "swaync" ]);
    default = null;
    description = "notification daemon";
  };

  config = lib.mkIf (config.desktop.notif.select == "mako") {
    home-manager.users.${username} = {
      services.mako.enable = true;
      xdg.configFile."mako/" = {
        force = true;
        recursive = true;
        source = ./mako;
      };
    };
  };
}
