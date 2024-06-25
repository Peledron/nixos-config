# make sure you use pipewire and enable ./hyprland-configs/nvidia.nix if you have that (cuz wayland specific settings)
# --> taken mostly from https://github.com/abdul2906/nixos-system-config/tree/main/nixos/modules/hyprland
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  #programs.hyprland.enable = true;
  # deps and env

  environment.systemPackages = with pkgs.unstable; [
    # deps
    xwayland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # [polkit]
    # --> used to elevate certain programs
    polkit_gnome

    xdg-utils
  ];
  services.blueman.enable = true; # enable blueman daemon
  services.gvfs.enable = true; # enable the virtual file system, so that u can see and mount local/remote disks in gtk based filemanagers (and pcmanfm-qt)

  # enable polkit
  security.polkit.enable = true;
  systemd = {
    user.services.gnome-policykit-agent = {
      description = "gnome-policykit-agent";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  security.pam.services.swaylock = {}; # fixes swaylock issue
  # --> see ./hyprland/pkgs.nix for installed programs and themes

  # gtk addons:mounting
  services = {
    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    }; # enable gnome-keyring as some programs use it to manage secrets
  };
  services.dbus.enable = true;
  programs.dconf.enable = true; # better compatiblity for costum setups (gnome apps)
  # ---

  # login manager:
  # --> greetd (needs user value so not really usable)

  services.greetd = {
    enable = true;
    package = pkgs.greetd;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
      };
      initial_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland &> /dev/null";
        user = "pengolodh"; # not really config independant, but...
      }; # auto-login for user pengolodh
    };
  };

  # flatpak support: (already included in hyprland nix module)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    # config = {
    #   Hyprland = {
    #     default = [
    #       "hyprland"
    #       "gtk"
    #     ];
    #   };
    #};
  };
  # ---
  environment.sessionVariables = {
    # [qt theming]
    #QT_QPA_PLATFORMTHEME = "qt6ct";
    #QT_STYLE_OVERRIDE = "kvantum";
    # [qt]
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # enables automatic scaling based on ppi of monitor
    # [gtk]
    GDK_BACKEND = "wayland,x11";
    GTK_USE_PORTAL = "1"; # tells gtk applications to use the xdg portal app
    # [wayland]
    EGL_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1"; # Hint Electon apps to use wayland
    MOZ_ENABLE_WAYLAND = "1";
    # [hyprland]
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  }; # something is broken in qt theming if done by hone-manager sessionvariables, seems that this fixed it
}
