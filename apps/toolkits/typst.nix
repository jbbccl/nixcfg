{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.toolkits.typst;
in {
  options.apps.toolkits.typst.enable = lib.mkEnableOption "Typst toolchain (typst + tinymist)";

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        typst
        tinymist
      ];
    };
  };
}
