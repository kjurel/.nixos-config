{
  modules = {
    shell = {
      enable = true;
      sillyTools = true;
    };

    desktop = {
      windowManager = "Hyprland";
    };

    programs = {
      fastfetch.enable = true;
      ferdium.enable = true;
      firefox.enable = true;
      git.enable = true;
      git.userEmail = "89933773+kjurel@users.noreply.github.com";
      git.userName = "kjurel";
      hyprlock.enable = true;
      media.enable = true;
      neovim.enable = true;
      kitty.enable = true;
      vscodium.enable = true;
      waybar.enable = true;
      wofi.enable = true;
    };

    services = {
      hypridle.enable = true;
      hyprpaper.enable = true;
      kdeconnect.enable = true;
      swaync.enable = true;
    };
  };
}
