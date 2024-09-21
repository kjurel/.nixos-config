# https://nixos.wiki/wiki/VSCodium
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.programs.vscodium;
in
lib.mkIf cfg.enable {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      yzhang.markdown-all-in-one
    ];
  };
}
