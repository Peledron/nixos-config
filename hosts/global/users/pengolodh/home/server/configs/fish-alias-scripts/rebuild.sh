#!/usr/bin/env bash
#==============================#
sudo nixos-rebuild switch  --flake $flakedir/#$hostname --impure