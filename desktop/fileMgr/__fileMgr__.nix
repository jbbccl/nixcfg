{ config, pkgs, lib, ... }:
{
  imports = [
    ./dolphin.nix
    ./thunar.nix
  ];

  options.desktop.fileMgr.list = lib.mkOption {
    type = lib.types.nullOr (lib.types.listOf (lib.types.enum [ "dolphin" "thunar" ]));
    default = null;
    description = "file managers";
  };
}
