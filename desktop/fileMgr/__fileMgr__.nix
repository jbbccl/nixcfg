{ config, pkgs, lib, helpers, ... }:
let
  inherit (helpers) mkNullOrListEnum;
in {
  imports = [
    ./dolphin.nix
    ./thunar.nix
  ];

  options.desktop.fileMgr.list = mkNullOrListEnum "file managers" [ "dolphin" "thunar" ];

  # config = lib.mkIf (lib.length (config.desktop.fileMgr.list or []) > 0) {
  #   environment.systemPackages = with pkgs; [
  #     ntfs3g
  #   ];
  # };
}
