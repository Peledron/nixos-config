# packages that are globally installed by all hosts
{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    home-manager
    # ---
    # basic tools
    # [system]
    wget
    curl
    rsync
    rclone
    htop
    tldr
    tree
    killall
    pciutils
    usbutils
    lm_sensors
    powertop
    # [nix-tools]
    nix-ld # Run unpatched dynamic binaries on NixOS https://github.com/Mic92/nix-ld, very usefull for running specific software not available otherwise
    # [git+related]
    git
    git-crypt
    sops
    # [security]
    # doas is enabled by default in security.nix
    gnupg
    fail2ban
    # filesystem
    fuse
    cifs-utils
    s3fs
    # [general-util]
    ncdu # shows detailed diskusage
  ];
  # in order to use a program with sudo you should do: program.$program.enable = true;
  # --> nix takes over management of the package, it also imports a configured module for the program
  # (see all using https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=programs)
  programs.fish.vendor.completions.enable = true; # autoload completions provided by other nix packages
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.nix-ld = {
    enable = true;
    #libraries = []; # there is a default set defined, you can add more here
  };
}
