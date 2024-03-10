{
  config,
  lib,
  pkgs,
  inputs,
  system,
  self,
  ...
}: {
  imports =
    import ./core; # --> the [(import file.nix)] ++ (import ./folder) imports the things seperatly, this prevents errors related to nested imports

  #nixpkgs.config.allowunfree = true; # allow propietary software --> not needed when inheriting pkgs with allowfree = true; in flake
  system.stateVersion = "23.11"; # initial system state
  # nix specific settings:
  nix = {
    # enable flakes so we can easily update the nixos config from a github repo
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
    # ---
    optimise = {
      automatic = true;
      dates = ["daily"];
    };
    # enable garbage collection on the nix-store (cleans old system versions)
    gc = {
      automatic = true; # enabling automatic without the lines below will run it daily by default (not really safe unless snapshots are used)
      persistent = true; # save the timer state, so that it continues when the system was rebooted
      dates = "weekly"; # run once a week
      options = "--delete-older-than 7d"; # set gc to delete nix-store generations of the previous week once a week as a compromise
      randomizedDelaySec = "45min"; # randomize the trigger time within this timeframe
    };
    # ---

    # add other nix settings:
    settings = {
      #enable deduplication on the nix-store:
      # --> is generally safe, note that it will take up a bit of cpu and io recourses so disable it if your pc is too slow to handle it (if you are experience io-delay or high cpu usage)
      auto-optimise-store = true;
      # ---

      # set users as trusted to run nix commands (@group allows entire group)
      trusted-users = [
        "@wheel"
      ];
    };
    # ---
  };
  # ---

  # enable autoupgrade (runs every day)
  system.autoUpgrade = {
    enable = true;
    #allowReboot = true;
    #channel = "https://nixos.org/channels/nixos-unstable"; # --> not needed with flakes channels are declared as input
    flake = self.outPath;
    flags = [
      "-L" # print build logs
      "--recreate-lock-file"
      "--no-write-lock-file"
      "--update-input"
      "nixpkgs"
      # -> note that flags need to be in a correct order, the resulting command is nixos-rebuild switch --flag1 --flag2 --... --flake {self} --update 
    ];
    dates = "daily";
    randomizedDelaySec = "15min";
  };
}
