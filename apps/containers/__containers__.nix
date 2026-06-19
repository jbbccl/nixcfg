{
  config,
  lib,
  ...
}: {
  options.apps.containers.enable = lib.mkEnableOption "containers";

  imports = [
    ./debian
    ./kali
  ];
}
