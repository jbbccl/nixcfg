{
  config,
  lib,
  username,
  ...
}: {

  options.core.user.username = lib.mkOption {
    type = lib.types.str;
    default = "e";
    description = "系统用户名";
  };

  config = {
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
