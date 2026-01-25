{ config, pkgs, ... }: {
  i18n.defaultLocale = "zh_CN.UTF-8";
#   i18n.defaultLocale = "en_US.UTF-8";

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
      monospace = [ "MapleMono-NF-CN"  ];
      sansSerif = [ "MapleMono-NF-CN" "Source Han Sans SC" ];
      serif = [ "MapleMono-NF-CN" "Source Han Serif SC" ];
    };
  };
}
