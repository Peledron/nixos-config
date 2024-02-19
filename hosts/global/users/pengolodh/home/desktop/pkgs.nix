{
  config,
  lib,
  pkgs,
  system,
  inputs,
  self,
  ...
}: let
  nix-alien-install = with self.inputs.nix-alien.packages.${system}; [
    nix-alien # program to auto resolve dependencies of non-nix binaries, works in conjunction with nix-index and nix-ld
  ];
  gstreamer-install = with pkgs.gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-bad
    gst-vaapi
  ];
in {
  home.packages = with pkgs;
    [
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
      #obs-studio # -> if I enable it here it collides with the unwrapped version provided by programs.obs in ./configs/obs.nix

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
      gcc

      # [programming tools]
      meld # qt diff tool
      direnv # per folder environment profiles
      exercism # learning programming exercism.io
      pipx
      # [nix-tools]
      alejandra # .nix auto-formatter
      #nix-index # https://github.com/nix-community/nix-index --> this allows to find what binaries belong to what packages, also see https://github.com/nix-community/nix-index-database
      #comma # tool to make using nix-shell faster, you can do ", program" and it will run that program, regardless if it is installed or not, if installed here it conflicts with nix-index-database comma
      #nix-alien # -> see below, needs to be installed via flake
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
      micro # lightweight editor with mouse support https://micro-editor.github.io/ (also see https://github.com/hishamhm/dit as a more barebones alternative)
      # [dotfiles management] # I should define all config in nix but defining things like aliases via imperative dotfiles is easier/faster
      stow
      # [filesystem]
      s3fs
      # wine
      wineWowPackages.staging
      winetricks
    ]
    ++ nix-alien-install
    ++ gstreamer-install; # see https://stackoverflow.com/a/53692127 for an example of why I did it this way

  #==================#
  # set programs to be managed by home-manager:
  # --> program configs are within ./configs
  #programs.firefox.enable = true;
  programs = {
    zoxide.enable = true; # enabling this so that fish integration is enabled

    nix-index = {
      enable = true; # setting this to true enables the shell integrations as well as command-not-found
    };
    nix-index-database.comma.enable = true; # enable comma integration
  };
}
