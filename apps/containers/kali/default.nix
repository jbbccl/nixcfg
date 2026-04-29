{ config, lib, pkgs, ... }:
let
  cfg = config.apps.containers.kali;

  context = pkgs.runCommand "kali-ctx" { } ''
    mkdir $out
    cp ${./Dockerfile} $out/Dockerfile
    cp ${../entrypoint.sh} $out/entrypoint.sh
    cp ${../environment} $out/environment
    cp ${../toolkit-profile.sh} $out/toolkit-profile.sh
	chmod +x $out/entrypoint.sh $out/toolkit-profile.sh
  '';

  launchCmd = pkgs.writeShellScriptBin "kali" ''
    set -eu
    DATA="$HOME/.local/share/containers"
    mkdir -p "$DATA/kali" "$DATA/public" "$DATA/toolkit"

    exec ${pkgs.podman}/bin/podman run --rm -it \
      --name kali \
      --env DISPLAY --env WAYLAND_DISPLAY --env XDG_RUNTIME_DIR \
      --env DBUS_SESSION_BUS_ADDRESS \
      --env ZDOTDIR=/home/a/.config/zsh \
      --env XDG_SESSION_DESKTOP=labwc \
      --env XDG_VTNR=1 \
      --env XDG_SESSION_TYPE=wayland \
      --env XDG_SEAT=seat0 \
      --env XDG_MENU_PREFIX=gnome- \
      --env XDG_SESSION_ID=3 \
      --env XDG_CURRENT_DESKTOP=labwc \
      --env NO_AT_BRIDGE=1 \
      --env LANG=zh_CN.UTF-8 \
      --env LANGUAGE=zh_CN:zh \
      --env LC_ALL=zh_CN.UTF-8 \
      --env TZ=Asia/Shanghai \
      --env QT_AUTO_SCREEN_SCALE_FACTOR=0 \
      --env QT_QPA_PLATFORMTHEME_QT6=gtk3 \
      --env QT_QPA_PLATFORMTHEME=gtk3 \
      --env GDK_BACKEND=wayland \
      --env QT_QPA_PLATFORM=wayland \
      --env SDL_VIDEODRIVER=wayland \
      --env MOZ_ENABLE_WAYLAND=1 \
      --env GTK_USE_PORTAL=0 \
      -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
      -v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:ro" \
      -v "$XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0:ro" \
      -v "$DATA/kali:/home/a:rw" \
      -v "$DATA/public:/home/public:ro" \
      -v "$DATA/toolkit:/opt/toolkit" \
      -v /run/current-system/sw/share/X11/fonts:/usr/local/share/fonts:ro \
      -v /run/current-system/sw/share/icons/:/usr/share/icons/:ro \
      --device /dev/dri --device /dev/snd \
      -h kali \
      --user a \
      --network host --uts private \
      --ipc=private --userns=keep-id \
      localhost/kali-linux:play zsh
  '';
in
{
  options.apps.containers.kali = {
    enable = lib.mkEnableOption "Kali daily container";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.build-kali = {
      description = "Build kali OCI image";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        export PATH="${pkgs.shadow}/bin:$PATH"
        if ${pkgs.podman}/bin/podman image exists localhost/kali-linux:play; then
          echo "Image already exists, skipping build"
        else
          ${pkgs.podman}/bin/podman build \
            --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) \
            -t localhost/kali-linux:play ${context}
        fi
      '';
    };

    environment.systemPackages = [ launchCmd ];
  };
}