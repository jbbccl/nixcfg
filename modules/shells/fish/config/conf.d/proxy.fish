function poy
	switch $argv[1]
		case o
			opy
		case u
			upy
		case g
			__setGit
		case f
			__unsetGit
		case s
			pys
		case '*'
			__pxyUsage
	end
end

function opy
	set -l hostIP 127.0.0.1
	set -l socksPort 7897
	set -l httpPort 7897

	export http_proxy="http://$hostIP:$httpPort"
	export HTTP_PROXY="http://$hostIP:$httpPort"

	export https_proxy="http://$hostIP:$httpPort"
	export HTTPS_proxy="http://$hostIP:$httpPort"

	export ftp_proxy="http://$hostIP:$httpPort"
	export FTP_PROXY="http://$hostIP:$httpPort"

	export ALL_PROXY="socks5://$hostIP:$httpPort"
	export all_proxy="socks5://$hostIP:$httpPort"
end

function upy
	set -e http_proxy
	set -e HTTP_PROXY
	set -e https_proxy
	set -e HTTPS_PROXY
	set -e ftp_proxy
	set -e FTP_PROXY
	set -e ALL_PROXY
	set -e all_proxy
end

function __setGit
	git config --global http.proxy "http://127.0.0.1:7897"
	git config --global https.proxy "http://127.0.0.1:7897"
end

function __unsetGit
	git config --global --unset http.proxy
	git config --global --unset https.proxy
end

function pys
	set -l git_proxy (git config --global --list|awk -F '=' '/http.proxy/ {print $2}')

	echo "HTTP(S)/FTP PROXY:" {$http_proxy}
	echo "SOCKS PROXY:" {$all_proxy}
	echo "GIT PROXY:" {$git_proxy}
end

function __pxyUsage
	echo -e (set_color normal)"A fish shell config for setting proxy environment variables."
	echo -e (set_color red)"ERROR:" (set_color normal)"Unsupported arguments!"
	echo -e (set_color yellow)"\nUSAGE:"
	echo -e (set_color normal)"    pxy <SUBCOMMAND>"
	echo -e (set_color yellow)"\nSUBCOMMAND:"
	echo -e (set_color green)"    o" (set_color normal)"\tset proxy environment variables"
	echo -e (set_color green)"    u" (set_color normal)"\tunset proxy environment variables"
	echo -e (set_color green)"    g" (set_color normal)"\toverride the http(s) proxy for git"
	echo -e (set_color green)"    f" (set_color normal)"\tunset the http(s) proxy for git"
	echo -e (set_color green)"    s" (set_color normal)"\tdisplay current settings"
end
