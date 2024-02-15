{
  config,
  lib,
  pkgs,
  system,
  imputs,
  ...
}: {
  home.packages = with pkgs; [
    # gui applications
    # [browsers]
    # [backup-solution]
    vorta
    # [creative]
    blender-hip # blender with the hip library added to it, does not matter for nvidia machines, seems to crash for some reason...
    krita
    # [gaming]
    #heroic # install via flatpak

    # [chat]
    vesktop # open-source discord client, with vencord plugin/theme support, installing it via this instead of flatpak should fix some annoyances like links not opening.
    # [steaming]
    obs-studio
    obs-studio-plugins.obs-vaapi
    obs-studio-plugins.obs-pipewire-audio-capture
    # [pdf]
    libsForQt5.okular
    # [mail]
    thunderbird
    # [torrent client]
    qbittorrent

    # development
    # [programming langs]
    python3
    go
    openjdk
    pipx
    # [programming tools]
    alejandra # .nix auto-formatter
    meld # qt diff tool
    direnv # per folder environment profiles
    exercism # learning programming exercism.io
    # [editors]
    vscodium-fhs # fhs variant allows for plugins

    # cli tools
    # [shell]
    fish
    bat # cat replacement with syntax highlighting, etc
    eza # colorfull ls, easier to read
    zoxide # cd replacement, allows for cd-ing into subdirectories, etc..
    du-dust # du replacement, fancier
    # [editor]
    neovim
    dit # lightweight editor with mouse support https://github.com/hishamhm/dit
    # [dotfiles management] # I should define all config in nix but defining things like aliases via imperative dotfiles is easier/faster
    stow

    # wine
    wineWowPackages.staging
    winetricks
  ];

  #==================#
  # set programs to be managed by home-manager:
  # --> program configs are within ./configs
  #programs.firefox.enable = true;
  programs.zoxide.enable = true; # enabling this so that fish integration is enabled
}
