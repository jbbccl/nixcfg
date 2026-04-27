{ lib, pkgs, username, ... }:
let
  inherit (import ../../../lib/helpers.nix { inherit lib; }) mkConfigDir;
in {
  environment.systemPackages = with pkgs; [
    (yazi.override {
      _7zz = _7zz-rar;
    })
  ];

  home-manager.users.${username} = {
    xdg.configFile = mkConfigDir "yazi" ./config;
  };
}
