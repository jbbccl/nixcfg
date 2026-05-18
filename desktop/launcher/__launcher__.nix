{ config, lib, pkgs, username, ... }:
{
  options.desktop.launcher.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum [ "fuzzel" "rofi" "wofi" ]);
    default = null;
    description = "app launcher";
  };

  config = lib.mkIf (config.desktop.launcher.select == "fuzzel") {
    environment.systemPackages = with pkgs; [
      fuzzel
    ];

    home-manager.users.${username} = {
      xdg.configFile."fuzzel/" = {
        force = true;
        recursive = true;
        source = ./fuzzel;
      };
    };
  };
}
