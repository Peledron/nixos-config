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
    blender-hip # blender with the hip library added to it, does not matter for nvidia machines
    krita
    # [gaming]
    #steam # install via flatpak, less issues that way...
    #heroic # install via flatpak

    # development
    # [programming langs]
    python3
    go
    openjdk
    # [programming tools]
    alejandra # nix-formatter
    meld # diff tool

    # [editors]
    vscodium-fhs

    # [pdf]
    libsForQt5.okular

    # [mail]
    thunderbird

    # [torrent client]
    qbittorrent

    # cli tools
    # [shell]
    fish
    bat # cat replacement with syntax highlighting, etc
    eza # colorfull ls, easier to read
    # [editor]
    neovim
    # [dotfiles management] # I should define all config in nix but...
    stow
  ];

  #==================#
  # set programs to be managed by home-manager:
  # --> program configs are within ./configs
  #programs.firefox.enable = true;
}
