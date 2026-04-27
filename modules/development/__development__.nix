{ lib, username, ... }:
let
  inherit (import ../../lib/helpers.nix { inherit lib; }) mkDevLanguage;
in {
  options.development.languages = lib.mkOption {
    type = lib.types.listOf (lib.types.enum [
      "c-cpp" "go" "java" "javascript" "python" "rust"
    ]);
    default = [ "c-cpp" "javascript" "python" "rust" ];
    description = "Languages to enable development tooling for";
  };

  imports = [
    ./git.nix
    (mkDevLanguage "go" ({ pkgs, username, ... }: {
      home-manager.users.${username} = {
        home.packages = with pkgs; [ go gopls golangci-lint gofumpt ];
        home.sessionVariables.GOPROXY = "https://goproxy.cn,direct";
        home.sessionPath = [ "/home/${username}/go/bin" ];
      };
    }))
    (mkDevLanguage "rust" ({ pkgs, username, ... }: {
      home-manager.users.${username} = {
        home.packages = with pkgs; [ rustup pkg-config ];
        home.sessionVariables = {
          RUSTUP_HOME = "$HOME/.rustup";
          CARGO_HOME = "$HOME/.cargo";
          RUSTUP_DIST_SERVER = "https://rsproxy.cn";
          RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
        };
      };
    }))
    (mkDevLanguage "javascript" ({ pkgs, username, ... }: {
      home-manager.users.${username} = {
        home.packages = with pkgs; [ nodejs pnpm bun ];
        home.sessionVariables.PNPM_HOME = "/home/${username}/.local/share/pnpm";
        home.sessionPath = [ "/home/${username}/.local/share/pnpm" ];
      };
    }))
    (mkDevLanguage "java" ({ pkgs, username, ... }: {
      home-manager.users.${username} = {
        home.packages = with pkgs; [ jdk ];
      };
    }))
    (mkDevLanguage "python" ({ pkgs, username, ... }: {
      environment.systemPackages = with pkgs; [ python3 uv ];
      home-manager.users.${username}.xdg.configFile."uv/uv.toml" = {
        text = ''
          [[index]]
          url = "https://pypi.tuna.tsinghua.edu.cn/simple"
          default = true
        '';
      };
    }))
    (mkDevLanguage "c-cpp" ({ pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        gcc gnumake cmake gdb pkg-config openssl.dev
      ];
      environment.variables = {
        PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
        C_INCLUDE_PATH = "${pkgs.openssl.dev}/include";
        CPLUS_INCLUDE_PATH = "${pkgs.openssl.dev}/include";
        LIBRARY_PATH = "${pkgs.openssl.out}/lib";
      };
    }))
  ];

  config.environment.sessionVariables = {
    PATH = [ "/home/${username}/.local/bin" ];
  };
}
