{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.shell.bar.ironbar;
in {
  options.desktop.shell.bar.ironbar = {
    enable = lib.mkEnableOption "ironbar status bar";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ironbar
      brightnessctl
      networkmanagerapplet
      pwvucontrol
      wireplumber
    ];

    # home-manager.users.${username} = {
    # 	xdg.configFile."ironbar/" = {
    # 		force = true;
    # 		recursive = true;
    # 		source = ./config;
    # 	};
    # };
  };
}
