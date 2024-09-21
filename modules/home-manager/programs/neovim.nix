{
  lib,
  pkgs,
  config,
  inputs,
  username,
  ...
}:
let
  cfg = config.modules.programs.neovim;
in
lib.mkIf cfg.enable {
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      wl-clipboard
      python3Full
      nodejs
      zig
    ];
    plugins = with pkgs.vimPlugins; [
      nvchad
      nvchad-ui
      # nvim-treesitter
      # # nvim-treesitter.withAllGrammars - causes long rebuilds
      # nvim-treesitter.withPlugins (p: with p; [
      #   tree-sitter-nix
      #   tree-sitter-vim
      #   tree-sitter-lua
      #   tree-sitter-luadoc
      #   tree-sitter-vimdoc
      #   tree-sitter-hyprlang
      #   tree-sitter-bash
      #   tree-sitter-json
      #   tree-sitter-toml
      #   tree-sitter-yaml
      #   tree-sitter-html
      #   tree-sitter-css
      #   tree-sitter-tsx
      #   tree-sitter-javascipt
      #   tree-sitter-typescipt
      #   tree-sitter-astro
      #   tree-sitter-markdown
      #   tree-sitter-markdown_inline
      #   tree-sitter-python
      # ])
      # nvim-lspconfig
  
      # comment-nvim
      # neodev-nvim
      # nvim-cmp
  
      # telescope-nvim
      
    ];
  
  };

  # config.lib.meta = {
  #   configPath = "/home/${username}/git/config";
  #   mkMutableSymlink =
  #     path:
  #     config.hm.lib.file.mkOutOfStoreSymlink (
  #       config.lib.meta.configPath + lib.strings.removePrefix (toString inputs.self) (toString path)
  #     );

  # };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink /home/${username}/.nixos-config/.config/nvim;
}
