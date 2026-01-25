{
  description = "C development environment with OpenSSL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = ({ self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # 1. 编译工具 (Native Build Inputs)
        # 包含 gcc/clang, make, pkg-config 等
        nativeBuildInputs = with pkgs; [
          gcc           # 或者 clang
          gnumake
          pkg-config    # 必须！用于查找 libraries
          cmake         # 可选
        ];

        # 2. 依赖库 (Build Inputs)
        # Nix 会自动处理 openssl.dev (头文件) 和 openssl.out (库)
        buildInputs = with pkgs; [
          openssl
        ];

        # 3. 环境变量自动注入
        # 有了 pkg-config，通常不需要手动设置 -I/-L，但为了保险起见：
        shellHook = ''
          echo "🛠️ C + OpenSSL environment loaded!"
          
          # 帮助某些简单的 Makefile 找到 OpenSSL
          export OPENSSL_DIR="${pkgs.openssl.dev}"
          export OPENSSL_LIB="${pkgs.openssl.out}/lib"
          export OPENSSL_INCLUDE="${pkgs.openssl.dev}/include"
          
          echo "OpenSSL Include: $OPENSSL_INCLUDE"
        '';
      };
    });
}

{
  description = "Python 3 environment with uv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = ({ self, nixpkgs }:
    let
      # 修改为你对应的架构，如 aarch64-linux (Apple Silicon / ARM)
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python311       # 或者 python3
          uv              # 极速 Python 包管理器
        ];

        # 环境变量设置
        shellHook = ''
          echo "🚀 Python environment loaded!"
          echo "Python version: $(python --version)"
          echo "uv version: $(uv --version)"
          
          # 让 pip/uv 安装的包在当前目录下，而不是污染系统
          export PIP_PREFIX=$(pwd)/_build/pip_packages
          export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
          export PATH="$PIP_PREFIX/bin:$PATH"
          unset SOURCE_DATE_EPOCH
        '';
      };
    });
}