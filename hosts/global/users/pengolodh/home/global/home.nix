{
  config,
  lib,
  pkgs,
  system,
  inputs,
  ...
}: {
  imports =
    [(import ./env.nix)]
    ++ [(import ./pkgs.nix)]
    ++ (import ./configs);

  home.stateVersion = "23.11";
  nix = {
    gc = {
      automatic = true; # enabling automatic without the lines below will run it daily by default (not really safe unless snapshots are used)
      frequency = "weekly";
      options = "--delete-older-than 7d";
      # set gc to delete nix-store generations of the previous week once a week as a compromise
    };
  };
}
