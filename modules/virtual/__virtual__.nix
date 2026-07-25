{
  config,
  lib,
  ...
}: {
  options.modules.virtual.enable = lib.mkEnableOption "virtualization";

  imports = [
    ./kvm.nix
    ./container.nix
    ./appimage.nix
    ./waydroid.nix
  ];
}
