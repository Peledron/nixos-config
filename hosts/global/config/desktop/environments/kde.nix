{ config, pkgs, callPackage, lib, ... }:
{
    # enable the xserver:
    services.xserver = {
        enable = true;
        # Enable touchpad support (enabled default in most desktopManager).
        libinput.enable = true;
        # kde:
        desktopManager = {
            plasma5 = {
                enable = true;
                # --> disable kde specific packages:
                /*
                excludePackages = with pkgs.libsForQt5; [
                    # package
                ];
                */
                # --> see https://github.com/pjones/plasma-manager for a way to declare plasma config in home-manager
            };
        };
        #set de default login session to sddm and tell it to use plasma-wayland
        displayManager = {
            defaultSession = "plasmawayland";
            sddm = {
                enable = true;
            };
        };
    };
    programs.dconf.enable = true; # better compatiblity for costum setups (gnome apps)

    # --> install kde specific packages:
    environment.systemPackages = with pkgs.libsForQt5; [
        # desktop specific
            # [kde]
            #bismuth # tiling
            sddm-kcm
    ];
    environment.variables = {
        # kde specific
        XDG_CURRENT_DESKTOP = "KDE";
        KWIN_OPENGL_INTERFACE = "egl";
        KWIN_X11_REFRESH_RATE = "120000";
        KWIN_X11_NO_SYNC_TO_VBLANK = "1";
        KWIN_X11_FORCE_SOFTWARE_VSYNC = "1";

        # wayland specific
        QT_QPA_PLATFORM=  "wayland;xcb";
        EGL_PLATFORM = "wayland";


        # qt specific
        #QT_QPA_PLATFORMTHEME = "qt5ct";
        #QT_STYLE_OVERRIDE = "kvantum";
    };
    # ---

}