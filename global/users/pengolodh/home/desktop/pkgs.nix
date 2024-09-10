{pkgs, ...}: let
  tools-install = with pkgs; [
    # [wine]
    unstable.wineWowPackages.staging
    winetricks
    # [cli]
    freerdp3 # im using this for winapps, see https://nowsci.com/#/winapps/?id=winapps-for-linux
  ];
  gui-install = with pkgs; [
    # [networking]
    unstable.winbox # mikrotik router management GUI

    # [remote desktop]
    remmina # spice,rdp and vnc client

    # [security]
    eid-mw # belgium eid middleware

    # [backup-solution]
    vorta
    # or pikabackup
    # [torrenting]
    qbittorrent
    # [chat]
    vesktop

    # [steaming]
    easyeffects
    entangle # tethered camera control
    # obs is installed via programs.obs

    # [mail]
    thunderbird
    # [note-taking]
    qownnotes
    # [file management]
    #rclone-browser # qt rclone frontend, might not work, repo seems to be dead but author seems to be alive so who knows
    freefilesync # syncronisation software
    nextcloud-client
  ];
  dev-install = with pkgs; [
    # [environment]
    boxbuddy # gui for distrobox (requires /global/modules/virt/podman.nix to be included)

    # [programming langs]
    python3
    #go
    #openjdk
    #gcc
    rustc

    # [programming tools]
    meld # qt diff tool
    cargo
    pipx
    rust-analyzer # rust code lsp

    # [build tools]
    #gnumake
    #cmake
    #meson
    #pkg-config

    # [nix-tools]
    alejandra # .nix auto-formatter
    nil # nix language server
  ];
  graphics-install = with pkgs; [
    # it is recommened to use the same pkgs version as the graphics driver, aka pkgs.unstable or pkgs (which is based on stable)
    # [gaming]
    #heroic # -> i am using the flatpak
    prismlauncher
    glfw-wayland-minecraft
    # [creative]
    blender-hip # blender with the hip library added to it, does not matter for nvidia machines, seems to crash for some reason...
    krita
  ];
  gstreamer-install = with pkgs.gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-bad
    gst-vaapi
  ];
  hunspell-install = with pkgs; [
    # spellcheck program for libreoffice and others
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.en_GB-large
    hunspellDicts.nl_NL
    hunspellDicts.fr-any
  ];
in {
  home.packages =
    tools-install
    ++ gui-install
    ++ graphics-install
    ++ dev-install
    ++ gstreamer-install
    ++ hunspell-install;
  # see https://stackoverflow.com/a/53692127 for an example of why I did it this way
}
