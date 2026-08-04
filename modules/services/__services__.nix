{
  config,
  lib,
  ...
}: {
  options.modules.services.enable = lib.mkEnableOption "system services";

  imports = [
    ./audio.nix
    ./ssh.nix
    ./xkb.nix
    ./kmscon.nix
  ];
}
