{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.programs.ferdium;
in
lib.mkIf cfg.enable {
  home.packages = [ pkgs.ferdium ];
  desktop.hyprland.keybinds =
    let
      ferdium = lib.getExe' pkgs.ferdium "Ferdium";
    in
    [ "SUPER, F3, exec, ${ferdium}" ];
}
