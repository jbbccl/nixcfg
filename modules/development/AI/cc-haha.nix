{ pkgs, ... }: 
let
	cc-haha = pkgs.callPackage ./home/e/Desktop/test/cc-haha/flake.nix {};
in 
{
	environment.systemPackages = [ cc-haha ];

	environment.etc."myapp-run".source = pkgs.writeShellScript "ccc" 
	''
		exec ${cc-haha}/bin/claude-haha
	'';
}