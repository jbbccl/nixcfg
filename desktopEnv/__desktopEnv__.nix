let
options = {
	winMgr = "labwc";
	bar = "waybar";
};
in
{
	imports = [
		(import ./displayMgr/__displayMgr__.nix { options = options; })
		(import ./winMgr/__winMgr__.nix { options = options; })
		(import ./wmAddons/__wmAddons__.nix { options = options; })

		./theme.nix

		# ./deSession #启用plasma注释其他选项.排除冲突 greetd需要额外配置才能启动kde
  ];
}
