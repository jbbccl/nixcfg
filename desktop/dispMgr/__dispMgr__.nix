{ config, lib, pkgs, helpers, ... }:
let
  inherit (helpers) mkNullOrEnum;
in {
  imports = [
    # ./sddm/sddm.nix
    ./greetd/greetd.nix
  ];

  options.desktop.dispMgr.select = mkNullOrEnum "display manager" [ "greetd" "sddm" ];

  # ── UWSM: proper systemd session lifecycle (fixes systemctl --user exit races) ─
  config = lib.mkIf (config.desktop.winMgr.list != []) {
    programs.uwsm = {
      enable = true;
      waylandCompositors = lib.mkMerge [
        (lib.mkIf (builtins.elem "hypr" config.desktop.winMgr.list) {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor managed by UWSM";
            binPath = "${lib.getExe' pkgs.hyprland "start-hyprland"}";
          };
        })
        (lib.mkIf (builtins.elem "niri" config.desktop.winMgr.list) {
          niri = {
            prettyName = "Niri";
            comment = "Niri compositor managed by UWSM";
            binPath = "${lib.getExe pkgs.niri}";
            extraArgs = [ "--session" ];
          };
        })
        (lib.mkIf (builtins.elem "labwc" config.desktop.winMgr.list) {
          labwc = {
            prettyName = "Labwc";
            comment = "Labwc compositor managed by UWSM";
            binPath = "${lib.getExe pkgs.labwc}";
          };
        })
      ];
    };
  };
}
