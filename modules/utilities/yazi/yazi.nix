{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  options.modules.utilities.yazi.enable = lib.mkEnableOption "yazi file manager";

  config = lib.mkIf config.modules.utilities.yazi.enable {
    environment.systemPackages = with pkgs; [
      (yazi.override {
        _7zz = _7zz-rar;
      })
    ];

    programs.fish.shellInit = ''
      function y
      	set tmp (mktemp -t "yazi-cwd.XXXXXX")
      	command yazi $argv --cwd-file="$tmp"
      	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
      		builtin cd -- "$cwd"
      	end
      	rm -f -- "$tmp"
      end
    '';

    programs.zsh.shellInit = ''
      function y() {
      	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      	yazi "$@" --cwd-file="$tmp"
      	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      		builtin cd -- "$cwd"
      	fi
      	rm -f -- "$tmp"
      }
    '';

    home-manager.users.${username} = {
      xdg.configFile."yazi/" = {
        force = true;
        recursive = true;
        source = ./config;
      };
    };
  };
}
