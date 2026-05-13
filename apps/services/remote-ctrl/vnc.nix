{ pkgs, username, lib, config, ... }:
lib.mkIf config.apps.services.remote-ctrl.enable {
  environment.systemPackages = with pkgs; [
    wayvnc
    novnc
    wlr-randr
    #sunshine
  ];
  home-manager.users.${username} = {
    xdg.configFile = {
      "wayvnc/config" = {
        source = ./wayvnc;
      };
    };
  };
}
