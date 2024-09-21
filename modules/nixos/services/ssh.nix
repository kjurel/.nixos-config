{ lib, config, ... }:
let
  cfg = config.modules.services.ssh;
in
lib.mkIf cfg.enable {
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "xnm" ];
    };
  };
}
