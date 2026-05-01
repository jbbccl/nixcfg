{ config, lib, pkgs, username, ... }: {
  imports = [
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

    # ── UWSM: proper systemd session lifecycle (fixes systemctl --user exit races) ─
    programs.uwsm = {
      enable = true;
      waylandCompositors = lib.mkMerge [
        (lib.mkIf (builtins.elem "hypr" config.desktop.windowManager) {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor managed by UWSM";
            binPath = "${lib.getExe pkgs.hyprland}";
          };
        })
        (lib.mkIf (builtins.elem "niri" config.desktop.windowManager) {
          niri = {
            prettyName = "Niri";
            comment = "Niri compositor managed by UWSM";
            binPath = "${lib.getExe pkgs.niri}";
            extraArgs = [ "--session" ];
          };
        })
      ];
    };

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

	# portal
	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
	};
  };
}
