{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.kmscon;
in {
  options.modules.services.kmscon.enable = lib.mkEnableOption "kmscon";

  config = lib.mkIf cfg.enable {
    fonts.packages = [pkgs.maple-mono.NF-CN];

    services.kmscon = {
      enable = true;
      config = {
        font-name = "Maple Mono NF CN";
        font-size = 22;
        hwaccel = true;
      };
    };
  };
}
