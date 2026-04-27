{ lib }:
let
	inherit (lib) mkOption mkEnableOption mkDefault mkIf types;
	inherit (types) nullOr enum listOf;
in rec {
  # ── Nullable enum helpers ──────────────────────────────────────
	mkNullOrEnum = desc: values: mkOption {
		type = nullOr (enum values);
		default = null;
		description = desc;
	};
	mkNullOrListEnum = desc: values: mkOption {
		type = nullOr (listOf (enum values));
		default = null;
		description = desc;
	};

  # ── xdg.configFile / home.file directory binding ───────────────
	mkConfigDir = name: source: {
		"${name}/" = {
			force = true;
			recursive = true;
			inherit source;
		};
	};
	mkHomeDir = path: source: {
		"${path}" = {
			force = true;
			recursive = true;
			inherit source;
		};
	};
}
