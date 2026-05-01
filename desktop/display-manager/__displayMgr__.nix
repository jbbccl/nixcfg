{ config, lib, pkgs, ... }: {
  imports = [
	# ./sddm/sddm.nix
	./greetd/greetd.nix
  ];

  # ── UWSM: proper systemd session lifecycle (fixes systemctl --user exit races) ─
  config = lib.mkIf (lib.length (config.desktop.windowManager or []) > 0) {
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
        (lib.mkIf (builtins.elem "labwc" config.desktop.windowManager) {
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
