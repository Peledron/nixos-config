{ config, lib, pkgs, system, imputs, ... }:
{
    home.sessionVariables = rec {
        #[qt]
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # enables automatic scaling based on ppi of monitor
        #[gtk]
        GDK_BACKEND = "wayland,x11";
        #[wayland]
        EGL_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        NIXOS_OZONE_WL = "1"; # Hint Electon apps to use wayland
        
    };
}