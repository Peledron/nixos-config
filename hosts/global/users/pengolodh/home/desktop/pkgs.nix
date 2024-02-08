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
    #steam # install via flatpak, less issues that way... + propietary apps should be installed via flatpak anyway
    #heroic # install via flatpak
    # [chat]
    vesktop # open-source discord client, with vencord plugin/theme support, installing it via this instead of flatpak should fix some annoyances (screensharing)?
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
    # [editors]
    vscodium-fhs # fhs variant allows for plugins

    # cli tools
    # [shell]
    fish
    bat # cat replacement with syntax highlighting, etc
    eza # colorfull ls, easier to read
    # [editor]
    neovim
    # [dotfiles management] # I should define all config in nix but defining things like aliases via imperative dotfiles is easier/faster
    stow
  ];

  #==================#
  # set programs to be managed by home-manager:
  # --> program configs are within ./configs
  #programs.firefox.enable = true;
}
