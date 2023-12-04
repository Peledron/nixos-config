#!/usr/bin/env bash
#==============================#
sudo nixos-rebuild rollback --flake $flakedir/#$hostname --impure
