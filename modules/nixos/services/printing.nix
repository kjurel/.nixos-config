{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.services.printing;
in
lib.mkIf cfg.enable {
  services = {
    printing = {
      enable = true;
      browsing = true;
      webInterface = true;
      drivers = [ pkgs.gutenprint ];
      defaultShared = true;
      listenAddresses = [ "*:631" ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };

}
