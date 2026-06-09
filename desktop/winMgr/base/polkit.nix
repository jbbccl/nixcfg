{ config, lib, pkgs, ... }:
let
    cfg = config.desktop.winMgr.base.polkit;
in
{
    options.desktop.winMgr.base.polkit.enable = lib.mkEnableOption "polkit authentication agent for WM";

    config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            mate-polkit
            seahorse
        ];

        security.polkit.enable = true;

        services.gnome.gnome-keyring.enable = true;

        systemd.user.services.polkit-mate-authentication-agent-1 = {
            description = "polkit-mate-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
            };
        };
    };
}