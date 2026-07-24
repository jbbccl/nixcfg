{
  config,
  pkgs,
  lib,
  username,
  ...
}:
lib.mkIf (builtins.elem "python" config.modules.lang.list) {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      python3
      uv
      virtualenv
    ];
    xdg.configFile."uv/uv.toml" = {
      text = ''
        [[index]]
        url = "https://pypi.tuna.tsinghua.edu.cn/simple"
        default = true
      '';
    };
  };
}
