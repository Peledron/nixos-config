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
  fonts = {
    fontconfig = {
      enable = true;
      # the defaults seem to fine, https://search.nixos.org/options?channel=22.11&show=fonts.fontconfig.hinting.enable&from=0&size=50&sort=relevance&type=packages&query=fonts

      defaultFonts = {
        monospace = [ "Ubuntu Nerd Font" ];
        serif = [ "Ubuntu Nerd Font" ];
        sansSerif = [ "Ubuntu Nerd Font" ];
      };
    };

    # font packages
    fonts = with pkgs; [
#     source-code-pro # mono-space font
#     source-sans-pro # for ui elements
      ubuntu_font_family
      font-awesome # font icons
      corefonts # ms fonts
      (nerdfonts.override{
        fonts = [
          "FiraCode" # https://github.com/tonsky/FiraCode
          "Ubuntu"
        ]; # adds specific programming ligatures
      })
  ];
  # ---
}
