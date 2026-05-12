{ lib, helpers, ... }:
let
	inherit (helpers) mkNullOrEnum mkNullOrListEnum;
in {
	imports = [
		./services/__services__.nix
		./gui/__gui__.nix
		./cli/__cli__.nix
		./containers/__containers__.nix
	];
}
