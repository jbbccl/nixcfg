{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.game.wine;
in {
  options.apps.game.wine = {
    enable = lib.mkEnableOption "wine (wayland) + proton (umu)";

    package = lib.mkOption {
      type = lib.types.package;
      # pkgs.wineWow64Packages.stagingFull
      default = pkgs.wineWow64Packages.waylandFull;
      description = "wine package variant";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.package
      winetricks
      umu-launcher
    ];

    home-manager.users.${username} = {lib, ...}: {
      home.activation.wineWayland = lib.hm.dag.entryAfter ["writeBoundary"] ''
        export WINEPREFIX="$HOME/.wine"
        [ -d "$WINEPREFIX" ] || run ${cfg.package}/bin/wineboot --init || true
        run ${cfg.package}/bin/wine reg add 'HKCU\Software\Wine\Drivers' /v Graphics /d "wayland,x11" /f || true
      '';
    };
  };
}
