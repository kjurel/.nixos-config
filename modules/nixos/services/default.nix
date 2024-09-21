{ lib, ... }:
let
  inherit (lib) utils mkEnableOption;
in
# basename = baseNameOf ./.;
# files = utils.scanPaths ./.;
# pths = map (x: {name = toString x + ".enable"; value = mkEnableOption (toString x + " module");}) files;
# pths_attr = builtins.listToAttrs (pths);
{
  imports = utils.scanPaths ./.;

  options.modules.services = {
    gnome-keyring.enable = mkEnableOption "gnome keyring";
    mac-randomize.enable = mkEnableOption "macchanger";
    polkit-gnome.enable = mkEnableOption "gnome polkit";
    printing.enable = mkEnableOption "printing";
    ssh.enable = mkEnableOption "ssh";
    usb.enable = mkEnableOption "usb";
    vpn.enable = mkEnableOption "vpn";
  };

  # options.modules.services.${basename} = {
  #   enable = mkEnableOption (basename + " module");
  # };

  # options.modules.services = pths_attr;

  config = {
    services = {
      tumbler.enable = true;
      gvfs.enable = true;
    };
  };
}
