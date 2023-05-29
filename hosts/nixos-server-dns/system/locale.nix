# font and xorg keymap settings
{ config, lib, pkgs, ... }:
{
  # change keyboard layout
  # --> unsure if this affects DE
  #console.useXkbConfig = true; # overrides console settings set in global/locale.nix
  #services.xserver.layout = "us";
  # --> change other xkb settings:
  #services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  #};
  # ---


  # fonts:
  /*
  fonts.fonts = with pkgs; [
    carlito                                 
    vegur                                  
    source-code-pro # mono-space font 
    source-sans-pro # for ui elements
    font-awesome # font icons
    corefonts # ms fonts
    (nerdfonts.override{
      fonts = [
        "FiraCode" # https://github.com/tonsky/FiraCode
      ]; # adds specific programming ligatures
    })
  ];
  */
  # ---
}
