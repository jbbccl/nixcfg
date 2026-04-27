{ config, lib, pkgs, username, ... }:
let
  inherit (import ../../../lib/helpers.nix { inherit lib; }) mkHomeDir;
in {
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
    home.file = mkHomeDir ".config/zsh" ./config;
  };
}
