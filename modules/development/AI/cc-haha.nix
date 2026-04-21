{ pkgs, lib, ... }:

let
  cc-haha = pkgs.stdenv.mkDerivation {
    pname = "cc-haha";
    version = "0.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "NanmiCoder";
      repo = "cc-haha";
      branch = "main";
      # 需要替换为实际hash，首次构建会报 correct hash 错误
      hash = lib.fakeHash;
    };

    nativeBuildInputs = [ pkgs.bun ];

    buildPhase = ''
      bun install --frozen-lockfile
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp -r . $out/cc-haha
      ln -s $out/cc-haha/bin/claude-haha $out/bin/cl
    '';
  };
in {
  environment.systemPackages = [
    cc-haha
  ];
}
