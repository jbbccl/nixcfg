{
  config,
  lib,
  ...
}: let
  cfg = config.apps.cli.git;
in {
  options.apps.cli.git.enable = lib.mkEnableOption "git";

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
