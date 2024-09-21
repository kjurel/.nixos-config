{
  lib,
  pkgs,
  inputs,
  config,
  username,
  ...
}:
let
  inherit (lib) mkIf mkForce mkMerge;
  inherit (config.modules.core) homeManager;
  inherit (homeConfig.programs) hyprlock;
  cfg = config.modules.system.desktop;
  homeConfig = config.home-manager.users.${username};
  homeDesktopCfg = homeConfig.modules.desktop;
  # hyprlandPackage = homeConfig.wayland.windowManager.hyprland.package;
  windowManager = if homeManager.enable then homeDesktopCfg.windowManager else null;
  hyprlandPackage = inputs.hyprland.packages."${pkgs.system}".hyprland;

  # https://discourse.nixos.org/t/how-to-invoke-script-installed-with-writescriptbin-inside-other-config-file/8795/3
  nvidi-offload = pkgs.writeScriptBin "nividia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';

in
mkIf cfg.enable (mkMerge [
  (mkIf cfg.display-manager.greetd.enable {
    # https://github.com/sjcobb2022/nixos-config/blob/29077cee1fc82c5296908f0594e28276dacbe0b0/hosts/common/optional/greetd.nix 
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a . %h | %F' --remember --cmd Hyprland";
          user = "kanishkc";
        };
      };
    };
    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    #environment.etc."greetd/environments".text = ''
    #  Hyprland
    #  fish
    #  bash
    #'';

    environment.systemPackages = with pkgs; [ greetd.tuigreet ];
  })
  {
    # Enables wayland for all apps that support it
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  }

  (mkIf homeManager.enable {
    xdg.portal.enable = mkForce false;
    security.pam.services.hyprlock = mkIf (hyprlock.enable) { };
  })

  (mkIf (cfg.desktopEnvironment == "gnome") {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # Only enable the power management feature on laptops
    services.upower.enable = mkForce (config.modules.system.device.type == "laptop");
    services.power-profiles-daemon.enable = mkForce (config.modules.system.device.type == "laptop");
    services.libinput.enable = mkForce (config.modules.system.device.type == "laptop");
  })

  (mkIf (windowManager == "Hyprland") {
    programs.hyprland = {
      enable = true;
      package = hyprlandPackage;
    };
  })
  (mkIf (config.modules.system.device.gpu.type == "nvidia") {
    # https://nixos.wiki/wiki/Nvidia#Optimus
    # https://github.com/NixOS/nixos-hardware/tree/master/common/gpu/nvidia
    # https://github.com/mogria/nixos-config/blob/master/hardware/nvidia.nix
    # https://discourse.nixos.org/t/laptop-graphics-card-not-detected-by-nixos-generate-config/22450

    boot.extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';
    services.udev.extraRules = ''
      # Remove NVIDIA USB xHCI Host Controller devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA USB Type-C UCSI devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA Audio devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA VGA/3D controller devices
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
    '';
    boot.blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
    ];
    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {

      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = true;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # Nvidia Optimus PRIME. It is a technology developed by Nvidia to optimize
      # the power consumption and performance of laptops equipped with their GPUs.
      # It seamlessly switches between the integrated graphics,
      # usually from Intel, for lightweight tasks to save power,
      # and the discrete Nvidia GPU for performance-intensive tasks.
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # FIXME: Change the following values to the correct Bus ID values for your system!
        # More on "https://wiki.nixos.org/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_(Mandatory)"
        nvidiaBusId = "PCI:0:2:0";
        intelBusId = "PCI:1:0:0";
      };
    };

    # NixOS specialization named 'nvidia-sync'. Provides the ability
    # to switch the Nvidia Optimus Prime profile
    # to sync mode during the boot process, enhancing performance.
    specialisation = {
      nvidia-sync.configuration = {
        system.nixos.tags = [ "nvidia-sync" ];
        hardware.nvidia = {
          powerManagement.finegrained = lib.mkForce false;

          prime.offload.enable = lib.mkForce false;
          prime.offload.enableOffloadCmd = lib.mkForce false;

          prime.sync.enable = lib.mkForce true;
          # Dynamic Boost. It is a technology found in NVIDIA Max-Q design laptops with RTX GPUs.
          # It intelligently and automatically shifts power between
          # the CPU and GPU in real-time based on the workload of your game or application.
          dynamicBoost.enable = lib.mkForce true;
        };
      };
    };
  })
])
