{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.input.ibus;
  rimePath = config.desktop.input.rime.shareDir;
in {
  options.desktop.input.ibus.enable = lib.mkEnableOption "ibus input method";

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {config, ...}: {
      # ibus-rime reads from XDG_CONFIG_HOME/ibus/rime
      xdg.configFile."ibus/rime" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink rimePath;
      };
    };

    i18n.inputMethod = {
      type = "ibus";
      enable = true;
      ibus.engines = with pkgs; [
        ibus-engines.rime
      ];
    };
  };
}
