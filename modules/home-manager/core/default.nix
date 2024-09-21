{ lib, username, ... }:
{
  imports = lib.utils.scanPaths ./.;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  systemd.user.startServices = "sd-switch";
}
