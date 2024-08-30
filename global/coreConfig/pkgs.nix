# packages that are globally installed by all hosts
{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      home-manager
      # [system]
      git # needs to be installed for flakes to work at sudo level
      nano # installed at system level so i can edit files when using root account
    ]
    ++ [inputs.agenix.packages."${system}".default];
  # in order to use a program with sudo you should do: program.$program.enable = true;
  # --> nix takes over management of the package, it also imports a configured module for the program
  # (see all using https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=programs)
  programs.fish = {
    enable = true; # vendor completions are missing for system tools otherwise
    vendor = {
      # these are defaults, but I like to specify things
      config.enable = true;
      completions.enable = true; # autoload completions provided by other nix packages
      functions.enable = true;
    };
  };
  #documentation.man.generateCaches = true; # slows things down but is needed for fish completions to work I think
  programs.nix-ld = {
    # Run unpatched dynamic binaries on NixOS https://github.com/Mic92/nix-ld, very usefull for running specific software not available otherwise
    enable = true;
    #libraries = []; # there is a default set defined, you can add more here
  };
  programs.nh = {
    enable = true;
    # clean is an alternative to nix-collect-garbage
    clean = {
      enable = true;
      extraArgs = "--keep-since 31d --keep 50";
    };
  };
  environment.variables = {
    FLAKE = "$HOME/nixos-config"; # needed for nh
  };
}
