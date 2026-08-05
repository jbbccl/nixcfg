{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.browser.brave;
in {
  options.desktop.browser.brave.enable = lib.mkEnableOption "brave browser";

  config = lib.mkIf cfg.enable {
    # programs.firefox.enable = true;	# 15
    environment.systemPackages = with pkgs; [
      # ungoogled-chromium	# 20
      brave # 25
      # librewolf
      # floorp-bin	# 11.5
    ];
  };
}
