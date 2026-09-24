{
  config,
  lib,
  ...
}: let
  cfg = config.apps.toolkits.git;
in {
  options.apps.toolkits.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      config = {
        user = {
          name = "jbbccl";
          email = "184189677+jbbccl@users.noreply.github.com";
        };
        init.defaultBranch = "main";
      };
    };
  };
}
