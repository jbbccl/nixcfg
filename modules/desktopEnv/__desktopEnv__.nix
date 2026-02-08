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
		#error: attempt to call something which is not a function but a set: { imports = «thunk»; }
		./pty
		./fictx5
		./fileMgr
		./theme.nix
		
		# ./deSession #启用plasma注释其他选项.排除冲突
  ];
}
