{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.dispMgr.noctalia-greeter;
in {
  options.desktop.dispMgr.noctalia-greeter.enable = lib.mkEnableOption "noctalia-greeter";

  config = lib.mkIf cfg.enable {
    programs.noctalia-greeter = {
      enable = true;
      settings = {
        appearance = {
          scheme = "Catppuccin";
        };
        cursor = {
          theme = "breeze_cursors";
          size = 12;
        };
        keyboard = {
          layout = "us";
        };
      };
    };
  };
}
