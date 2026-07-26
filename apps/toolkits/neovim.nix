{
  config,
  lib,
  pkgs,
  ...
}: {
  options.apps.toolkits.neovim.enable = lib.mkEnableOption "neovim CLI editor";

  config = lib.mkIf config.apps.toolkits.neovim.enable {
    environment.systemPackages = [ pkgs.neovim ];
    environment.sessionVariables = {
      VISUAL = "nvim";
      EDITOR = "nvim";
    };
  };
}
