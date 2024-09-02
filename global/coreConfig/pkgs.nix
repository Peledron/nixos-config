# packages that are globally installed by all hosts
{
  pkgs,
  inputs,
  lib,
  ...
}: {
  environment.defaultPackages = lib.mkForce []; # remove default packages
  environment.systemPackages = with pkgs;
    [
      home-manager
      # [system]
      git # needs to be installed for flakes to work at sudo level
      nano # installed at system level so i can edit files when using root account
    ]
    ++ [inputs.agenix.packages."${system}".default];

  #documentation.man.generateCaches = true; # slows things down but is needed for fish completions to work I think
  /*
    programs.nix-ld = {
    # Run unpatched dynamic binaries on NixOS https://github.com/Mic92/nix-ld, very usefull for running specific software not available otherwise
    enable = true;
    #libraries = []; # there is a default set defined, you can add more here
  };
  */
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
