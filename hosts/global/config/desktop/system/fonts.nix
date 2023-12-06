{ config, lib, pkgs, ... }:
{
  fonts = lib.mkDefault {
      # font packages
      fonts = with pkgs; [
        ubuntu_font_family
        font-awesome # font icons
        noto-fonts
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
      # font config
      fontconfig = {
        enable = true;
        # the defaults seem to fine, https://search.nixos.org/options?channel=22.11&show=fonts.fontconfig.hinting.enable&from=0&size=50&sort=relevance&type=packages&query=fonts

        defaultFonts = {
          monospace = [ "UbuntuMono Nerd Font" ];
          serif = [ "Ubuntu Font" ];
          sansSerif = [ "Ubuntu Font" ];
        };
      };
  };
}
