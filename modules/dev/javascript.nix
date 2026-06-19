{
  config,
  pkgs,
  lib,
  username,
  ...
}:
lib.mkIf (builtins.elem "javascript" config.modules.dev.lang) {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      nodejs
      pnpm
      bun
    ];

    home.sessionVariables = {
      PNPM_HOME = "/home/${username}/.local/share/pnpm";
    };
    home.sessionPath = ["/home/${username}/.local/share/pnpm"];
  };
}
