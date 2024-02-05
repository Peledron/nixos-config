{
  config,
  lib,
  pkgs,
  ...
}: let
  gtk-theme = "Nordic";
  gtk-theme-package = "nordic";
  qt-theme = "Utterly-Nord";
  qt-theme-package = "utterly-nord-plasma";
  icon-theme-name = "Papirus-Dark";
  icon-theme-package = "papirus-icon-theme";
  cursor-theme-name = "Adwaita";
  cursor-theme-package = "gnome.adwaita-icon-theme";

  # scripts taken from https://github.com/abdul2906/nixos-system-config/blob/main/nixos/modules/hyprland/module.nix
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings/schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme '${gtk-theme}'
    '';
  };
in {
  home = {
    packages = with pkgs; [
      # [imported scripts]
      configure-gtk
      # -> configured through home-manager

      # [theming]
      #qogir-theme # gtk
      nordic
      utterly-nord-plasma

      papirus-icon-theme
      gnome3.adwaita-icon-theme # default gnome cursors

      # [qt-theming control]
      #lxqt.lxqt-qtplugin
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      # -> not needed as we will follow the gtk theme
    ];
    pointerCursor = {
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
    platformTheme = "qtct";
    style.name = "kvantum";
  };
  home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
    };
  */
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=${qt-theme}";
    "Kvantum/${qt-theme}".source = "${pkgs.${qt-theme-package}}/share/Kvantum/${qt-theme}";
  }; # from https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/2 and https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/3

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
