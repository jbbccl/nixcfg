{ config, lib, username, ... }:
{
  imports = [
    ./git.nix

    ./c-cpp.nix
    ./javascript.nix
    ./python.nix
    ./rust.nix
    ./go.nix
    ./java.nix
  ];

  options.modules = {
    dev.lang = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf (lib.types.enum [
        "c-cpp" "go" "java" "javascript" "python" "rust"
      ]));
      default = null;
      description = "langs";
    };
  };

  config.environment.sessionVariables = {
    PATH = [ "/home/${username}/.local/bin" ];
  };
}
