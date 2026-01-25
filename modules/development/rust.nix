{ pkgs, username, ... }: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      rustup
      rustc
    ];
    home.sessionVariables = {
      RUSTUP_HOME = "$HOME/.rustup";
      CARGO_HOME = "$HOME/.cargo";
      RUSTUP_DIST_SERVER = "https://rsproxy.cn";
      RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
    };
  };
}
