{
  description = "Nixos and HM config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: https://discourse.nixos.org/t/get-name-of-current-file-is-it-possible/43966
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    ags.url = "github:Aylur/ags";
    anyrun.url = "github:anyrun-org/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    # impurity.url = "github:outfoxxed/impurity.nix";
    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      inherit (lib) nixosSystem genAttrs hasPrefix;
      lib = nixpkgs.lib.extend (final: prev: (import ./libs final) // inputs.home-manager.lib);
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      mkHost = hostname: username: system: {
        ${hostname} = nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              self
              inputs
              outputs
              hostname
              username
              lib
              ;
          };
          modules =
            if (hasPrefix "installer" hostname) then
              [ ./host/installer ]
            else
              [
                ./host/${hostname}
                ./modules/nixos
              ];
        };
      };

    in
    {
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./packages nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      templates = import ./templates;

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos; # upstream into nixpkgs
      homeManagerModules = import ./modules/home-manager; # upstream into home-manager

      # NixOS configuration entrypoint
      # 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = mkHost "di15-7567g" "kanishkc" "x86_64-linux";
    };
}
