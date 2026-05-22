{ config, lib, pkgs, ... }: 
let
cfg = config.desktop.dispMgr.sddm;
in
{
    options.desktop.dispMgr.sddm.enable = lib.mkEnableOption "sddm";

    config = lib.mkIf cfg.enable{
        services.displayManager.sddm = {
            enable = true;
            wayland.enable = true;
            theme = "catppuccin-macchiato-mauve";
        };

        environment.systemPackages = [
            (pkgs.catppuccin-sddm.override {
                flavor = "macchiato";
                font  = "Maple Mono NF CN";
                fontSize = "12";
                loginBackground = false;
            })
        ];
    };
}
