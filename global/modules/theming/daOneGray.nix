{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  theme = "da-one-gray";
  plasma6Disabled = !config.services.desktopManager.plasma6.enable;
  wallpaper = "${self}/global/modules/theming/wallpapers/painterly-forest-fantasy.png";
  icon-theme = pkgs.papirus-icon-theme;
  icon-theme-name = "Papirus-Dark";
  # it seems some kde apps have broken icons when not using breeze
  qt-icon-theme = pkgs.papirus-icon-theme;
in {
  stylix = {
    enable = true;
    autoEnable = false; # i will disable that since I want to manage most theming with homeManager
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
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
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
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
        #targets.kitty.enable = true; # I will use one of the themes in kitty itself
        #targets.fish.enable = false; # the nord theme is too low contrast with kitty to be readable
        #targets.hyprpaper.enable = lib.mkForce false; # I do not want the wallpaper to be set automatically in hyprland using this, seems this is broken for now
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
      };

      qt = lib.mkIf plasma6Disabled {
        enable = true;
        platformTheme.name = "adwaita";
        #style.name = "kvantum";
      };
    }
  ];
  environment.sessionVariables = lib.mkIf plasma6Disabled {
    # [qt theming]
    #QT_QPA_PLATFORMTHEME = "qt5ct";
    #QT_STYLE_OVERRIDE = "kvantum";
  };
}
