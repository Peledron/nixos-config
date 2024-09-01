{
  pkgs,
  system,
  self,
  ...
}: let
  cli-install = with pkgs; [
    # [shell]
    fish
    wget
    curl
    rsync
    rclone
    tree
    inetutils # package containing various network tools like traceroute
    bat # cat replacement with syntax highlighting, etc
    eza # colorfull ls, easier to read
    du-dust # du replacement, fancier
    ncdu # shows detailed diskusage (df mixed with du ig)
    fzf # fuzzy finder, faster then find
    tldr # short command explenation with examples
    bottom # system monitor, has a nicer ui and configuration then htop, though its basic mode shows less than I would like ig

    # [editor]
    micro # lightweight editor with mouse support https://micro-editor.github.io/ (also see https://github.com/hishamhm/dit as a more barebones alternative)

    # [dotfiles management] # I should define all config in nix but defining things like aliases via imperative dotfiles is easier/faster
    stow
    # [git-related]
    git-crypt
  ];
  nix-alien-install = with self.inputs.nix-alien.packages.${system}; [
    nix-alien # program to auto resolve dependencies of non-nix binaries, works in conjunction with nix-index and nix-ld
  ];
in {
  home.packages =
    cli-install
    ++ nix-alien-install;

  #==================#
  # set programs to be managed by home-manager:
  # --> program configs are within ./configs
  programs = {
    #man.generateCaches = true; # generate man-db
    nix-index = {
      enable = true; # setting this to true enables the shell integrations as well as command-not-found, which ironically makes command not found less legible cuz it adds all this fluff like .out, however the nice thing is that it uses the index provided by nix-index
    };
    nix-index-database.comma.enable = true; # enable comma integration (and comma itself)
  };
}
