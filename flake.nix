{
  description = "main flake for home system configs";
  #url = "https://gitlab.com/pengolodh/nixos-config";
  #rev = "main";
  inputs = {
    # main nix repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # disko, auto disk partitioning tool using nix config... its perfect to replace scripts/prepare.sh (most of it at least)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # encryption of secrets
    agenix.url = "github:ryantm/agenix";
    # impermanent setup
    impermanence.url = "github:nix-community/impermanence";
    persist-retro.url = "github:Geometer1729/persist-retro"; # persist-retro checks if a folder marked by already exists and moves the files to the peristent location

    # hardware support for various devices
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # see https://github.com/NixOS/nixos-hardware for full list

    # home-manager
    homeMan = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs"; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
    };
    stylix.url = "github:danth/stylix"; # automatic styling of programs

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
  };

  outputs = inputs @ {
    # the @ declares the names of the variables that can be used (instead of input.nixpkgs we can just do nixpkgs), the only one that is truly needed is self
    self,
    nixpkgs,
    ...
  }: let
    hostConfigs = import ./hosts {
      # inherit passes the variables in the flake to the packages in ./hosts (they can )
      inherit (nixpkgs) lib; # same as nixpkgs.lib, defines it that way
      inherit self inputs;
    };
  in {
    # as we are passing some variables to the configuraiton we need to define them here
    nixos-main = hostConfigs.nixos-main {desktopEnv = "hyprland";};
    nixos-laptop-asus = hostConfigs.nixos-laptop-asus {desktopEnv = "kde";};
    nixos-server-hp = hostConfigs.nixos-server-hp;
  };
}
