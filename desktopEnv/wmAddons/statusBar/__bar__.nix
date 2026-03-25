{ options, ... }:{
	imports =
		if options.bar == "waybar"
		then [
			(import ./waybar/waybar.nix { options = options; })
			(import ./barAddons/__barAddons__.nix { options = options; })
		] else if options.bar == "noctalia"
		then [
			./noctalia
		]else [];
		#只要安装了noctalia, 即使不运行, 应用启动会慢1秒。
}
