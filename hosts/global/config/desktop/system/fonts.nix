{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    fontDir.enable = true;

    # font config
    fontconfig = {
      enable = true; # enabling this auto-detects installed fonts in home.packages and environment.packages
      # the defaults seem to fine, https://search.nixos.org/options?channel=22.11&show=fonts.fontconfig.hinting.enable&from=0&size=50&sort=relevance&type=packages&query=fonts

      defaultFonts = {
        monospace = ["UbuntuMono Nerd Font"];
        serif = ["Ubuntu Font"];
        sansSerif = ["Ubuntu Font"];
      };
    };
  };
}
