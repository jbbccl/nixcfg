{ pkgs, ... }: {
	#桌面环境不能没有浏览器，故分类到这里
    programs.firefox.enable = true;
	environment.systemPackages = with pkgs; [
		ungoogled-chromium
	];
}
