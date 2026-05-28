{ config, pkgs, ... }:
let
    base = config.desktop.base;
in
{
	fonts = {
		packages = with pkgs; [
			maple-mono.NF-CN
			noto-fonts-color-emoji
			source-han-sans  # 思源黑体
			source-han-serif # 思源宋体
			#lxgw-wenkai      # 霞鹜文楷
			#(nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) #"JetBrainsMono Nerd Font"
		];
		fontconfig.defaultFonts = {
			emoji = [ "Noto Color Emoji" ];
			monospace = [ base.fontName  ];
			sansSerif = [ base.fontName "Source Han Sans SC" ];
			serif = [ base.fontName "Source Han Serif SC" ];
		};
	};
}
