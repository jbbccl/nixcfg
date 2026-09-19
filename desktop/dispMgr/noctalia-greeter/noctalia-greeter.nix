{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.dispMgr.noctalia-greeter;
in {
  options.desktop.dispMgr.noctalia-greeter.enable = lib.mkEnableOption "noctalia-greeter";

  config = lib.mkIf cfg.enable {
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        user.default = "${username}";
        appearance = {
          scheme = "Catppuccin";
        };
        cursor = {
          theme = "breeze_cursors";
          size = 24;
        };
        keyboard = {
          layout = "us";
        };
      };
    };
  };
}
