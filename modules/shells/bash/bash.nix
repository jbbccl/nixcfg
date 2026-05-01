{ lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkHomeDir;
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
