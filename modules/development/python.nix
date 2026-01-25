{ config, pkgs, username, ... }:
{

environment.systemPackages = with pkgs; [
	python3
	uv
];

home-manager.users.${username}.xdg.configFile."uv/uv.toml" = {
force = true;
recursive = true;
text= ''
[[index]]
url = "https://pypi.tuna.tsinghua.edu.cn/simple"
default = true
'';
# [ -f ~/.zshrc ] && echo 'eval "$(uvx --generate-shell-completion zsh)"' >> ~/.zshrc
# python-install-mirror = "https://github.com/astral-sh/python-build-standalone/releases/download"
# pypy-install-mirror = "https://downloads.python.org/pypy"
};

}