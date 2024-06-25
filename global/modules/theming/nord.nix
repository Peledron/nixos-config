{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  wallpaper = "${self}/global/modules/theming/wallpapers/painterly-forest-fantasy.png";
in {
  stylix = {
    enable = true;
    autoEnable = false; # i will disable that since I want to manage most theming with homeManager
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    image = "${wallpaper}";
    targets = {
      # enable boot theming
      grub.enable = true;
      plymouth = {
        enable = true; # the logo is nix by default and animated
        #logo = pkgs.nixos-bgrt-plymouth;
        logoAnimated = true;
      };
      # pre-graphical tty
      console.enable = true; # theming for the linux kernel console
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
      };
      home.packages = with pkgs; [
        nordic
        papirus-icon-theme
      ];
      qt = {
        enable = true;
        platformTheme = "gtk";
        style.name = "Adwaita";
      };
      gtk.iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      programs.fuzzel.settings.main.icon-theme = "Papirus-Dark";
    }
  ];
}
