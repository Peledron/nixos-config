#!/usr/bin/env bash
#==============================#
micro $flakedir/hosts/$hostname/users/$USER/configs/fish.nix
sudo nixos-rebuild switch  --flake $flakedir/#$hostname --impure
# seems overkill to reload entire config tbh