{ pkgs, username, ... }: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      go
      gopls
      golangci-lint
      fyne # 依赖 lang-common.nix 内的和图形相关的依赖和环境变量
      gofumpt
    ];
    home.sessionVariables = {
      GOPROXY = "https://goproxy.cn,direct";
    };
    home.sessionPath = [ "/home/${username}/go/bin" ]; # 其实最好一个单独的nix文件统一管理 Path
  };
}
