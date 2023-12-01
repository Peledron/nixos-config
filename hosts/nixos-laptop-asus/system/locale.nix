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
        serif = [ "Ubuntu Font" ];
        sansSerif = [ "Ubuntu Font" ];
      };
    };

    # font packages
    fonts = with pkgs; [
      ubuntu_font_family
      font-awesome # font icons
      noto-fonts-emoji
      corefonts # ms fonts
      (nerdfonts.override{
        fonts = [
          "FiraCode" # https://github.com/tonsky/FiraCode
          "Ubuntu"
          "UbuntuMono"
        ]; # adds specific programming ligatures
      })
    ];
    # ---

  };
}