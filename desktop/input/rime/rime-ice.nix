{ lib, stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
	pname = "rime-ice";
	version = "2026.03.26";
	src = fetchFromGitHub {
		owner = "iDvel";
		repo = "rime-ice";
		rev = "2026.03.26";
		hash = "sha256-hRtA1cYAQm7M+dPSThedqKogr8YMkP9WQFEZw5pdCbU=";
	};
	installPhase = ''
		mkdir -p $out/share/rime-data
		rm -rf ./others
		rm -f README.md LICENSE
		rm -rf ./.github
		rm default.yaml custom_phrase.txt
		cp -r ./* $out/share/rime-data
	'';
	meta = with lib; {
		description = "Rime 输入法配置（雾凇拼音）";
		homepage = "https://github.com/iDvel/rime-ice";
		license = licenses.gpl3Only;
		platforms = platforms.all;
	};
}
