# make sure you use pipewire and enable ./hyprland-configs/nvidia.nix if you have that (cuz wayland specific settings)
# --> taken mostly from https://github.com/abdul2906/nixos-system-config/tree/main/nixos/modules/hyprland
{
  pkgs,
  inputs,
  mainUser,
  ...
}: {
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome
    xdg-utils
  ];
  programs = {
    /*
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-wlr;
    };
    */
    dconf.enable = true; # better compatiblity for costum setups (gnome apps)
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true; 
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.hyprland.default = ["wlr" "gtk"]; # wlr portal is less featured but actually works, both for screencasting and opening links
  };
  services = {
    blueman.enable = true; # enable blueman daemon
    gvfs.enable = true; # enable the virtual file system, so that u can see and mount local/remote disks in gtk based filemanagers (and pcmanfm-qt)
    dbus.enable = true;
    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    }; # enable gnome-keyring as some programs use it to manage secrets

    # login manager:
    greetd = {
      enable = true;
      package = pkgs.greetd;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd '${pkgs.systemd}/bin/systemd-cat ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland'";
        };
        initial_session = {
          command = "${pkgs.systemd}/bin/systemd-cat ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland &> /dev/null";
          user = "${mainUser}"; 
        };
      };
    };
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = {}; # fixes swaylock issue
  };

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
}
