# make sure you use pipewire and enable ./hyprland-configs/nvidia.nix if you have that (cuz wayland specific settings)
# --> taken mostly from https://github.com/abdul2906/nixos-system-config/tree/main/nixos/modules/hyprland
{ config, pkgs, lib, ... }:

{
  # hyprland:
  programs.hyprland = { # see https://wiki.hyprland.org/Nix/Options-Overrides/
    enable = true;
    xwayland = { # add xwayland support
      enable = true;
      hidpi = true; # allow for hidpi scaling on xwayland 
    };
  };
  # ---

  # deps and env
  environment.systemPackages = with pkgs; [
    # [basic deps]
    wayland
    glib 
    ffmpeg

    # [polkit] 
    # --> used for password storage of some applications
    polkit_gnome
    # [bluetooth]
    blueman
  ];
  services.blueman.enable = true; # enable blueman daemon

  # enable polkit 
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
      };
    };
  };
  
  # --> see ./hyprland/pkgs.nix for installed programs and themes


  # gtk addons:
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
    };
  };


  # --> lightdm
  /*
  services.xserver = {
      enable = true;

      displayManager = {
        lightdm = {
          enable = true;
          greeters.gtk = {
            enable = true;
            #theme.name = "qogir";
          };
        };
        defaultSession = "hyprland";
      };
  };
  */
  # ---

  # flatpak support: (already included in hyprland nix module)
  /*
  xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      # gtkUsePortal = true; # depricated
  };
  */
  # ---

}
