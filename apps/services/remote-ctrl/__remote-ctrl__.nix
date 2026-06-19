{
  config,
  lib,
  ...
}: {
  options.apps.services.remote-ctrl.enable = lib.mkEnableOption "remote control services (vnc, nginx basic auth)";

  imports = [
    ./nginx.nix
    ./vnc.nix
  ];
}
