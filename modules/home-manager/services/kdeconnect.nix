{ lib, config, ... }:
let
  cfg = config.modules.services.kdeconnect;
in
lib.mkIf cfg.enable {
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
