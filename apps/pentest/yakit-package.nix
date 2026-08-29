{
  lib,
  stdenv,
  electron,
  ungoogled-chromium,
  copyDesktopItems,
  makeDesktopItem,
  # 覆盖 Chrome/Chromium 可执行文件路径（例如指向 google-chrome / brave）；
  # 为 null 时使用 nixpkgs 自带 ungoogled-chromium（chrome-launcher 通过 CHROME_PATH 发现）
  chromePath ? null,
}: let
  version = "1.4.8-0817";

  chrome =
    if chromePath != null
    then chromePath
    else "${ungoogled-chromium}/bin/chromium";

  # 本机 ~/yakit 本地构建（含 Wayland ozone 适配）产出的应用内容：
  # resources/（app.asar）+ extraFiles（bins/、report/）。
  # 重新构建 yakit 后需重新打包并更新下方 sha256：
  #   tar -C <stage> -czf ~/yakit/release/yakit-${version}-linux-x64-unpacked.tar.gz .
  #   nix hash path <解包后的目录>
  appTarball = builtins.fetchTarball {
    url = "file:///home/e/yakit/release/yakit-${version}-linux-x64-unpacked.tar.gz";
    sha256 = "sha256-AYdIMX/fgQ4kf+Mg1BHw3LUlJBO5PZwgxGZqVr3D3sU=";
  };

  desktopItem = makeDesktopItem {
    name = "yakit";
    exec = "yakit %U";
    icon = "yakit";
    desktopName = "Yakit";
    comment = "Yakit - 一体化网络安全测试平台(Wayland)";
    categories = ["Development" "Security"];
    startupWMClass = "yakit";
  };
in
  stdenv.mkDerivation {
    pname = "yakit";
    inherit version;

    src = appTarball;

    # electron 的包装脚本与本包同闭包，保证符号链接/RUNPATH 引用的 store 路径不被 GC；
    # 默认捆绑 ungoogled-chromium 供 chrome-launcher 使用（浏览器调试/MITM 抓包功能需要）
    buildInputs = [electron] ++ lib.optional (chromePath == null) ungoogled-chromium;
    nativeBuildInputs = [copyDesktopItems];

    installPhase = ''
      runHook preInstall

      # 从 nixpkgs electron 包装脚本中提取真实的 Electron 二进制（electron-unwrapped）
      ELEC="$(grep -m1 -oE '/nix/store/[^"]+/libexec/electron/electron' "${electron}/bin/electron")"
      ELECDIR="$(dirname "$ELEC")"

      mkdir -p $out/lib/yakit/resources $out/bin

      # 复制二进制并改名为 yakit：Electron 依据可执行文件名判定“打包应用”模式
      # （isPackaged=true，加载打包资源而非开发服务器地址）
      cp "$ELEC" $out/lib/yakit/yakit
      chmod +x $out/lib/yakit/yakit

      # 其余 Electron 运行时文件（*.pak / *.so / locales / 快照等）符号链接复用 electron 包，
      # 不重复占用磁盘；resources/ 需要可写，单独构建
      for f in "$ELECDIR"/*; do
        b="$(basename "$f")"
        if [ "$b" != "electron" ] && [ "$b" != "resources" ]; then
          ln -s "$f" "$out/lib/yakit/$b"
        fi
      done

      # 应用内容：app.asar + extraFiles（bins/、report/）
      cp -a "$src"/resources/* $out/lib/yakit/resources/
      cp -a "$src"/bins "$src"/report $out/lib/yakit/

      # 图标：安装到多个标准尺寸目录（部分启动器只扫描 128/256/512 等标准尺寸）
      for s in 128 256 512 800; do
        install -Dm644 "$src"/yakit.png $out/share/icons/hicolor/''${s}x''${s}/apps/yakit.png
      done

      # 启动脚本：复用 nixpkgs electron 包装脚本的环境（GIO/GTK 模块、XDG_DATA_DIRS、
      # CHROME_DEVEL_SANDBOX 等），追加 Wayland 参数后 exec 打包布局的二进制
      sed -n '1,/^exec /p' "${electron}/bin/electron" | grep -v '^exec ' > $out/lib/yakit/.electron-env
      cat > $out/bin/yakit <<EOF
      #! ${stdenv.shell} -e
      source $out/lib/yakit/.electron-env
      # Wayland 原生渲染（非 XWayland）；--enable-wayland-ime 配合 fcitx5 等 Wayland IME
      export ELECTRON_OZONE_PLATFORM_HINT=auto
      # chrome-launcher 通过 CHROME_PATH 发现浏览器（Yakit 浏览器调试 / MITM 抓包）
      export CHROME_PATH='${chrome}'
      exec $out/lib/yakit/yakit --enable-wayland-ime "\$@"
      EOF
      chmod +x $out/bin/yakit

      runHook postInstall
    '';

    desktopItems = [desktopItem];

    meta = with lib; {
      description = "Yakit - 一体化网络安全测试平台(Wayland, Electron ${electron.version})";
      homepage = "https://github.com/yaklang/yakit";
      license = licenses.agpl3Plus;
      platforms = ["x86_64-linux"];
      mainProgram = "yakit";
    };
  }
