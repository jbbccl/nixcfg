{
  config,
  pkgs,
  lib,
  username,
  ...
}:
lib.mkIf (builtins.elem "go" config.modules.dev.lang) {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      go
      gopls
      golangci-lint
      gofumpt
    ];
    home.sessionVariables = {
      GOPROXY = "https://goproxy.cn,direct";
    };
    home.sessionPath = ["/home/${username}/go/bin"];
  };
}
