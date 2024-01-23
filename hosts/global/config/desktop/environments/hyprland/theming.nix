{ config, lib, pkgs, ... }:
let 
# scripts taken from https://github.com/abdul2906/nixos-system-config/blob/main/nixos/modules/hyprland/module.nix
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = 
    let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gesettings/schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gesettings set $gnome_schema gtk-theme 'Qogir-Dark'
    '';
  };
in
{
     home.packages = with pkgs; [
        # [imported scripts]
        configure-gtk
        # -> configured through home-manager

        # [theming]
#         #nordic # application theming
        qogir-theme # gtk
        papirus-icon-theme
        gnome3.adwaita-icon-theme  # default gnome cursors

        # [qt-theming control]
        #libsForQt5.qt5ct
        #qt6Packages.qt6ct
        #libsForQt5.qtstyleplugin-kvantum
        #qt6Packages.qtstyleplugin-kvantum
        # -> not needed as we will follow the gtk theme

    ];
    qt = {
        enable = true;
        style = {
            name = "Qogir-Dark";
            package = pkgs.qogir-theme;
        };
        platformTheme = "gtk";
    };
    gtk = {
        enable = true;
        cursorTheme = {
            package = pkgs.gnome.adwaita-icon-theme;
            name = "Adwaita";
        };
        iconTheme = {
            package = pkgs.papirus-icon-theme;
            name = "Papirus-Dark";
        };
        theme = {
            package = pkgs.qogir-theme;
            name = "Qogir-Dark";
        };

    };
    home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 24;
        x11 = {
            enable = true;
            defaultCursor = "Adwaita";
        };
    };
}
