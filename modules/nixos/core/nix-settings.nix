{
  lib,
  config,
  inputs,
  outputs,
  username,
  ...
}:
let
  inherit (lib)
    isType
    mapAttrs
    filterAttrs
    mapAttrsToList
    ;
in
{
  # Scheduled auto upgrade system (this is only for system upgrades,
  # if you want to upgrade cargo\npm\pip global packages, docker containers or different part of the system
  # or get really full system upgrade, use `topgrade` CLI utility manually instead.
  # I recommend running `topgrade` once a week or at least once a month)
  system.autoUpgrade = {
    enable = true;
    operation = "switch"; # If you don't want to apply updates immediately, only after rebooting, use `boot` option in this case
    flake = "/etc/nixos";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    dates = "weekly";
    # channel = "https://nixos.org/channels/nixos-unstable";
  };

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config.allowUnfree = true;
  };

  nix =
    let
      flakeInputs = filterAttrs (_: isType "flake") inputs;
    in
    {
      channel.enable = false;
      # Populates the nix registry with all our flake inputs `nix registry list`
      registry = mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      # Add flake inputs to nix path. Enables loading flakes with <flake_name>
      # like how <nixpkgs> can be referenced.
      nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      settings = {
        # https://discourse.nixos.org/t/declaratively-or-otherwise-add-trusted-users-in-21-11/25134/2
        trusted-users = [
          "root"
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        # Do not load the default global registry
        # https://channels.nixos.org/flake-registry.json
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        auto-optimise-store = true;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      optimise.automatic = true;
    };
}
