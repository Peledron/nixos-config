{ config, pkgs, lib, ... }:

{
    # enable sway window manager
    programs.sway = {
        enable = true;
        #package = pkgs.swayfx;
        wrapperFeatures.gtk = true;
    };
    # install base packages
    environment.systemPackages = with pkgs; [
        # [basic deps]
        wayland
        glib
        ffmpeg
        xdg-utils

        # [polkit]
        # --> used for password storage of some applications
        polkit_gnome
    ];

    security = {
        polkit.enable = true;
        pam = {
            services.swaylock = {}; # fix swaylock problem of password not working
            loginLimits = [
                # allow realtime priority to be set for programs running in the user group
                { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
            ];
        };
    };
    # enable gnome-keyring as some programs use it to manage secrets
    services.gnome = {
        glib-networking.enable = true;
        gnome-keyring.enable = true;
    };
    # create the systemd service for the authentication agent
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

    services.dbus.enable = true;
    programs.dconf.enable = true; # better compatiblity for costum setups (gnome apps)

    # flatpak portals
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        # gtk portal needed to make gtk apps happy
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };


    # login manager (greetd)
    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.sway}/bin/sway";
            };
        };
    };
}
