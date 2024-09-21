{ pkgs, ... }:
{
  boot = {
    initrd = {
      enable = true;
      systemd.enable = true;
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      timeout = 0;
    };
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rings" ];
        })
      ];
      # font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    };
    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-font-patcher
  ];
  zramSwap.enable = true;

}
