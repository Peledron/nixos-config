# declare the hosts for the flake, default.nix will always be used when importing a directory
{ lib, self, inputs, ... }:
let
  # modules
  system = "x86_64-linux"; # System architecture
  lib = inputs.nixpkgs.lib;

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;  # Allow proprietary software
    overlays = [
      inputs.nur.overlay # overlay nixpkgs with nur, meant that you add nur packages to the nixpkgs module (I think)
    ];
  };

  nur-no-pkgs = import inputs.nur { # so we can import overlapping modules
    nurpkgs = import inputs.nixpkgs {inherit system; };
  };

  hyprland = inputs.hyprland.nixosModules.default;

  home-manager = inputs.homeMan.nixosModules.home-manager;
  plasma-manager = inputs.plasmaMan.homeManagerModules.plasma-manager;
  hyprlandHM = inputs.hyprland.homeManagerModules.default;

  impermanence = inputs.impermanence.nixosModules.impermanence;

  # paths
  hostdir = "${self}/hosts";
  global-confdir = "${hostdir}/global/config";
  global-usrdir = "${hostdir}/global/users";

  # user specific modules
  pengolodh-basemodule = "${global-usrdir}/pengolodh/usr.nix";
  pengolodh_desktop-homemodule = "${global-usrdir}/pengolodh/home/desktop/home.nix";
  pengolodh_server-homemodule = "${global-usrdir}/pengolodh/home/server/home.nix";

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
        # package modules
        impermanence
        # global modules
        "${global-confdir}/conf.nix"
        "${global-confdir}/desktop/gnome.nix"

        # host module
        "${hostdir}/vm-nixos-desktop"

        # user modules
        pengolodh-basemodule

        #==================#
        # system home-man:
        home-manager {
          home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
          home-manager.useUserPackages = true; # packages will be installed per user;
          home-manager.extraSpecialArgs = {  };
          home-manager.users.pengolodh = {
            imports = 
              [pengolodh_desktop-homemodule]
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
        "${global-confdir}/conf.nix"
        "${global-confdir}/desktop/hyprland.nix"
        #./global/config/desktop/kde.nix
        "${hostdir}/nixos-macbook"

         # user modules
        pengolodh-basemodule
        
        #==================#
        # system home-man:
        home-manager {
          home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
          home-manager.useUserPackages = true; # packages will be installed per user;
          home-manager.extraSpecialArgs = {
            inherit (inputs);
          };
          home-manager.users.pengolodh = {
            imports = 
              #[inputs.plasmaMan.homeManagerModules.plasma-manager]  # add plasma-manager to home-man user imports as per https://github.com/pjones/plasma-manager/issues/5
              [hyprlandHM]
              [pengolodh_desktop-homemodule]
              #++ (import ./global/config/desktop/kde)
              ++ [(import "${global-confdir}/desktop/hyprland/pkgs.nix")]
              ++ [(import "${global-confdir}/desktop/hyprland/conf.nix")]
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
        "${global-confdir}/conf.nix"
        "${global-confdir}/desktop/kde.nix"
        "${hostdir}/nixos-laptop-asus"

         # user modules
        pengolodh-basemodule
        
        #==================#
        # system home-man:
        home-manager {
          home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
          home-manager.useUserPackages = true; # packages will be installed per user;
          home-manager.extraSpecialArgs = {
            inherit (inputs);
          };
          home-manager.users.pengolodh = {
            imports = 
              [plasma-manager]  # add plasma-manager to home-man user imports as per https://github.com/pjones/plasma-manager/issues/5
              ++ [pengolodh_desktop-homemodule]
              ++ (import "${global-confdir}/desktop/kde")

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
        "${global-confdir}/conf.nix"
        "${hostdir}/nixos-server-dns"
        # user modules
        pengolodh-basemodule

        #==================#
        # system home-man:
        home-manager {
          home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
          home-manager.useUserPackages = true; # packages will be installed per user;
          home-manager.extraSpecialArgs = {  };
          home-manager.users.pengolodh = {
            imports =
              [pengolodh_server-homemodule]
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
