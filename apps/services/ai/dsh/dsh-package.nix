{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  fetchurl,
  pnpm_11,
  pnpmConfigHook,
  autoPatchelfHook,
  python3,
  makeWrapper,
  zlib,
}:
let
  # node-addon-require-builtin 靠扫描 node/V8 的机器码来定位 V8 内部字段, 只认
  # nodejs.org 官方构建产物。nixpkgs 自编译的 node (24.21.0 / 22.23.3) 会被判成
  #   "x64 sysv getter is not a recognized this->field accessor"
  # 导致 dsh 一引导 profile 就 "host preparation failed"。实测 V8 版本相同
  # (13.6.233.17), 差别在构建产物本身, 所以只能固定用官方二进制。
  nodejs = stdenv.mkDerivation {
    pname = "nodejs-official";
    version = "24.18.1";

    src = fetchurl {
      url = "https://nodejs.org/dist/v24.18.1/node-v24.18.1-linux-x64.tar.xz";
      hash = "sha256-1sZk3z8/YUWOjCd1hVcTKFItcFFmcjp8eCOpJTpNFaA=";
    };

    nativeBuildInputs = [autoPatchelfHook];
    buildInputs = [stdenv.cc.cc.lib zlib];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -a . $out/
      runHook postInstall
    '';

    meta = {
      description = "Node.js official Linux x64 build (dsh runtime requirement)";
      homepage = "https://nodejs.org";
      license = lib.licenses.mit;
      mainProgram = "node";
      platforms = ["x86_64-linux"];
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dsh";
  version = "0.2.0-rc.2";

  # 上游是 pnpm monorepo 且不提供 flake, 只能 fetchFromGitHub 后自行构建。
  # rev 对应发行 tag dsh-v0.2.0-rc.2。
  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "deepseek-harness";
    rev = "639ed015397290b3745d163aafe02ffee4aa3f84";
    hash = "sha256-ZtO+bdoYbIkIgLTge5Eh7KYwTVh8FpFAAvx58dSY1PI=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-+7jFaROKpN8XHFpulloK2lb0GsYXbEdMs/V7ZO9leKE=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_11
    pnpmConfigHook
    python3
    makeWrapper
  ];

  env = {
    # 构建过程不得联网: electron / playwright 的二进制下载一律跳过
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    # node-gyp 用 Nix 的 node 头文件, 不联网下载
    npm_config_nodedir = nodejs;
    CI = "1";
    # fetchFromGitHub 的源码树没有 .git, 而 scripts/build.ts 默认要 `git rev-parse HEAD`;
    # 上游为这种非 Git 构建环境留了这个显式覆盖变量。
    DSH_CLIENT_COMMIT_HASH = "639ed015397290b3745d163aafe02ffee4aa3f84";
  };

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  # 运行期 bin/ 的 bundle 以裸模块名解析 workspace 包 (apps/cli/node_modules →
  # ../../packages/...), 故整棵源码树连同 node_modules 一起安装。
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/dsh
    cp -a . $out/lib/dsh/

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/dsh \
      --add-flags "$out/lib/dsh/apps/cli/lib/bin.js" \
      --prefix PATH : ${lib.makeBinPath [nodejs pnpm_11]}

    runHook postInstall
  '';

  meta = {
    description = "DeepSeek Harness: boot ordered stacks of composable agent plugins";
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    license = lib.licenses.bsd3;
    mainProgram = "dsh";
    platforms = lib.platforms.linux;
  };
})
