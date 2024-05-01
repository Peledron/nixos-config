{
  config,
  lib,
  pkgs,
  system,
  inputs,
  self,
  ...
}: let
  tools-install = with pkgs; [
    # [wine]
    wineWowPackages.staging
    winetricks
  ];
  gui-install = with pkgs; [
    # [networking]
    winbox # mikrotik router management GUI
    remmina # spice,rdp and vnc client

    # [security]
    kdePackages.kleopatra

    # [backup-solution]
    vorta

    # [creative]
    blender-hip # blender with the hip library added to it, does not matter for nvidia machines, seems to crash for some reason...
    krita

    # [gaming]
    #heroic # -> i am using the flatpak
    prismlauncher

    # [chat]
    # armcord # -> i am using the flatpak

    # [steaming]
    #obs-studio # -> if I enable it here it collides with the unwrapped version provided by programs.obs in ./configs/obs.nix
    easyeffects

    # [pdf]
    kdePackages.okular

    # [documents]
    libreoffice-qt
    hunspell # spellcheck program for libreoffice, see hunspell-dict-install for the installed dictionaries

    # [mail]
    thunderbird

    # [torrent client]
    qbittorrent

    # [download tool]
    persepolis

    # [file management]
    #rclone-browser # qt rclone frontend, might not work, repo seems to be dead but author seems to be alive so who knows
  ];
  dev-install = with pkgs; [
    # [programming langs]
    python3
    go
    openjdk
    gcc
    rustc

    # [programming tools]
    meld # qt diff tool
    direnv # per folder environment profiles
    cargo
    pipx

    # [build tools]
    gnumake
    cmake
    meson
    pkg-config

    # [nix-tools]
    alejandra # .nix auto-formatter
    #nix-index # https://github.com/nix-community/nix-index --> this allows to find what binaries belong to what packages, also see https://github.com/nix-community/nix-index-database
    #comma # tool to make using nix-shell faster, you can do ", program" and it will run that program, regardless if it is installed or not, if installed here it conflicts with nix-index-database comma
    #nix-alien # -> see below, needs to be installed via flake

    # [editors]
    vscodium-fhs # fhs variant allows for plugins
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
