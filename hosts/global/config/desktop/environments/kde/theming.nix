{
  config,
  lib,
  pkgs,
  ...
}: let
  qt-theme = "Utterly-Nord";
  qt-theme-package = "utterly-nord-plasma";
  gtk-theme = "Nordic";
  gtk-theme-package = "nordic";
  icon-theme-name = "Papirus-Dark";
  icon-theme-package = "papirus-icon-theme";
  cursor-theme-name = "Adwaita";
  cursor-theme-package = "gnome.adwaita-icon-theme";
in {
  home = {
    packages = with pkgs; [
      # [theming]
      #qogir-theme # gtk
      nordic
      utterly-nord-plasma

      papirus-icon-theme
    ];
    pointerCursor = {
      gtk.enable = true;
      name = "${cursor-theme-name}";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
      x11 = {
        enable = true;
        defaultCursor = "${cursor-theme-name}";
      };
    };
  };
  /*
  qt = {
    enable = true;
    platformTheme = "kde";
    style.name = "kvantum";
  };
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=${qt-theme}";
    "Kvantum/${qt-theme}".source = "${pkgs.${qt-theme-package}}/share/Kvantum/${qt-theme}";
  }; # from https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/2 and https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/3
  */
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "${cursor-theme-name}";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "${icon-theme-name}";
    };
    theme = {
      package = pkgs.nordic;
      name = "${gtk-theme}";
    };
  };
}
