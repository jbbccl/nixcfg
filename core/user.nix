{
  config,
  lib,
  username,
  ...
}: {
  # 最低优先级: option default, 无其他定义时才生效
  # 主机覆盖: configuration.nix 里写 core.user.username = "foo";
  options.core.user.username = lib.mkOption {
    type = lib.types.str;
    default = "e";
    description = "系统用户名";
  };

  config = {
    # 桥: 解析后的值注入模块参数, 模块头 { username, ... } 保持零改动
    _module.args.username = config.core.user.username;

    users.users.${username} = {
      uid = 1000;
      isNormalUser = true;
      ignoreShellProgramCheck = true;
      extraGroups = ["wheel" "video" "audio" "render"];
      linger = true;
    };
  };
}
