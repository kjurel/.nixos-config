{
  imports = [ ./hardware-configuration.nix ];
  # inputs.nixvim.nixosModules.nixvim
  # inputs.home-manager.nixosModules.default

  # If you want to use modules your own flake exports (from modules/nixos):
  # outputs.nixosModules.example

  # Or modules from other flakes (such as nixos-hardware):
  # inputs.hardware.nixosModules.common-cpu-amd
  # inputs.hardware.nixosModules.common-ssd
  modules = {
    core = {
      homeManager.enable = true;
    };
    services = {
      gnome-keyring.enable = true;
      mac-randomize.enable = false;
      polkit-gnome.enable = true;
      printing.enable = false;
      ssh.enable = false;
      usb.enable = false;
      vpn.enable = false;
    };
    system = {
      device.type = "laptop";
      device.gpu.type = "nvidia";
      desktop.enable = true;
      desktop.display-manager.greetd.enable = true;
      desktop.display-manager.greetd.type = "tui"; # TODO
      audio.enable = true;
      bluetooth.enable = true;
    };
  };
}
