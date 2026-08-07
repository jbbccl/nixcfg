{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.virtual.nix-ld;
in {
  options.modules.virtual.nix-ld.enable = lib.mkEnableOption "nix-ld (非 Nix 二进制 FHS 兼容)";

  # minimal set; add lib when a binary actually fails to load
  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        zstd
        openssl
        curl
        glib
        glibc
        dbus
        systemd
        util-linux
        libGL
        libglvnd
        vulkan-loader
        libxkbcommon
        fontconfig
        freetype
        libffi
        expat
        fuse
        fuse3
        nss
        nspr
        alsa-lib
        pipewire

        libX11
        libXext
        libXcomposite
        libXdamage
        libXfixes
        libXrandr
        libXcursor
        libXrender
        libXtst
        libXi
        libXinerama
        libxcb

        libxshmfence

        gtk3
        pango
        cairo
        atk
        gdk-pixbuf
      ];
    };
  };
}
