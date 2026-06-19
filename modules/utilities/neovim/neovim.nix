{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.utilities.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.modules.utilities.neovim.enable {
    environment.systemPackages = with pkgs; [neovim];
    environment.sessionVariables = {
      VISUAL = "nvim";
      EDITOR = "nvim";
    };
  };
}
