{
  config,
  lib,
  ...
}: {
  options.desktop.shell.pwmenu.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum ["wlogout"]);
    default = null;
    description = "power menu";
  };

  imports = [
    ./wlogout/wlogout.nix
  ];

  config = lib.mkIf (config.desktop.shell.pwmenu.select != null) {
    desktop.shell.pwmenu.wlogout.enable = lib.mkDefault (config.desktop.shell.pwmenu.select == "wlogout");
  };
}
