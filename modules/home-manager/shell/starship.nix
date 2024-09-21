{ lib, config, ... }:
let
  cfg = config.modules.shell;
in
lib.mkIf cfg.enable {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    # Inverted - swaps bg and fg 
    # (red) - fg:red and bg is transparent
    # (red inverted) - bg:red and fg is transparent
    settings = {
      scan_timeout = 10;
      add_newline = false;
      line_break.disabled = false;
      palette = "catppuccin_mocha";
      format = "$character";
      right_format = lib.strings.concatStrings [
        "[](rosewater)"
        "$os"
        "[](rosewater)"
        "[](mauve inverted)"
        "$hostname"
        "$username"
        "[](mauve)"
        "[](red inverted)"
        "$directory"
        "[](red)"
        "[](peach inverted)"
        "$git_branch"
        "$git_status"
        "[](peach)"
        "[](teal inverted)"
        "$c"
        "$nodejs"
        "$python"
        "$rust"
        "[ ](teal)"
        "[](surface2)"
        "$shell"
        "[](surface1 bg:surface2)"
        "$container"
        "[](surface0 bg:surface1)"
        "$cmd_duration"
        "[ ](surface0)"
      ];
      jobs = {
        format = "[\\[$number\\]]($style) ";
        style = "242";
        number_threshold = 1;
        symbol_threshold = 2;
      };
      fill.symbol = " ";
      os = {
        format = "[$symbol](style)";
        style = "bold";
        disabled = false;
        symbols = {
          Arch = "[ ](rosewater inverted)";
          Fedora = "[ ](rosewater inverted)";
        };
      };
      hostname = {
        style = "mauve inverted bold italic";
        ssh_only = false;
        format = "[ $hostname ]($style)";
      };
      username = {
        style_user = "mauve inverted bold italic";
        style_root = "bg:mauve";
        format = "[\(@$user\)]($style)";
        show_always = false;
        disabled = false;
      };
      directory = {
        style = "red inverted";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      git_branch = {
        symbol = "";
        style = "peach inverted";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        style = "peach inverted";
        format = "[$all_status$ahead_behind ]($style)";
      };
      shell = {
        format = "[$indicator](style)";
        style = "bg:surface2";
        disabled = false;
        bash_indicator = "[ bsh ](sky bg:surface2)";
        zsh_indicator = "[ zsh ](sky bg:surface2)";
      };
      container = {
        format = "[$symbol \\[$name\\] ]($style)";
        style = "sapphire bg:surface1 dimmed";
      };
      cmd_duration = {
        show_milliseconds = false;
        min_time = 0;
        style = "blue bg:surface0 dimmed";
        format = "[ ♥ $duration ]($style)";
      };
      c = {
        symbol = "";
        style = "teal inverted";
        format = "[ $symbol ($version) ]($style)";
      };
      golang = {
        symbol = "";
        style = "teal inverted";
        format = "[ $symbol ($version) ]($style)";
      };
      nodejs = {
        symbol = "";
        style = "teal inverted";
        format = "[ $symbol ($version) ]($style)";
        version_format = "v$$\{major\}";
      };
      python = {
        symbol = "󰌠";
        style = "teal inverted";
        format = "[ $symbol ($version) ]($style)";
        version_format = "v$$\{major\}";
      };
      rust = {
        symbol = "";
        style = "teal inverted";
        format = "[ $symbol ($version) ]($style)";
        version_format = "v$$\{major\}";
      };
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
    };
  };
}
