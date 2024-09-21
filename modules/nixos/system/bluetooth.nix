{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.system.bluetooth;
in
lib.mkIf cfg.enable {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };
  services.blueman.enable = true;
}
