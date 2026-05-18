{ lib, ... }:
{
  imports = [
    ./waybar/waybar.nix
    ./noctalia/default.nix
  ];

  options.desktop.bar.list = lib.mkOption {
    type = lib.types.nullOr (lib.types.listOf (lib.types.enum [ "waybar" "noctalia" ]));
    default = null;
    description = "status bar";
  };
}
