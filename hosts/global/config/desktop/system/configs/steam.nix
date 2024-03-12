{
  config,
  lib,
  pkgs,
  ...
}: {
  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            gamescope
            gamemode
            libnotify
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
    gamescope = {
      enable = true;
      capSysNice = true; # Add cap_sys_nice capability to the GameScope binary so that it may renice itself
    };
    gamemode = {
      enableRenice = true;
      settings = {
        general.renice = 10;
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
