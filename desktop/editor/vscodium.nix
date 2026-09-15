{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.editor.vscodium;
  codium-with-code = pkgs.symlinkJoin {
    name = "codium-with-code";
    paths = [pkgs.vscodium];
    postBuild = ''
      ln -sf codium $out/bin/code
    '';
  };
  declarativeSettings = {
    "editor.fontSize" = 17;
    "window.zoomLevel" = 1;
    "editor.fontFamily" = "'Maple Mono NF CN', Maple Mono NF CN";
    "workbench.colorTheme" = "Catppuccin Macchiato";
    # tectonic 按需拉取宏包，直连 data1.fullyjustified.net 不通，走 mihomo mixed-port
    "latex-workshop.latex.tools" = [
      {
        name = "tectonic";
        command = "tectonic";
        args = ["--synctex" "--keep-logs" "--print" "%DOC%.tex"];
        env = {
          HTTP_PROXY = "http://127.0.0.1:7897";
          HTTPS_PROXY = "http://127.0.0.1:7897";
        };
      }
    ];
    "latex-workshop.latex.recipes" = [
      {
        name = "tectonic";
        tools = ["tectonic"];
      }
    ];
    "latex-workshop.latex.recipe.default" = "tectonic";
  };
  declarativeSettingsFile =
    pkgs.writeText "vscode-declarative-settings.json"
    (builtins.toJSON declarativeSettings);
in {
  options.desktop.editor.vscodium.enable = lib.mkEnableOption "VSCodium GUI editor";

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.vscodium = {
        enable = true;
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            catppuccin.catppuccin-vsc
            llvm-vs-code-extensions.vscode-clangd
            llvm-vs-code-extensions.lldb-dap
            ms-python.python
            ms-python.vscode-python-envs
            ms-python.debugpy
            # ms-pyright.pyright
            detachhead.basedpyright
            jnoortheen.nix-ide
            myriad-dreamin.tinymist
            james-yu.latex-workshop
          ];
          userSettings = {};
        };
      };
      home.activation.z_vscode_merge_settings = ''
        settings="$HOME/.config/VSCodium/User/settings.json"
        declarative="${declarativeSettingsFile}"
        mkdir -p "$(dirname "$settings")"
        if [ -f "$settings" ]; then
          merged=$(${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$settings" "$declarative")
        else
          merged=$(cat "$declarative")
        fi
        echo "$merged" > "$settings"
        chmod 644 "$settings"
      '';
      home.packages = [codium-with-code];
    };
  };
}
