{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  options.apps.toolkits.enable = lib.mkEnableOption "toolkits";

  imports = [
    ./misc.nix
    ./vm-managers.nix
    ./wireshark.nix
    ./mcu.nix
    ./rs.nix
    ./fpga.nix
  ];

  config = lib.mkIf config.apps.toolkits.enable {
    apps.toolkits = lib.mkDefault {
      misc.enable = true;
      wireshark.enable = true;
      vm-managers.enable = true;
    };
  };
}
