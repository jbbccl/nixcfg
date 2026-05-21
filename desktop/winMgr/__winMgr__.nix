{ config, lib, pkgs, username, ... }:
{
  imports = [
    ./niri/niri.nix
    ./hypr/hypr.nix
    ./labwc/labwc.nix
    ./mangowc/mangowc.nix
  ];

  options.desktop.winMgr.list = lib.mkOption {
    type = lib.types.nullOr (lib.types.listOf (lib.types.enum [ "niri" "labwc" "hypr" "mangowc" ]));
    default = null;
    description = "window managers";
  };

  config = lib.mkIf (config.desktop.winMgr.list != []) {
	desktop.winMgr.niri.enable    = mkWmEnable "niri";
	desktop.winMgr.labwc.enable   = mkWmEnable "labwc";
	desktop.winMgr.hypr.enable    = mkWmEnable "hypr";
	desktop.winMgr.mangowc.enable = mkWmEnable "mangowc";

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      xauth
      polkit_gnome
      seahorse
    ];

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
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

    xdg = {
      mime.enable = true;
      menus.enable = true;
    };
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      config = {};
    };
  };
}
