{
  config,
  pkgs,
  lib,
  username,
  ...
}:
lib.mkIf (builtins.elem "java" config.modules.lang.list) {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      jdk
    ];
  };
}
