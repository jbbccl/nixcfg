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
          name = "lccbbj";
          email = "lccbbj@example.com";
        };
        init.defaultBranch = "main";
      };
    };
  };
}
