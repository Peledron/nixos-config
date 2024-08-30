{...}: {
  home.sessionVariables = {
    #[qt]
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # enables automatic scaling based on ppi of monitor
    #[gtk]
    GDK_BACKEND = "wayland,x11";
    GTK_USE_PORTAL = "1"; # tells gtk applications to use the xdg portal app
    #[wayland]
    NIXOS_OZONE_WL = "1"; # Hint Electon apps to use wayland
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    EGL_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
