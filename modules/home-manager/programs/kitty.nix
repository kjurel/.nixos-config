{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.programs.kitty;
in
lib.mkIf cfg.enable {
  programs.kitty.enable = true;
  programs.kitty.theme = "Catppuccin-Mocha";

  desktop.hyprland.keybinds =
    let
      kitty = lib.getExe config.programs.kitty.package;
    in
    [ "SUPER, F1, exec, ${kitty}" ];
}
