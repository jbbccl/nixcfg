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
			# flclash
			# daed

			kdePackages.filelight
			# gparted
			# partitionmanager
			xfce4-taskmanager

			localsend

			# ── editor ──────────────────────────────────
			imhex
			# gimp
			zed-editor
			# obsidian
			libreoffice-qt

			# ── stream ──────────────────────────────────
			obs-studio
			# showmethekey
			# moonlight-qt
			vlc

			# 应用
			gearlever
			# bottles

			# 其他
			# pomodoro-gtk
			# keepassxc
			xeyes

			# ── e ────────────────────────────────────────
			fastfetch
			btop
			# ocamlPackages.cpdf
			openssl

            # ── archive ──────────────────────────────────
            _7zz-rar
            squashfsTools

            # ── network ──────────────────────────────────
			# zap
			# caido
			# mitmproxy
			traceroute
			dig

            nmap
		];
	};
}
