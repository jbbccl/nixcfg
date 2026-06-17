{ pkgs, username, ... }:
let
#   myClashVerge = pkgs.callPackage ./clash-verge/package.nix { };
in
{
	environment.systemPackages = with pkgs; [
        sdcc
	];

    environment.variables = {
		C_INCLUDE_PATH = [ "${pkgs.sdcc}/share/sdcc/include" "${pkgs.sdcc}/share/sdcc/include/mcs51" ];
		CPLUS_INCLUDE_PATH = [ "${pkgs.sdcc}/share/sdcc/include" "${pkgs.sdcc}/share/sdcc/include/mcs51" ];
        SDCC_HOME = "${pkgs.sdcc}";
        SDCC_INCLUDE = "${pkgs.sdcc}/share/sdcc/include";
	};

    users.users.${username}.extraGroups = [ "dialout" ];
}
