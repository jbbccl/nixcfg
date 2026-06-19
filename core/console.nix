{
  config,
  lib,
  pkgs,
  ...
}: let
  palette = {
    base = "24273a";
    red = "ed8796";
    green = "a6da95";
    yellow = "eed49f";
    blue = "8aadf4";
    pink = "f5bde6";
    teal = "8bd5ca";
    subtext1 = "b8c0e0";
    surface2 = "5b6078";
    subtext0 = "a5adcb";
  };
  cfg = config.core.console;
in {
  options.core.console.font = lib.mkOption {
    type = lib.types.str;
    default = "ter-v22b";
    description = "TTY console font (console backend only)";
  };

  config = {
    console = {
      enable = true;
      earlySetup = true;
      font = cfg.font;
      packages = [pkgs.terminus_font];
      useXkbConfig = true;
      colors = map (which_color: palette.${which_color}) [
        "base"
        "red"
        "green"
        "yellow"
        "blue"
        "pink"
        "teal"
        "subtext1"
        "surface2"
        "red"
        "green"
        "yellow"
        "blue"
        "pink"
        "teal"
        "subtext0"
      ];
    };
  };
}
