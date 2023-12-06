{ config, lib, pkgs, ... }:
let
    # currently, there is some friction between sway and gtk:
    # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
    # the suggested way to set gtk settings is with gsettings
    # for gsettings to work, we need to tell it where the schemas are
    # using the XDG_DATA_DIR environment variable
    # run at the end of sway config
    configure-gtk = pkgs.writeTextFile {
        name = "configure-gtk";
        destination = "/bin/configure-gtk";
        executable = true;
        text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
        in ''
            export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
            gnome_schema=org.gnome.desktop.interface
            gsettings set $gnome_schema gtk-theme 'Qogir-dark'
        '';
    };
in
{
     home.packages = with pkgs; [
        # [imported scripts]
        #configure-gtk
        # -> configured through home-manager

        # [theming]
        #nordic # application theming
        qogir-kde # qt
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
            package = pkgs.qogir-kde;
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
