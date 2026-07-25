{
  config,
  lib,
  ...
}: let
  mkBarEnable = name: lib.mkDefault (builtins.elem name config.desktop.shell.bar.list);
in {
  imports = [
    ./waybar/waybar.nix
    ./ironbar/ironbar.nix
  ];

  options.desktop.shell.bar.list = lib.mkOption {
    type = lib.types.nullOr (lib.types.listOf (lib.types.enum ["waybar" "ironbar"]));
    default = null;
    description = "status bar";
  };

  config = lib.mkIf (config.desktop.shell.bar.list != null) {
    desktop.shell.bar.waybar.enable = mkBarEnable "waybar";
    desktop.shell.bar.ironbar.enable = mkBarEnable "ironbar";
  };
}
