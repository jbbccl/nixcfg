{ lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir;
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
