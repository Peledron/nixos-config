{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  plasma6Disabled = !config.services.desktopManager.plasma6.enable;
  wallpaper = "${self}/global/modules/theming/wallpapers/painterly-forest-fantasy.png";
  icon-theme = pkgs.papirus-icon-theme;
  icon-theme-name = "Papirus-Dark";
  qt-theme = pkgs.nordic;
  qt-theme-name = "Nordic";
  # it seems some kde apps have broken icons when not using breeze
  qt-icon-theme = pkgs.papirus-icon-theme;
  qt-icon-theme-name = "Papirus-Dark";
in {
  stylix = {
    enable = true;
    autoEnable = false; # i will disable that since I want to manage most theming with homeManager
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    image = "${wallpaper}";
    targets = {
      # enable boot theming
      grub.enable = lib.mkIf config.boot.loader.grub.enable true;
      plymouth = {
        enable = true; # the logo is nix by default and animated
        #logo = pkgs.nixos-bgrt-plymouth;
        logoAnimated = true;
      };
      # pre-graphical tty
      console.enable = false; # theming for the linux kernel console
      kmscon.enable = true; # kmscon is the standard TTY of linux

      # nixos-logo theming
      nixos-icons.enable = true; # no idea what this does
    };
  };
  home-manager.sharedModules = [
    {
      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
        polarity = "dark";
        cursor = {
          package = pkgs.gnome.adwaita-icon-theme;
          name = "Adwaita";
          size = 24;
        };
        image = "${wallpaper}";
        opacity = {
          applications = 1.0;
          terminal = 0.7;
          desktop = 1.0;
          popups = 1.0;
        };
        targets.kitty.enable = false; # I will use one of the themes in kitty itself
        targets.fish.enable = false; # the nord theme is too low contrast with kitty to be readable
        targets.hyprpaper.enable = false; # I do not want the wallpaper to be set automatically in hyprland using this
        targets.kde.enable = lib.mkIf plasma6Disabled false;
      };
      home.packages = [
        icon-theme
        qt-icon-theme
      ];
      gtk.iconTheme = {
        name = "${icon-theme-name}";
        package = icon-theme;
      };

      programs = {
        fuzzel.settings.main.icon-theme = "${icon-theme-name}";
        kitty = {
          theme = "Nord"; # can be any from https://github.com/kovidgoyal/kitty-themes/tree/master/themes
          settings.background_opacity = "0.7";
        };
      };

      qt = lib.mkIf plasma6Disabled {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
      };

      xdg.configFile = lib.mkIf plasma6Disabled {
        "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=${qt-theme-name}";
        "Kvantum/${qt-theme-name}".source = "${qt-theme}/share/Kvantum/${qt-theme-name}";
        "qt5ct/qt5ct.conf".text = ''
          [Appearance]
          color_scheme_path=${pkgs.libsForQt5.qt5ct}/share/qt5ct/colors/darker.conf
          custom_palette=false
          icon_theme=${qt-icon-theme-name}
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
          icon_theme=${qt-icon-theme-name}
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
    }
  ];
  environment.sessionVariables = lib.mkIf plasma6Disabled {
    # [qt theming]
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
