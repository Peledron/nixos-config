{ config, lib, pkgs, ... }:
let
# declare some basic packages for theming, from https://nixos.wiki/wiki/Sway#Inferior_performance_compared_to_other_distributions
    # bash script to let dbus know about important env variables and
    # propagate them to relevent services run at the end of sway config
    # see
    # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
    # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
    # some user services to make sure they have the correct environment variables
    dbus-sway-environment = pkgs.writeTextFile {
        name = "dbus-sway-environment";
        destination = "/bin/dbus-sway-environment";
        executable = true;

        text = ''
            dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
            systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
            systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        '';
    };



in
{
    home.packages = with pkgs; [
        # [imported scripts]
        dbus-hyprland-environment

        # [applications]
        # -> term
        libsForQt5.konsole
        # -> filemanager
        libsForQt5.dolphin
        libsForQt5.dolphin-plugins
        # -> runner
        fuzzel
        # -> image viewer
        libsForQt5.gwenview
        haruna # video player
        # -> archive manager
        peazip

        # [sway related]
        # -> bar
        waybar

        # -> screenshots
        grim
        slurp
        grimblast
        wf-recorder # screen recording for wayland

        # -> clipboard
        wl-clipboard
        clipman

        # -> functionality
        swaybg # background setter
        autotiling-rs # enables dynamic tiling on sway
        swayr # window switcher (alt+tab thing)

        # -> idle/lock
        swayidle
        sway-audio-idle-inhibit
        swaylock

        # -> brightness
        brightnessctl
        wob # also indicates audio

        # -> notifications
        swaynotificationcenter

        # [applets]
        networkmanagerapplet
        blueman

        # [audio tools]
        pamixer
        pavucontrol
        playerctl

        #

    ];
    services.blueman.enable = true;
}
