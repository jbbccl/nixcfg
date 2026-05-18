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

  # ── KDL generators ─────────────────────────────────────────────
  # Generic: mkKdlBlocks "output" (name: out: [ "    mode ..." ]) outputs
	mkKdlBlocks = name: mkLines: attrs:
		builtins.concatStringsSep "\n" (
			lib.mapAttrsToList (key: val:
				let
					body = builtins.concatStringsSep "\n" (mkLines key val);
				in
				if body == "" then "" else "${name} \"${key}\" {\n${body}\n}\n"
			) attrs
		);

  # Niri-specific: mkNiriOutputKdl config.desktop.niri.outputs → output.kdl
	mkNiriOutputKdl = mkKdlBlocks "output" (_: out:
		     lib.optional out.off                     "    off"
		  ++ lib.optional (out.mode != null)          "    mode \"${out.mode}\""
		  ++ lib.optional (out.scale != null)         "    scale ${builtins.toString out.scale}"
		  ++ lib.optional (out.transform != "normal") "    transform \"${out.transform}\""
		  ++ lib.optional (out.position != null)      "    position x=${builtins.toString out.position.x} y=${builtins.toString out.position.y}"
	);
}
