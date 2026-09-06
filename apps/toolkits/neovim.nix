{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.toolkits.neovim;
in {
  options.apps.toolkits.neovim.enable = lib.mkEnableOption "Neovim CLI editor";

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      opts = {
        number = true;
        relativenumber = true;

        cursorline = true;
        signcolumn = "yes";
        scrolloff = 8;
        termguicolors = true;
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        smartindent = true;
        wrap = false;
        swapfile = false;
        backup = false;
        undofile = true;
        hlsearch = false;
        incsearch = true;
        ignorecase = true;
        smartcase = true;
        mouse = "a";
        clipboard = "unnamedplus";
      };

      clipboard = {
        register = "unnamedplus";
        providers = {
          wl-copy.enable = true;
          # xclip.enable = true;
        };
      };

      globals.mapleader = " ";
    };

    environment.sessionVariables = {
      VISUAL = "nvim";
      EDITOR = "nvim";
    };
  };
}
