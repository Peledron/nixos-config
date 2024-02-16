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
    # add the hyprland cachix, otherwise it needs to compile
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  # }; # see hyprland/home.nix for the rest of the options, it needs to be enabled here to allow it to load on boot, otherwise it lacks permissions to access things like video

  # deps and env
  environment.systemPackages = with pkgs; [
    # [basic deps]
    wayland
    xwayland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    qt5.qtwayland
    qt6.qtwayland

    glib
    ffmpeg
    libheif

    # [polkit]
    # --> used for password storage of some applications
    libsForQt5.polkit-kde-agent
    # [bluetooth]
    blueman
  ];
  services.blueman.enable = true; # enable blueman daemon
  services.gvfs.enable = true; # enable the virtual file system, so that u can see and mount local/remote disks in dolphin and such

  # enable polkit
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
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
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.hyprland}/bin/Hyprland";
      };
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "pengolodh"; # not really config independant, but...
      }; # auto-login for user pengolodh
    };
  };

  # flatpak support: (already included in hyprland nix module)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  # ---
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
  }; # something is broken in qt theming if done by hone-manager sessionvariables, seems that this fixed it
}
