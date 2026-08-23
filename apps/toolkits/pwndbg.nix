{
  config,
  lib,
  pkgs,
  username,
  inputs,
  ...
}: let
  cfg = config.apps.toolkits.pwndbg;
  pkg = inputs.pwndbg.packages.${pkgs.stdenv.hostPlatform.system}.pwndbg;
in {
  options.apps.toolkits.pwndbg.enable = lib.mkEnableOption "pwndbg";

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = [pkg];

      home.file.".gdbinit".text = ''
        source ${pkg.meta.pwndbgVenv}/share/pwndbg/gdbinit.py
      '';
    };
  };
}
