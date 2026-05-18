{ lib, helpers, ... }:
let
  inherit (helpers) mkNullOrListEnum;
in {
  imports = [
    ./waybar/waybar.nix
    ./noctalia/default.nix
  ];

  options.desktop.bar.list = mkNullOrListEnum "status bar" [ "waybar" "noctalia" ];
}
