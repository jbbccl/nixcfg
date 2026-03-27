{ pkgs, username, _config_, ... }:

let
# wanxiangGram = builtins.fetchurl {
# 	url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
# 	sha256 = "sha256:153zlmfp416f9bl99szqs91ypwsz6z0139l543n3blibj8fhf6yx";
# };
rime-ice = pkgs.stdenvNoCC.mkDerivation {
	pname = "rime-ice";
	version = "2024.12.12";

	src = builtins.fetchGit {
		url = "https://github.com/iDvel/rime-ice.git";
		ref = "main";  # 分支
		rev = "c02c83c9e91f3e081052441330df00667abc64a8";  # commit hash

		# rev = "refs/heads/main";  # 分支引用
		# rev = "refs/tags/2024.12.12";  # 标签引用
	};

	installPhase = ''
	mkdir -p $out/share/rime-data
	rm -rf ./others
	rm -f README.md LICENSE
	rm -rf ./.github
	#rm squirrel.yaml weasel.yaml double_pinyin* radical_pinyin*
	rm default.yaml custom_phrase.txt
	cp -r ./* $out/share/rime-data
	'';
};
in
{
home-manager.users.${username} = {

	xdg.configFile = {
		"fcitx5/" = {
			force = true;
			recursive = true;
			source = ./config;
		};
		"fcitx5/conf/classicui.conf" = {
			force = true;
			recursive = true;
			source = (if _config_ == "lap"
					then ./config/conf/classicui-lap.conf
				else if _config_ == "pc"
					then ./config/conf/classicui-pc.conf
				else ./config/classicui-pc.conf );
		};
	};

	home.file = {
		".local/share/fcitx5/rime" = {
			source = "${rime-ice}/share/rime-data";
			force = true;
			recursive = true;
			onChange = ''
			mkdir -p ~/.local/share/fcitx5/rime
			chmod -R u+w ~/.local/share/fcitx5/rime
			rm -f ~/.local/share/fcitx5/rime/*.bin
			# rm -f ~/.local/share/fcitx5/rime/build/*
			'';
		};
		# ".local/share/fcitx5/rime/wanxiang-lts-zh-hans.gram" = {
		# 	source = "${wanxiangGram}/wanxiang-lts-zh-hans.gram";
		# 	force = true;
		# };

		".local/share/fcitx5/rime/default.yaml" = {
			source = ./share/rime/default.yaml;
			force = true;
		};
		".local/share/fcitx5/rime/rime_ice.custom.yaml" = {
			source = ./share/rime/rime_ice.custom.yaml;
			force = true;
		};

		".local/share/fcitx5/themes" = {
			source = ./share/themes;
			force = true;
			recursive = true;
		};

	};

	home.sessionVariables = {
	XMODIFIERS = "@im=fcitx";
	QT_IM_MODULE = "fcitx";
	QT_IM_MODULES = "fcitx;ibus;wayland";
	GTK_IM_MODULE = "fcitx";
	SDL_IM_MODULE = "fcitx";
	GLFW_IM_MODULE = "fcitx";
	};
};

i18n = {
	inputMethod = {
		type = "fcitx5";
		enable = true;
		fcitx5 = {
				waylandFrontend = true;
				addons = with pkgs; [
					# qt6Packages.fcitx5-configtool
					libime
					librime-lua
					librime-octagram #接入模型依赖TODO: 需要手动放入模型文件

					fcitx5-gtk
					libsForQt5.fcitx5-qt
					kdePackages.fcitx5-qt
					fcitx5-lua
					fcitx5-fluent
					fcitx5-rime

					rime-ice
					# wanxiangGram
				];
			};
		};
	};

}
