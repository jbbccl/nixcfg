{ config, lib, pkgs, username, ... }:
lib.mkIf config.apps.containers.debian.enable (
let
	uid = builtins.toString config.users.users.${username}.uid;
	debianContext = pkgs.runCommand "daily-debian-context" {} ''
	mkdir $out
	cp ${./Dockerfile} $out/Dockerfile
	'';

	dailyDeb = pkgs.writeShellScriptBin "daily-deb" ''
	set -eu
	DATA="$HOME/.local/share/daily-containers/debian"
	mkdir -p "$DATA"

	FONT_ARGS=()
	if [ -d "/run/current-system/sw/share/fonts" ]; then
		FONT_ARGS=(-v "/run/current-system/sw/share/fonts:/usr/local/share/fonts:ro")
	elif [ -d "$HOME/.local/share/fonts" ]; then
		FONT_ARGS=(-v "$HOME/.local/share/fonts:/usr/local/share/fonts:ro")
	fi

	exec ${pkgs.podman}/bin/podman run --rm -it \
		--env DISPLAY \
		--env WAYLAND_DISPLAY \
		--env XDG_RUNTIME_DIR \
		--env DBUS_SESSION_BUS_ADDRESS \
		--env GTK_USE_PORTAL=0 \
		--env GDK_BACKEND=wayland \
		--env QT_QPA_PLATFORM=wayland \
		--env SDL_VIDEODRIVER=wayland \
		--env MOZ_ENABLE_WAYLAND=1 \
		--env NO_AT_BRIDGE=1 \
		--env LANG=zh_CN.UTF-8 \
		--env LANGUAGE=zh_CN:zh \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:ro" \
		-v "$XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0:ro" \
		"''${FONT_ARGS[@]}" \
		-v "$HOME/.config:/home/a/.config:ro" \
		-v "$HOME/.local:/home/a/.local:ro" \
		-v "$DATA:/home/a:rw" \
		--device /dev/dri \
		--device /dev/snd \
		--userns=keep-id \
		--network host \
		--systemd=always \
		localhost/daily-debian /sbin/init
	'';
in {
	systemd.user.services.daily-build-debian = {
		description = "Build daily-debian OCI image";
		wantedBy = [ "default.target" ];
		serviceConfig = {
			Type = "oneshot";
			RemainAfterExit = true;
		};
		script = ''
		if ${pkgs.podman}/bin/podman image exists localhost/daily-debian; then
			echo "localhost/daily-debian already exists, skipping"
		else
			echo "Building localhost/daily-debian..."
			${pkgs.podman}/bin/podman build \
			--build-arg USER_UID=${uid} \
			--build-arg USER_GID=${uid} \
			-t localhost/daily-debian ${debianContext}
		fi
		'';
	};

	environment.systemPackages = [ dailyDeb ];
})
