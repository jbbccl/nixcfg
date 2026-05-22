{ config, lib, pkgs, ... }:
{
  imports = [
    # ./sddm/sddm.nix
    ./greetd/greetd.nix
  ];

  options.desktop.dispMgr.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum [ "greetd" "sddm" ]);
    default = null;
    description = "display manager";
  };
}
