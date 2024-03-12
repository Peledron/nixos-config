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
  # }; # -> moved to hyprland/home.nix for the rest of the options

  # deps and env
  environment.systemPackages = with pkgs; [
    # [basic deps]
    wayland
    xwayland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    hyprland-protocols

    qt6.qtwayland

    glib
    ffmpeg
    libheif

    # [polkit]
    # --> used to elevate certain programs
    lxqt.lxqt-policykit
    # [bluetooth]
    blueman

    xdg-utils
  ];
  services.blueman.enable = true; # enable blueman daemon
  services.gvfs.enable = true; # enable the virtual file system, so that u can see and mount local/remote disks in gtk based filemanagers (and pcmanfm-qt)

  # enable polkit
  security.polkit.enable = true;
  systemd = {
    user.services.lxqt-policykit-agent = {
      description = "lxqt-policykit-agent";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lxqt.lxqt-policykit}/libexec/lxqt-policykit-agent";
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
    config = {
      Hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };
  # ---
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
  }; # something is broken in qt theming if done by hone-manager sessionvariables, seems that this fixed it
}
