{
  description = "defines configuration.nix used by different hosts";
  #url = "https://gitlab.com/pengolodh/nixos-config";
  #rev = "main";
  inputs = {
    # main nix repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # disko, auto disk partitioning tool using nix config... its perfect to replace scripts/prepare.sh (most of it at least)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    # home-manager
    homeMan = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs"; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
    };
    # Nix User Repo
    nur = {
      url = "github:nix-community/NUR";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    }; #"github:hyprwm/Hyprland";
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    # plasma-manager
    plasmaMan = {
      url = "github:pjones/plasma-manager"; # plasma manager so we can manage kde settings with home-manager
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "homeMan";
    };

    # nix-index-database provides the database for nix-index once a week, flake provides a home-manager module
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien"; # auto dependency installing for external binaries
    /*
    dotfiles = {
        url = "gitlab:pengolodh/dotfiles";
        flake = false;
    };
    */
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    homeMan,
    nur,
    impermanence,
    sops-nix,
    hyprland,
    hyprsplit,
    nix-index-database,
    nix-alien,
    ...
  }:
  # the @ declares the names of the variables that can be used (instead of input.nixpkgs we can just do nixpkgs), the only one that is truly needed is self
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
