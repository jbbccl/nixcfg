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
}:
let
  # 必须用 nodejs.org 官方二进制: node-addon-require-builtin 扫描 node/V8 的机器码,
  # nixpkgs 自编译的 node 会被判成 "x64 sysv getter is not a recognized this->field
  # accessor" 而直接启动失败 (实测 24.21.0 / 22.23.3 均如此)。
  nodejs = stdenv.mkDerivation {
    pname = "nodejs-official";
    version = "24.18.1";

    src = fetchurl {
      url = "https://nodejs.org/dist/v24.18.1/node-v24.18.1-linux-x64.tar.xz";
      hash = "sha256-1sZk3z8/YUWOjCd1hVcTKFItcFFmcjp8eCOpJTpNFaA=";
    };

    nativeBuildInputs = [autoPatchelfHook];
    buildInputs = [stdenv.cc.cc.lib];
    dontConfigure = true;
    dontBuild = true;
    installPhase = "mkdir -p $out; cp -a . $out/";

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

  # rev = 发行 tag dsh-v0.2.0-rc.2
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

  nativeBuildInputs = [nodejs pnpm_11 pnpmConfigHook python3 makeWrapper];

  env = {
    # 构建期不联网
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    npm_config_nodedir = nodejs;
    CI = "1";
    # 源码树没有 .git, 而 scripts/build.ts 默认要 `git rev-parse HEAD`
    DSH_CLIENT_COMMIT_HASH = "639ed015397290b3745d163aafe02ffee4aa3f84";
  };

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  # 运行期不能走构建产物 apps/cli/lib/bin.js: 它会让第三方 agent preset 的组合挂不起来
  # (子行模块解析失败 → preset 永远 broken → UI 里选不到), 改用上游 package.json 的
  # `dsh` script (node --import tsx/esm src/bin.ts)。store 只读, 所以必须关掉 pnpm 的
  # deps 检查, 否则它会试图 `pnpm install` 写 _tmp_*; 另外不能加 `--`, 会被原样透传。
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/dsh
    cp -a . $out/lib/dsh/

    mkdir -p $out/bin
    makeWrapper ${pnpm_11}/bin/pnpm $out/bin/dsh \
      --add-flags "run dsh" \
      --set pnpm_config_verify_deps_before_run false \
      --set pnpm_config_pm_on_fail ignore \
      --run "cd $out/lib/dsh" \
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
