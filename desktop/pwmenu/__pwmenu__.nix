{
  config,
  lib,
  ...
}: {
  options.desktop.pwmenu.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum ["wlogout"]);
    default = null;
    description = "power menu";
  };

  imports = [
    ./wlogout/wlogout.nix
  ];

  config = lib.mkIf (config.desktop.pwmenu.select != null) {
    desktop.pwmenu.wlogout.enable = lib.mkDefault (config.desktop.pwmenu.select == "wlogout");
  };
}
