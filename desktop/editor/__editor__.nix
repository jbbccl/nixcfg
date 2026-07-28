{
  config,
  lib,
  ...
}: let
  mkEditorEnable = name: lib.mkDefault (builtins.elem name config.desktop.editor.list);
in {
  options.desktop.editor.list = lib.mkOption {
    type = lib.types.nullOr (lib.types.listOf (lib.types.enum ["vscodium" "other"]));
    default = null;
    description = "editors";
  };

  imports = [
    ./vscodium.nix
    ./other.nix
  ];

  config = lib.mkIf (config.desktop.editor.list != null) {
    desktop.editor.vscodium.enable = mkEditorEnable "vscodium";
    desktop.editor.other.enable = mkEditorEnable "other";
  };
}
