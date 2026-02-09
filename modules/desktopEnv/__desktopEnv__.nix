let
options = {
	winMgr = "labwc";
	bar = "waybar";
};
in
{
	imports = [
		(import ./displayMgr { options = options; })
		(import ./winMgr { options = options; })
		(import ./bar { options = options; })

		./pty
		./fictx5
		./fileMgr
		./theme.nix
		
		# ./deSession #启用plasma注释其他选项.排除冲突 greetd需要额外配置才能启动kde
  ];
}
