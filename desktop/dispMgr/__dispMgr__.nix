{
  config,
  lib,
  pkgs,
  ...
}: let
  mkDmEnable = name: lib.mkDefault (config.desktop.dispMgr.select == name);
in {
  imports = [
    ./sddm/sddm.nix
    ./greetd/greetd.nix
    ./noctalia-greeter/noctalia-greeter.nix
  ];

  options.desktop.dispMgr.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum ["sddm" "greetd" "noctalia-greeter"]);
    default = null;
    description = "display manager";
  };

  config = lib.mkIf (config.desktop.dispMgr.select != null) {
    desktop.dispMgr.sddm.enable = mkDmEnable "sddm";
    desktop.dispMgr.greetd.enable = mkDmEnable "greetd";
    desktop.dispMgr.noctalia-greeter.enable = mkDmEnable "noctalia-greeter";
  };
}
