{ pkgs, username, ... }:
let
#   myClashVerge = pkgs.callPackage ./clash-verge/package.nix { };
in
{
	environment.systemPackages = with pkgs; [
		kdePackages.partitionmanager
	];
	# locosend
	networking.firewall={
		allowedTCPPorts = [ 53317 ];
		allowedUDPPorts = [ 53317 ];
	};

	home-manager.users.${username} = {
		home.packages = with pkgs; [
			# ── editor ────────────────────────────────────
			# gimp
            imhex
			libreoffice-qt
			# obsidian
            # ocamlPackages.cpdf
            zed-editor
            vscode#-fhs

			# ── stream ────────────────────────────────────
            # moonlight-qt
			obs-studio
			# showmethekey
			vlc

			# ── apps ──────────────────────────────────────
			# bottles
            gearlever
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
            squashfsTools

            # ── network ───────────────────────────────────
			# caido
            dig
			# mitmproxy
            nmap
			traceroute
            # zap
		];
	};
}
