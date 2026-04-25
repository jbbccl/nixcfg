function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

if status is-interactive
	set fish_greeting
	fish_config theme choose "Catppuccin Mocha"
	alias sduo=sudo
	alias nv=nvim
	alias docker=podman
	alias pd=podman
	alias db=distrobox
end