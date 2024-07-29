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
    };
  };
  # the following should fix problems with fonts not being seen by flatpak
  system.fsPackages = [pkgs.bindfs];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = with pkgs; [
        kdePackages.breeze-icons # for plasma
        adwaita-icon-theme
      ];
      pathsToLink = ["/share/icons"];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = ["/share/fonts"];
    };
  in {
    "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
  };
}
