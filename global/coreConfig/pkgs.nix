# packages that are globally installed by all hosts
{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      home-manager
      # basic tools
      # [system]
      git # needs to be installed for flakes to work at sudo level
      vim # installed at system level so
      pciutils
      usbutils
      lm_sensors
      # [nix-tools]
      nix-ld # Run unpatched dynamic binaries on NixOS https://github.com/Mic92/nix-ld, very usefull for running specific software not available otherwise
      nh # simplified nix cli
      # [security]
      # doas is enabled by default in security.nix
      gnupg
      # [filesystem]
      fuse
      #cifs-utils
      s3fs
    ]
    ++ [inputs.agenix.packages."${system}".default];
  # in order to use a program with sudo you should do: program.$program.enable = true;
  # --> nix takes over management of the package, it also imports a configured module for the program
  # (see all using https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=programs)
  programs.fish = {
    enable = true;
    vendor = {
      # these are defaults, but I like to specify things
      config.enable = true;
      completions.enable = true; # autoload completions provided by other nix packages
      functions.enable = true;
    };
  };
  #documentation.man.generateCaches = true; # NixOS
  programs.nix-ld = {
    enable = true;
    #libraries = []; # there is a default set defined, you can add more here
  };
  programs.nh = {
    enable = true;
    # clean is an alternative to nix-collect-garbage
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 3";
    };
  };
  environment.variables = {
    FLAKE = "$HOME/nixos-config";
  };
}
