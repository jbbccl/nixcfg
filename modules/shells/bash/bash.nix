{ lib, pkgs, username, ... }:
let
  inherit (import ../../../lib/helpers.nix { inherit lib; }) mkHomeDir;
in {
  programs.bash.enable = true;
  programs.bash.interactiveShellInit = ''
    if [ -f ~/.config/bash/bashrc ]; then
    . ~/.config/bash/bashrc
    fi
  '';

  home-manager.users.${username} = {
    home.file = mkHomeDir ".config/bash" ./config;
  };
}
