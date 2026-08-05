{
  config,
  lib,
  ...
}: let
  mkEditorEnable = name: lib.mkDefault (builtins.elem name config.desktop.editor.list);
in {
  options.desktop.editor.list = lib.mkOption {
    type = lib.types.nullOr (lib.types.listOf (lib.types.enum ["vscodium" "zed"]));
    default = null;
    description = "editors";
  };

  imports = [
    ./vscodium.nix
    ./zed.nix
  ];

  config = lib.mkIf (config.desktop.editor.list != null) {
    desktop.editor.vscodium.enable = mkEditorEnable "vscodium";
    desktop.editor.zed.enable = mkEditorEnable "zed";
  };
}
