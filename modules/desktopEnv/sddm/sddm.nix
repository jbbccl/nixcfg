{ pkgs, ... }: {
  
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true; 
	#ls -l /run/current-system/sw/share/sddm/themes/
    theme = "catppuccin-macchiato-mauve";
    
  };

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "macchiato"; # 可选: mocha, macchiato, frappe, latte
      
      font  = "Maple Mono NF CN";
      fontSize = "12";
      # 使用纯色背景还是图片? (true = 用图片/默认图)
      loginBackground = false;
      # 背景图定制 (可选)
      # 如果你想用自己的图片，取消注释下面一行并填入路径
      # background = "${./wallpaper.png}"; 
    })
  ];
}