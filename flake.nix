{
    description = "defines configuration.nix used by different hosts";
    #url = "https://gitlab.com/pengolodh/nixos-config";
    #rev = "main";
    inputs = {
        # main nix repo
        nixpkgs = {
            url = "github:nixos/nixpkgs/nixos-unstable"; # change to whatever version, as home-manager is used, unstable is recommended
        };
        # Nix User Repo
        nur = {
            url = "github:nix-community/NUR"; 
        }; 
        # home-manager
        homeMan = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs"; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
        };
        # disko, auto disk partitioning tool using nix config... its perfect to replace scripts/prepare.sh (most of it at least)
        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland.url = "github:hyprwm/Hyprland";
        impermanence.url = "github:nix-community/impermanence";
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # plasma-manager
        plasmaMan = {
            url = "github:pjones/plasma-manager"; # plasma manager so we can manage kde settings with home-manager
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "homeMan";
        };
        /*
        dotfiles = {
            url = "gitlab:pengolodh/dotfiles";
            flake = false;
        }; */
    };

    outputs = inputs @ { self, nixpkgs, hyprland , homeMan, nur, impermanence, ... }: # the @ declares the names of the variables that can be used (instead of input.nixpkgs we can just do nixpkgs), the only one that is truly needed is self
    {
        # declare nixos configs here:
        nixosConfigurations = (
            # see hosts for all the individual configs, we will import that into the flake like:
            import ./hosts { 
                 # inherit passes the variables in the flake to the packages in ./hosts (they can )
                inherit (nixpkgs) lib;
                inherit self inputs;
            }
        );
    };

}


