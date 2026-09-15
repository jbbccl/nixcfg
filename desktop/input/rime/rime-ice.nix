{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "rime-ice";
  version = "2026.06.30";
  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "2026.06.30";
    hash = "sha256-HReBFYih39ohqZ2UAX6wPjjh0KuIauJPSOjk6ZXidss=";
  };
  installPhase = ''
    mkdir -p $out/share/rime-data
    rm -rf ./others
    rm -f README.md LICENSE
    rm -rf ./.github
    # default.yaml / custom_phrase.txt 故意不带 -f：上游若改名或删除，这里要立刻报错，
    # 否则我们自己的 default.yaml 会被上游那份悄悄覆盖掉。
    rm default.yaml custom_phrase.txt
    # 上游仓库自带的非 rime 数据文件，删掉免得进数据目录
    rm -f AGENTS.md recipe.yaml
    cp -r ./* $out/share/rime-data
  '';
  meta = with lib; {
    description = "Rime 输入法配置（雾凇拼音）";
    homepage = "https://github.com/iDvel/rime-ice";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
