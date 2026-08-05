{
  config,
  lib,
  ...
}: let
  desktopFile = {
    brave = "brave-browser.desktop";
    firefox = "firefox.desktop";
  };
  selected = desktopFile.${config.desktop.browser.select};
in {
  options.desktop.browser.select = lib.mkOption {
    type = lib.types.enum ["brave" "firefox"];
    description = "默认浏览器 (决定 mime handler, 需确保对应 browser.enable 已开)";
  };

  imports = [
    ./firefox.nix
    ./brave.nix
  ];

  config = lib.mkIf config.desktop.enable {
    xdg.mime.defaultApplications = {
      "text/html" = selected;
      "x-scheme-handler/http" = selected;
      "x-scheme-handler/https" = selected;
      "x-scheme-handler/about" = selected;
      "x-scheme-handler/unknown" = selected;
    };
  };
}
