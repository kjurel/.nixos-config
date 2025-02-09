{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    utils
    mkEnableOption
    mkIf
    optionals
    ;
  cfg = config.modules.shell;
in
{
  imports = utils.scanPaths ./.;

  options.modules.shell = {
    enable = mkEnableOption "custom shell environment";
    sillyTools = mkEnableOption "installation of silly shell tools";
  };

  config = mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        bottom
        curl
        fd
        file
        jq
        killall
        ripgrep
        trash-cli
        unrar
        unzip
        wget
        yazi
        zathura
        zip
      ])
      ++ optionals cfg.sillyTools (
        with pkgs;
        [
          cbonsai
          cmatrix
          cowsay
        ]
      );

    home.sessionVariables.COLORTERM = "truecolor";
  };
}
