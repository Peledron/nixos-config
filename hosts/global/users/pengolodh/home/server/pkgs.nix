{
  config,
  lib,
  pkgs,
  system,
  imputs,
  ...
}: {
  home.packages = with pkgs; [
    # cli tools
    # [shell]
    fish
    bat # cat replacement with syntax highlighting, etc
    eza # colorfull ls, easier to read
    # [editor]
    micro
    # [dotfiles management] # I should define all config in nix but...
    stow
  ];

  #==================#
  # set programs to be managed by home-manager:
  # --> program configs are within ./configs
  programs = {
    nix-index = {
      enable = true; # setting this to true enables the shell integrations as well as command-not-found
    };
    nix-index-database.comma.enable = true; # enable comma integration
  };
}
