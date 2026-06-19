{
  config,
  lib,
  ...
}: {
  options.modules.virtual.enable = lib.mkEnableOption "virtualization";

  imports = [
    ./container/default.nix
    ./hardware/default.nix
  ];
}
