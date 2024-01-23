{ config, pkgs, lib, system, input, ... }:
let 
# 2 scripts taken from https://github.com/abdul2906/nixos-system-config/blob/main/nixos/modules/hyprland/module.nix
 dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-hyprland
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-hyprland
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
        swayr # window switcher (alt+tab thing)
        wlogout # shutdown options
        wlr-randr # to set screensize

        # -> idle/lock
        swayidle
        waylock

        # -> brightness
        brightnessctl
        # avizo # fancy audio indicator
        wob # also indicates audio

        # -> notifications
        swaynotificationcenter

        # [applets]
        networkmanagerapplet

        # [audio tools]
        pamixer
        pavucontrol
        playerctl

    ];
}
