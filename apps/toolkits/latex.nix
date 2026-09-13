{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.toolkits.latex;
in {
  options.apps.toolkits.latex.enable = lib.mkEnableOption "LaTeX toolchain (tectonic)";

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        tectonic
      ];
    };
  };
}
