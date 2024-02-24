{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          gamescope
          gamemode
        ];
    };
    gamescopeSession = {
      enable = true;
      args = [
        "-r 144"
        "--rt" # force real time
        "--adaptive-sync"
      ];
    };
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true; # Add cap_sys_nice capability to the GameScope binary so that it may renice itself
  };
}
