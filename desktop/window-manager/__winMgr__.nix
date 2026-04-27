{ config, lib, pkgs, username, ... }: {
  imports = [
    ./portal.nix
    ./niri/niri.nix
    ./hypr/hypr.nix
    ./labwc/labwc.nix
    ./mangowc/mangowc.nix
  ];

  config = lib.mkIf (lib.length (config.desktop.windowManager or []) > 0) {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      xauth
      polkit_gnome
      seahorse
    ];

    # policy
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.swaylock = {};

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
