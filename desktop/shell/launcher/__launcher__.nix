{
  config,
  lib,
  ...
}: let
  mkLauncherEnable = name: lib.mkDefault (config.desktop.shell.launcher.select == name);
in {
  imports = [
    ./fuzzel/fuzzel.nix
    ./rofi/rofi.nix
    ./wofi/wofi.nix
  ];

  options.desktop.shell.launcher.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum ["fuzzel" "rofi" "wofi"]);
    default = null;
    description = "app launcher";
  };

  config = lib.mkIf (config.desktop.shell.launcher.select != null) {
    desktop.shell.launcher.fuzzel.enable = mkLauncherEnable "fuzzel";
    desktop.shell.launcher.rofi.enable = mkLauncherEnable "rofi";
    desktop.shell.launcher.wofi.enable = mkLauncherEnable "wofi";
  };
}
