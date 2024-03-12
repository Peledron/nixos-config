{
  config,
  lib,
  pkgs,
  ...
}: let
  gtk-theme = "Nordic";
  gtk-theme-package = "nordic";
  qt-theme = "Utterly-Nord-Solid";
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
      # libsForQt5.qt5ct
      # kdePackages.qt6ct
      kdePackages.qtstyleplugin-kvantum
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

  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };
  /*
  home.sessionVariables = { # does not work, see ../hyprland.nix, sessionvariables need to be system level it seems
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
    };
  */
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=${qt-theme}";
    "Kvantum/${qt-theme}".source = "${pkgs.${qt-theme-package}}/share/Kvantum/${qt-theme}";
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      color_scheme_path=${pkgs.libsForQt5.qt5ct}/share/qt5ct/colors/darker.conf
      custom_palette=false
      icon_theme=Papirus-Dark
      standard_dialogs=default
      style=kvantum-dark

      [Fonts]
      fixed="UbuntuMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
      general="Ubuntu Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\rp\0\0\0\0\0\0\x10v\0\0\x3\x9c\0\0\0\0\
      0\0\0\0\0\0\x3\x5\0\0\x3/\0\0\0\x1\x2\0\0\0\a\x80\0\0\rp\0\0\0\0\0\0\x10v\0\0\x3\x9c)

      [Troubleshooting]
      force_raster_widgets=0
      ignored_applications=@Invalid()
    '';
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      color_scheme_path=${pkgs.kdePackages.qt6ct}/share/qt6ct/colors/darker.conf
      custom_palette=false
      icon_theme=Papirus-Dark
      standard_dialogs=default
      style=kvantum-dark
          
      [Fonts]
      fixed="UbuntuMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
      general="Ubuntu Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
          
      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3
          
      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x3\xb4\0\0\x5\x82\0\0\0
      \0\0\0\0\0\0\0\x2\xde\0\0\x2\x7f\0\0\0\0\x2\0\0\0\rp\0\0\0\0\0\0\0\0\0\0\x3\xb4\0\0\x5\x
      82)
          
      [Troubleshooting]
      force_raster_widgets=0
      ignored_applications=@Invalid()'';
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
# might migrate to https://github.com/SenchoPens/base16.nix or https://danth.github.io/stylix/index.html

