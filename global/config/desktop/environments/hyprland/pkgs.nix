{
  config,
  pkgs,
  lib,
  system,
  input,
  ...
}: {
  home.packages = with pkgs; [
    # [applications]
    # -> term
    kitty
    # -> filemanager
    # kdePackages.dolphin
    # kdePackages.kdegraphics-thumbnailers # thumbnails, not sure if it needed with dolphin-plugins, doesnt seem to work with hyprland
    # # ffmpegthumbs
    # kdePackages.kio # important for kde applications
    # kdePackages.kio-extras
    # kio-fuse # fuse overlay for kio needed for network mounts/etc
    # kdePackages.kdenetwork-filesharing
    #lxqt.pcmanfm-qt # uses gvfs for folder mounts
    #lxqt.lxqt-menu-data # add installed applications to the right click menu when selecting "open with"
    # tumb
    #xfce.tumbler
    cinnamon.nemo-with-extensions
    webp-pixbuf-loader # webp
    poppler # pdf tumbs
    ffmpegthumbnailer
    libgsf

    # vm client
    spicy

    # -> runner
    fuzzel
    # -> image viewer
    shotwell
    celluloid # video player, gtk frontend for mpv

    # calculator
    qalculate-gtk

    # archive manager
    #lxqt.lxqt-archiver
    gnome.file-roller
    # programs to allow for unzipping
    unzrip
    p7zip
    unrar
    lzop
    lrzip

    # [hypr related]
    # -> bar
    # waybar # -> package enabled via config as unstable, to allow for hyprland integration

    # -> screenshots
    grim
    slurp
    grimblast
    wf-recorder # screen recording for wayland

    # -> clipboard
    wl-clipboard
    wl-clipboard-x11 # x11 wrapper for wl-clipboard
    #clipman
    cliphist # -> is a better alternative to clipman cuz it supports images and such

    # -> functionality
    #pyprland # plugin package for hyprland, contains a lot of functionality https://github.com/hyprland-community/pyprland (and you dont need to sideload flakes into hyprland config)
    #hyprnome # gnome like workspace switching
    wlogout # shutdown options
    wlr-randr # to set screensize
    #hyprpaper # -> swww and swaybg used in conjunction with waypaper is nicer, hyprpaper is nice if you want per workspace wallpapers
    hyprpicker # color picker for hyprland
    swww # moving wallpapers
    waypaper # gui for wallpapers

    # -> idle/lock
    swayidle
    swaylock
    #hyprlock

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
    pamixer # used to bind to volume keys in hyprland
    myxer # ui for pulseaudio
    playerctl # used to bind media functions to media keys in hyprland
  ];
}
