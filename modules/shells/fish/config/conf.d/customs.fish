if status is-interactive
	set fish_greeting
	fish_config theme choose "Catppuccin Mocha"
	alias sd=sudo
	alias nv=nvim
	alias docker=podman
	alias pd=podman
	alias db=distrobox
	alias hh="hermes --tui"
	alias ns="sudo nixos-rebuild switch --flake"
	alias nb="sudo nixos-rebuild switch --flake"
	alias gc="sudo nix-collect-garbage -d && nix-collect-garbage -d"
end