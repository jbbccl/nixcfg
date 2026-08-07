function opy
  set -l hostIP 127.0.0.1
  set -l port 7897
  set -gx http_proxy "http://$hostIP:$port"
  set -gx HTTP_PROXY $http_proxy
  set -gx https_proxy $http_proxy
  set -gx HTTPS_PROXY $http_proxy
  set -gx ftp_proxy $http_proxy
  set -gx FTP_PROXY $http_proxy
  set -gx ALL_PROXY "socks5://$hostIP:$port"
  set -gx all_proxy $ALL_PROXY
end

function upy
  set -e http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY ALL_PROXY all_proxy
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
  set -l git_proxy (git config --global --get http.proxy 2>/dev/null)
  echo "HTTP(S)/FTP PROXY:" $http_proxy
  echo "SOCKS PROXY:" $all_proxy
  echo "GIT PROXY:" $git_proxy
end

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
      echo "poy o|u|g|f|s"
  end
end
