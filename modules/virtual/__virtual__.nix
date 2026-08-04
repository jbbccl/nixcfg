{
  config,
  lib,
  ...
}: {
  options.modules.virtual.enable = lib.mkEnableOption "virtualization";

  imports = [
    ./nix-ld.nix
    ./kvm.nix
    ./container.nix
    ./appimage.nix
    ./waydroid.nix
  ];
}
