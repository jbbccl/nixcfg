{ config, lib, pkgs, username, ... }:
let
  inherit (import ../../../lib/helpers.nix { inherit lib; }) mkConfigDir;
in {
  programs.fish.enable = true;

  programs.fish.shellInit = ''
    function nix-shell --wraps nix-shell
    command nix-shell --command "exec fish" $argv
    end
  '';

  home-manager.users.${username} = {
    programs.fish.enable = true;
    xdg.configFile = mkConfigDir "fish" ./config;
  };
}
