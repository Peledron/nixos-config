{
  lib,
  pkgs,
  ...
}: {
  programs = {
    steam = lib.mkDefault {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            gamescope
            gamemode
            libnotify
          ];
      };
      gamescopeSession.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true; # Add cap_sys_nice capability to the GameScope binary so that it may renice itself
    };
    gamemode = {
      enableRenice = true;
      settings = {
        general.renice = 10;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    protontricks
  ];
}
