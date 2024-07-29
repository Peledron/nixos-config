{
  config,
  lib,
  pkgs,
  inputs,
  system,
  self,
  ...
}: {
  system.stateVersion = "23.11"; # initial system state
  #nixpkgs.config.allowunfree = true; # allow propietary software --> not needed when inheriting pkgs with allowfree = true; in flake
  # nix specific settings:
  nix = {
    channel.enable = lib.mkForce true;
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
    /*
    # enable garbage collection on the nix-store (cleans old system versions)
    gc = {
      automatic = true; # enabling automatic without the lines below will run it daily by default (not really safe unless snapshots are used)
      persistent = true; # save the timer state, so that it continues when the system was rebooted
      dates = "weekly"; # run once a week
      options = "--delete-older-than 7d"; # set gc to delete nix-store generations of the previous week once a week as a compromise
      randomizedDelaySec = "45min"; # randomize the trigger time within this timeframe
    };
    */
    # -> gc is replaced by programs.nh.clean as thats a better solution
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
}
