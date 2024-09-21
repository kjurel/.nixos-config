{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.programs.fastfetch;
in
lib.mkIf cfg.enable {
  home.packages = [ pkgs.fastfetch ];

  programs.bash.shellAliases = {
    neofetch = "fastfetch";
  };

  # TODO: convert to builtins.toJSON
  xdg.configFile."fastfetch/config.jsonc".text = # json
    ''
      {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
        "logo": {
          "padding": {
            "top": 3,
          },
        },
        "display": {
          "separator": " 󰑃  ",
        },
        "modules": [
          {
            "type": "custom",
            "format": "\u001b[90m┌────────────────────────────────────────────────────────────┐",
          },
          {
            "type": "title",
            "keyWidth": 10,
            "format": "                          {6}{7}{8}",
          },
          {
            "type": "custom",
            "format": "\u001b[90m└────────────────────────────────────────────────────────────┘",
          },
          {
            "type": "custom",
            "format": "\u001b[90m  \u001b[31m  \u001b[32m  \u001b[33m  \u001b[34m  \u001b[35m  \u001b[36m  \u001b[37m  \u001b[38m  \u001b[39m        \u001b[38m  \u001b[37m  \u001b[36m  \u001b[35m  \u001b[34m  \u001b[33m  \u001b[32m  \u001b[31m  \u001b[90m ",
          },
          {
            "type": "custom",
            "format": "\u001b[90m┌────────────────────────────────────────────────────────────┐",
          },
          {
            "type": "os",
            "key": " DISTRO",
            "keyColor": "yellow",
          },
          {
            "type": "kernel",
            "key": "│ ├",
            "keyColor": "yellow",
          },
          {
            "type": "packages",
            "key": "│ ├󰏖",
            "keyColor": "yellow",
          },
          {
            "type": "shell",
            "key": "│ └",
            "keyColor": "yellow",
          },
          {
            "type": "wm",
            "key": "  DE/WM",
            "keyColor": "blue",
          },
          {
            "type": "wmtheme",
            "key": "│ ├󰉼",
            "keyColor": "blue",
          },
          {
            "type": "icons",
            "key": "│ ├󰀻",
            "keyColor": "blue",
          },
          {
            "type": "terminal",
            "key": "│ ├",
            "keyColor": "blue",
          },
          {
            "type": "wallpaper",
            "key": "│ └󰸉",
            "keyColor": "blue",
          },
          {
            "type": "host",
            "key": "󰌢 SYSTEM",
            "keyColor": "green",
          },
          {
            "type": "cpu",
            "key": "│ ├󰻠",
            "keyColor": "green",
          },
          {
            "type": "gpu",
            "key": "│ ├󰻑",
            "keyColor": "green",
          },
          {
            "type": "display",
            "key": "│ ├󰍹",
            "keyColor": "green",
            "compactType": "original-with-refresh-rate",
          },
          {
            "type": "memory",
            "key": "│ ├󰾆",
            "keyColor": "green",
          },
          {
            "type": "swap",
            "key": "│ ├󰓡",
            "keyColor": "green",
          },
          {
            "type": "uptime",
            "key": "│ ├󰅐",
            "keyColor": "green",
          },
          {
            "type": "display",
            "key": "│ └󰍹",
            "keyColor": "green",
          },
          {
            "type": "sound",
            "key": "  AUDIO",
            "keyColor": "cyan",
          },
          {
            "type": "player",
            "key": "│ ├󰥠",
            "keyColor": "cyan",
          },
          {
            "type": "media",
            "key": "│ └󰝚",
            "keyColor": "cyan",
          },
          {
            "type": "custom",
            "format": "\u001b[90m└────────────────────────────────────────────────────────────┘",
          },
          {
            "type": "custom",
            "format": "\u001b[90m  \u001b[31m  \u001b[32m  \u001b[33m  \u001b[34m  \u001b[35m  \u001b[36m  \u001b[37m  \u001b[38m  \u001b[39m        \u001b[38m  \u001b[37m  \u001b[36m  \u001b[35m  \u001b[34m  \u001b[33m  \u001b[32m  \u001b[31m  \u001b[90m ",
          },
          "break",
        ],
      }
    '';
}