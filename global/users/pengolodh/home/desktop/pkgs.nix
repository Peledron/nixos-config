{pkgs, ...}: let
  tools-install = with pkgs.unstable; [
    # [wine]
    wineWowPackages.staging
    winetricks
    # [cli]
  ];
  gui-install = with pkgs; [
    # [networking]
    unstable.winbox # mikrotik router management GUI

    # [remote desktop]
    remmina # spice,rdp and vnc client
    freerdp3 # im using this for winapps, see https://nowsci.com/#/winapps/?id=winapps-for-linux

    # [security]
    gnome.seahorse
    eid-mw # belgium eid middleware
    #mullvad-vpn

    # [backup-solution]
    vorta

    # [creative]
    unstable.blender-hip # blender with the hip library added to it, does not matter for nvidia machines, seems to crash for some reason...
    krita

    # [gaming]
    #heroic # -> i am using the flatpak
    unstable.prismlauncher
    unstable.glfw-wayland-minecraft

    # [chat]
    unstable.vesktop

    # [steaming]
    #obs-studio # -> if I enable it here it collides with the unwrapped version provided by programs.obs in ./configs/obs.nix
    easyeffects
    entangle # tethered camera control

    # [pdf]
    kdePackages.okular

    # [documents]
    libreoffice-qt
    hunspell # spellcheck program for libreoffice, see hunspell-dict-install for the installed dictionaries

    # [mail]
    thunderbird

    # [torrent client]
    qbittorrent

    # [file management]
    #rclone-browser # qt rclone frontend, might not work, repo seems to be dead but author seems to be alive so who knows
    freefilesync # syncronisation software
    nextcloud-client
  ];
  dev-install = with pkgs; [
    # [environment]
    boxbuddy # gui for distrobox (requires /global/modules/virt/podman.nix to be included)

    # [programming langs]
    #python3
    #unstable.go
    #openjdk
    #gcc
    #unstable.rustc

    # [programming tools]
    meld # qt diff tool
    cargo
    pipx

    # [build tools]
    #gnumake
    #cmake
    #meson
    #pkg-config

    # [nix-tools]
    alejandra # .nix auto-formatter
    nil # nix language server

    # [editors]
    unstable.vscodium-fhs # fhs variant allows for plugins
  ];

  gstreamer-install = with pkgs.gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-bad
    gst-vaapi
  ];
  hunspell-dict-install = with pkgs.hunspellDicts; [
    en_US-large
    en_GB-large
    nl_NL
    fr-any
  ];
in {
  home.packages =
    tools-install
    ++ gui-install
    ++ dev-install
    ++ gstreamer-install
    ++ hunspell-dict-install; # see https://stackoverflow.com/a/53692127 for an example of why I did it this way

  #==================#
  # set programs to be managed by home-manager:
  # --> program configs are within ./configs
  #programs.firefox.enable = true;
}
