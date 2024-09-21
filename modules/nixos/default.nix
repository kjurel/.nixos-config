{
  lib,
  inputs,
  system,
  ...
}:
{
  imports = lib.utils.scanPaths ./.;

  environment.etc.config = {
    target = "nixos";
    source = "/home/kanishkc/.nixos-config";
  };

  programs.nh = {
    enable = true;
    # clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };

}
