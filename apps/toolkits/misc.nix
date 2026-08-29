{
  pkgs,
  username,
  lib,
  config,
  ...
}: let
  cfg = config.apps.toolkits.misc;
in {
  options.apps.toolkits.misc.enable = lib.mkEnableOption "misc desktop apps";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
  ];
  # locosend
  networking.firewall = {
    allowedTCPPorts = [53317];
    allowedUDPPorts = [53317];
  };

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      # ── editor ────────────────────────────────────
      # gimp
      imhex
      libreoffice-qt
      # onlyoffice-desktopeditors
      # obsidian
      # ocamlPackages.cpdf
      krita
      blender
      # ── stream ────────────────────────────────────
      # moonlight-qt
      obs-studio
      # showmethekey
      vlc

      # ── apps ──────────────────────────────────────
      # bottles
      stable.gearlever
      localsend
      # pomodoro-gtk
      # keepassxc

      # ── 某些功能 ──────────────────────────────────
      btop
      kdePackages.filelight
      xfce4-taskmanager

      # ── xjb ───────────────────────────────────────
      # fastfetch
      jq
      openssl
      xeyes

      # ── archive ───────────────────────────────────
      _7zz-rar
      peazip
      squashfsTools

      bubblewrap

      # ── network ───────────────────────────────────
      socat
      # caido
      dig
      # mitmproxy
      nmap
      traceroute
      # zap

      subfinder
      amass

      dnsx
      httpx
      nuclei
      ffuf
      katana

      sqlmap

      hashcat
      thc-hydra
      fscan

      android-tools
      apktool
      apksigner
      javaPackages.compiler.temurin-bin.jdk-25

      jadx
    ];
  };
  };
}
