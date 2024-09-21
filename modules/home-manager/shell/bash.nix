{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.shell;
in
lib.mkIf cfg.enable {
  programs.bash = {
    enable = true;
    historyControl = [
      "erasedups"
      "ignorespace"
    ];
    shellOptions = [
      "autocd"
      "cdspell"
      "cmdhist"
      "dotglob"
      "histappend"
      "expand_aliases"
    ];

    initExtra = ''
      bind "set completion-ignore-case on"

      set -o vi
      bind -m vi-command 'Control-l: clear-screen'
      bind -m vi-insert 'Control-l: clear-screen'
      bind -m vi-insert 'Control-k: previous-history'
      bind -m vi-insert 'Control-j: next-history'
    '';

    shellAliases = {
      cat = "bat";
      grep = "rg";
      rm = "trash-put";
      ytmp3 = ''yt-dlp -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"'';
    };
  };

  # https://github.com/nix-community/home-manager/pull/3238
  # programs.blesh = {
  #   enable = true;
  #   options = {
  #     prompt_ps1_transient = "trim:same-dir";
  #     prompt_ps1_final="$(${pkgs.starship}/bin/starship module character)";
  #     prompt_rps1_final="$(${pkgs.starship}/bin/starship module time)";
  #     prompt_ruler = "empty-line";
  #   };
  # };
}
