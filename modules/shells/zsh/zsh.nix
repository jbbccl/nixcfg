{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  options.modules.shells.zsh.enable = lib.mkEnableOption "zsh shell";

  config = lib.mkIf config.modules.shells.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    environment.sessionVariables = {
      ZDOTDIR = "$HOME/.config/zsh";
    };
    home-manager.users.${username} = {
      home.file.".config/zsh" = {
        force = true;
        recursive = true;
        source = ./config;
      };
    };
  };
}
