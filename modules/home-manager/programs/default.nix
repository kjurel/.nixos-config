{ lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = lib.utils.scanPaths ./.;

  options.modules.programs = {
    fastfetch.enable = mkEnableOption "fastfetch";
    ferdium.enable = mkEnableOption "ferdium";
    firefox.enable = mkEnableOption "firefox";
    git.enable = mkEnableOption "git";

    git.userEmail = lib.mkOption { type = lib.types.str; };
    git.userName = lib.mkOption { type = lib.types.str; };
    hyprlock.enable = mkEnableOption "hyprlock";
    media.enable = mkEnableOption "media tools";
    neovim.enable = mkEnableOption "neovim";
    kitty.enable = mkEnableOption "kitty";
    vscodium.enable = mkEnableOption "vscode";
    waybar.enable = mkEnableOption "waybar";
    wofi.enable = mkEnableOption "wofi";
  };

  config = {

    home.packages = [ pkgs.bitwarden-desktop ];

    xdg.desktopEntries."org.gnome.Settings" = {
      name = "Settings";
      comment = "Gnome Control Center";
      icon = "org.gnome.Settings";
      exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
      categories = [ "X-Preferences" ];
      terminal = false;
    };

    # github:matostitos
    nix = {
      settings = {
        builders-use-substitutes = true;

        substituters = [
          "https://hyprland.cachix.org"
          "https://nix-gaming.cachix.org"
          # Nixpkgs-Wayland
          "https://cache.nixos.org"
          "https://nixpkgs-wayland.cachix.org"
          "https://nix-community.cachix.org"
          # Nix-community
          "https://nix-community.cachix.org"
          # extra substituters 
          "https://anyrun.cachix.org"

        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          # Nixpkgs-Wayland
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          # Nix-community
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        ];
      };
    };
  };

}
