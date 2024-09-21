{ lib, config, ... }:
let
  cfg = config.modules.programs.git;
in
lib.mkIf cfg.enable {
  programs.git = {
    enable = true;
    delta.enable = true;

    userEmail = cfg.userEmail;
    userName = cfg.userName;

    extraConfig = {
      init.defaultBranch = "main";
    };

    ignores = [
      "*~"
      "*.swp"
      "*result*"
      "node_modules"
    ];
  };
}
