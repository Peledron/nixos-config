{
  lib,
  pkgs,
  ...
}: {
  #hardware.steam-hardware.enable = true; # already enabled by programs.steam
  programs = {
    steam = {
      enable = true;
      /*
        package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            gamescope
            gamemode
            libnotify
          ];
      };
      */
      #gamescopeSession.enable = true;
      extest.enable = true; #  Load the extest library into Steam, to translate X11 input events to uinput events (e.g. for using Steam Input on Wayland)
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
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
    #protontricks
  ];
}
