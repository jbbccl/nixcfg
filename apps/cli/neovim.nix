{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.cli.neovim;
in {
  options.apps.cli.neovim.enable = lib.mkEnableOption "Neovim CLI editor";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.neovim ];
    environment.sessionVariables = {
      VISUAL = "nvim";
      EDITOR = "nvim";
    };
  };
}
