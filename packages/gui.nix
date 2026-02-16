{ pkgs, username, ... }: 
let
#   myClashVerge = pkgs.callPackage ./clash-verge/package.nix { };
in
{
home-manager.users.${username} = {
	home.packages = with pkgs; [
		flclash

		kdePackages.filelight
		gparted

		localsend

		zed-editor
		obsidian
		libreoffice-qt

		obs-studio

		gimp2
		# hunspell
		# wpsoffice-cn
		pomodoro-gtk

		imhex

		showmethekey
	];
};

}
