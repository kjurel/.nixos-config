{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.services.vpn;
in
lib.mkIf cfg.enable {
  # Enable Mullvad VPN
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad; # `pkgs.mullvad` only provides the CLI tool, use `pkgs.mullvad-vpn` instead if you want to use the CLI and the GUI.

  environment.systemPackages = with pkgs; [ mullvad-closest ];
}
