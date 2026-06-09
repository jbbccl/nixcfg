{ config, lib, pkgs, ... }:
let
    cfg = config.desktop.winMgr.base;
in
{
    imports = [
        ./polkit.nix
        ./xdg.nix
    ];

    options.desktop.winMgr.base.enable = lib.mkEnableOption "base";

    config = lib.mkIf cfg.enable {
        desktop.winMgr.base.polkit.enable = lib.mkDefault true;
        desktop.winMgr.base.xdg.enable = lib.mkDefault true;

        environment.systemPackages = with pkgs; [
            xauth
            wl-clipboard
        ];

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        systemd.user.targets.graphical-session.unitConfig.StopTimeoutSec = 3;
    };
}