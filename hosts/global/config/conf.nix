{ config, lib, pkgs, inputs, system, self, ... }:
{   
    imports = 
        (import ./core)
    ; # --> the [(import file.nix)] ++ (import ./folder) imports the things seperatly, this prevents errors related to nested imports
    
    #nixpkgs.config.allowunfree = true; # allow propietary software --> not needed when inheriting pkgs with allowfree = true; in flake
    
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

        # enable garbage collection on the nix-store (cleans old system versions)
        gc = {
            automatic = true; # enabling automatic without the lines below will run it daily by default (not really safe unless snapshots are used)
            dates = "weekly";
            options = "--delete-older-than 7d";
            # set gc to delete nix-store generations of the previous week once a week as a compromise
        };
        # ---

        # add other nix settings:
        settings = {
            #enable deduplication on the nix-store:
            # --> is generally safe, note that it will take up a bit of cpu and io recourses so disable it if your pc is too slow to handle it (if you are experience io-delay or high cpu usage)
            auto-optimise-store = true;
            # ---

            # set usres as trusted (@group allows entire group )
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
        #channel = "https://nixos.org/channels/nixos-unstable"; # --> not needed with flakes?
        flake = self.outPath;
        flags = [
            "--recreate-lock-file"
            "--no-write-lock-file"
            "-L" # print build logs
        ];
        dates = "daily";
    };
}
