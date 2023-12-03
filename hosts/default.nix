# declare the hosts for the flake, default.nix will always be used when importing a directory
{ lib, inputs, nixpkgs, nur, hyprland, self, ... }:
let
  system = "x86_64-linux"; # System architecture
  lib = nixpkgs.lib;

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;  # Allow proprietary software
    overlays = [
      nur.overlay # overlay nixpkgs with nur, meant that you add nur packages to the nixpkgs module (I think)
    ];
  };

  nur-no-pkgs = import nur { # so we can import overlapping modules
    nurpkgs = import nixpkgs {inherit system; }; 
  };

  hyprland = inputs.hyprland.nixosModules.default;
  hyprlandHM = inputs.hyprland.homeManagerModules.default;
in
{
  #==================#
  # vm-desktop:
  #==================#
  vm-nixos-desktop = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs self; 
    };
      modules = [
        #/etc/nixos/hardware-configuration.nix # remove this as it is impure, only for configurations that are used between a lot of systems (or just add more hosts in this file for different systems)
        # --> changed it to use partitionlabels instead, all hardware configuration is defined in $host/core/hardware.nix
        ./global/config/conf.nix 
        ./global/config/desktop/xfce.nix
        ./vm-nixos-desktop

        #==================#
        # system home-man:
        inputs.homeMan.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
          home-manager.useUserPackages = true; # packages will be installed per user;
          home-manager.extraSpecialArgs = {  };
          home-manager.users.pengolodh = {
            imports = 
              [(import ./global/users/desktop-pengolodh/home.nix)]
            ; # add more inports via ++ (import folder) or ++ [(import file)]
            
          };
          # ---
          # add more users here:
        }
	
        
        
      ];
  };
  # ---

  #==================#
  # vm-server:
  #==================#
  # ---

  #==================#
  # hardware:
  #==================#
  nixos-macbook = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs self;
    };
    modules = [
        hyprland
        ./global/config/conf.nix
        ./global/config/desktop/hyprland.nix
        #./global/config/desktop/kde.nix
        ./nixos-macbook
        
        #==================#
        # system home-man:
        inputs.homeMan.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
          home-manager.useUserPackages = true; # packages will be installed per user;
          home-manager.extraSpecialArgs = {
            inherit (inputs);
          };
          home-manager.users.pengolodh = {
            imports = 
              #[inputs.plasmaMan.homeManagerModules.plasma-manager]  # add plasma-manager to home-man user imports as per https://github.com/pjones/plasma-manager/issues/5
              [hyprlandHM]
              ++ [(import ./global/users/desktop-pengolodh/home.nix)]
              #++ (import ./global/config/desktop/kde)
              ++ [(import ./global/config/desktop/hyprland/pkgs.nix)]
              ++ [(import ./global/config/desktop/hyprland/conf.nix)]
            ; # add more inports via ++ (import folder) or ++ [(import file)]
            
          };
          # ---
          # add more users here:
        }
	
        
        
      ];
  };
  # ---
   nixos-laptop-asus = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs self;
    };
    modules = [
        hyprland
        ./global/config/conf.nix
        ./global/config/desktop/kde.nix
        ./nixos-laptop-asus
        
        #==================#
        # system home-man:
        inputs.homeMan.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
          home-manager.useUserPackages = true; # packages will be installed per user;
          home-manager.extraSpecialArgs = {
            inherit (inputs);
          };
          home-manager.users.pengolodh = {
            imports = 
              [inputs.plasmaMan.homeManagerModules.plasma-manager]  # add plasma-manager to home-man user imports as per https://github.com/pjones/plasma-manager/issues/5
              ++ [(import ./global/users/desktop-pengolodh/home.nix)]
              ++ (import ./global/config/desktop/kde)

            ; # add more inports via ++ (import folder) or ++ [(import file)]
            
          };
          # ---
          # add more users here:
        }
	
        
        
      ];
  };

  #==================#
  # hardware-server:
  #==================#
  nixos-server-dns = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs;
    };
      modules = [
        #/etc/nixos/hardware-configuration.nix # remove this as it is impure, only for configurations that are used between a lot of systems (or just add more hosts in this file for different systems)
        # --> changed it to use partitionlabels instead, all hardware configuration is defined in $host/core/hardware.nix
        ./global/config/conf.nix
        ./nixos-server-dns

        #==================#
        # system home-man:
        inputs.homeMan.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
          home-manager.useUserPackages = true; # packages will be installed per user;
          home-manager.extraSpecialArgs = {  };
          home-manager.users.pengolodh = {
            imports =
              [(import ./global/users/server-pengolodh/home.nix)]
            ; # add more inports via ++ (import folder) or ++ [(import file)]

          };
          # ---
          # add more users here:
        }



      ];
  };
  # ---

  # home-manager can also be done as a standalone:
  # (not really recommended as it recuires more steps)
  /*
  homeConfigurations = {
    pengolodh = home-manager.lib.homeManagerConfiguration {
      inherit system pkgs;
        username = "pengolodh";
        homeDirectory = "/home/pengolodh";
        configuration = {
          imports = [ ./nixos-desktop-pengolodh/pengolodh/home.nix ];
        };
    };
    #  ---
    # add more users here:
  };
  */
}
