{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.base.cursor;
  base = config.desktop.base;
in {
  options.desktop.base.cursor.enable = lib.mkEnableOption "cursor theming";

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.pointerCursor = {
        gtk.enable = true;
        name = base.cursorName;
        package = base.cursorPackage;
        size = base.cursorSize;
      };

      home.sessionVariables = {
        XCURSOR_THEME = base.cursorName;
        XCURSOR_SIZE = toString base.cursorSize;
      };
    };
  };
}
