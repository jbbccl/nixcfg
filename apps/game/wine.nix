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
      # waylandFull: 同时带 x11/wayland 驱动, 兼容性最好
      # 某个程序在 wayland 驱动下异常时换 pkgs.wineWow64Packages.stagingFull (纯 XWayland)
      default = pkgs.wineWow64Packages.waylandFull;
      description = "wine package variant";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.package
      winetricks
      umu-launcher # Steam 外跑 Proton: umu-run xxx.exe (首次运行自动拉 GE-Proton)
    ];

    # 声明式启用原生 Wayland 驱动: 初始化默认 prefix 并写注册表 (幂等, 每次 switch 执行)
    home-manager.users.${username} = {lib, ...}: {
      home.activation.wineWayland = lib.hm.dag.entryAfter ["writeBoundary"] ''
        export WINEPREFIX="$HOME/.wine"
        [ -d "$WINEPREFIX" ] || run ${cfg.package}/bin/wineboot --init || true
        run ${cfg.package}/bin/wine reg add 'HKCU\Software\Wine\Drivers' /v Graphics /d "wayland,x11" /f || true
      '';
    };
  };
}
