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
        # plasma-manager
        plasmaMan = {
            url = "github:pjones/plasma-manager"; # plasma manager so we can manage kde settings with home-manager
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "homeMan";
        };
        hyprland.url = "github:hyprwm/Hyprland"; 
        dotfiles = {
            url = "gitlab:pengolodh/dotfiles";
            flake = false;
        };
    };

    outputs = inputs @ { self, nixpkgs, nur, dotfiles, ... }: # the @ declares the names of the variables that can be used (instead of input.nixpkgs we can just do nixpkgs), the only one that is truly needed is self
    {
        # declare nixos configs here:
        nixosConfigurations = (
            # see hosts for all the individual configs, we will import that into the flake like:
            import ./hosts { 
                 # inherit passes the variables in the flake to the packages in ./hosts (they can )
                inherit (nixpkgs) lib;
                inherit inputs nixpkgs nur dotfiles;
            }
        );
    };

}


