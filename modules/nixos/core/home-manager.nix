{
  lib,
  self,
  inputs,
  config,
  username,
  hostname,
  ...
}:
let
  cfg = config.modules.core.homeManager;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (lib.mkAliasOptionModule [ "hm" ] [
      "home-manager"
      "users"
      username
    ])
  ];

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${username} = import ../../../home/${username}.nix;
      sharedModules = [ ../../home-manager ];

      extraSpecialArgs = {
        inherit
          self
          inputs
          username
          hostname
          ;
      };
    };
  };
}
