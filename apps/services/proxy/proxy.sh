# POSIX proxy env helpers — source from bash/zsh; fish has proxy.fish
pxy_host=127.0.0.1
pxy_port=7897

opy() {
  export http_proxy="http://${pxy_host}:${pxy_port}"
  export HTTP_PROXY="$http_proxy"
  export https_proxy="$http_proxy"
  export HTTPS_PROXY="$http_proxy"
  export ftp_proxy="$http_proxy"
  export FTP_PROXY="$http_proxy"
  export ALL_PROXY="socks5://${pxy_host}:${pxy_port}"
  export all_proxy="$ALL_PROXY"
  export no_proxy=localhost,127.0.0.0/8,*.local,10.0.0.0/8
}

upy() {
  unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY ALL_PROXY all_proxy no_proxy
}

pys() {
  echo "HTTP(S)/FTP PROXY: ${http_proxy-}"
  echo "SOCKS PROXY: ${all_proxy-}"
  echo "GIT PROXY: $(git config --global --get http.proxy 2>/dev/null || true)"
}
