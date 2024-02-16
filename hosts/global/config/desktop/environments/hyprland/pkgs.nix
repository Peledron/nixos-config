{
  config,
  pkgs,
  lib,
  system,
  input,
  ...
}: let
  # script taken from https://github.com/abdul2906/nixos-system-config/blob/main/nixos/modules/hyprland/module.nix
  /*
  dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland XDG_SESSION_TYPE=wayland  XDG_SESSION_DESKTOP=Hyprland
      systemctl --user restart pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-hyprland
    '';
  };
  */
in {
  home.packages = with pkgs; [
    # [imported scripts]
    #dbus-hyprland-environment # replaced with ./configs/hyprland.nix, using the systemd option, it does the same thing (only better)

    # [applications]
    # -> term
    libsForQt5.konsole
    # -> filemanager
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.kdegraphics-thumbnailers # thumbnails, not sure if it needed with dolphin-plugins, doesnt seem to work with hyprland
    ffmpegthumbs
    libsForQt5.kio # important for kde applications
    libsForQt5.kio-extras
    kio-fuse # fuse overlay for kio needed for network mounts/etc
    # vm client
    spicy

    # -> runner
    fuzzel
    # -> image viewer
    libsForQt5.gwenview
    haruna # video player
    # -> archive manager
    ark

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
    swayr # window switcher (alt+tab thing)
    wlogout # shutdown options
    wlr-randr # to set screensize
    #hyprpaper # -> swww and swaybg used in conjunction with waypaper is nicer, hyprpaper is nice if you want per workspace wallpapers
    hyprpicker
    swww # moving wallpapers
    waypaper # gui for wallpapers

    # -> idle/lock
    swayidle
    swaylock

    # -> brightness
    brightnessctl
    # avizo # fancy audio/brightness indicator
    wob # also indicates audio

    # -> notifications
    #swaynotificationcenter
    dunst

    # [applets]
    networkmanagerapplet

    # [audio tools]
    pamixer
    lxqt.pavucontrol-qt
    playerctl
  ];
}
