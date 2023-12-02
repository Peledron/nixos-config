#!/usr/bin/env bash
# make sure you use the same mountdir as in prepare.sh
echo "host?"
read host

mountdir=/mnt
user=pengolodh
gituser=pengolodh
giturlnixos=https://$gituser@gitlab.com/pengolodh/nixos-config.git
repodir=$mountdir/home/$user/nixos-config


#==============================#
# nixos installation:
# clone the flake, generate hardware-configuration.nix and install nixos
# cleanup existing /etc/nixos
rm -r $mountdir/etc/nixos
mkdir -p $mountdir/etc
nix-env -iA nixos.git
# delete repodir so we can rerun
rm -r $repodir
# you will be prompted for password
git clone $giturlnixos $repodir
# genrate hardware-configuration.nix and configuration.nix
nixos-generate-config --root $mountdir
# cleanup generated configuration.nix to avoid problems
rm $mountdir/etc/nixos/configuration.nix
# if using a symlink to link to hardware-configuration.nix in the repo do:
#cp $mountdir/etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
cd $repodir
nixos-install --flake .#$host 
# install nixos. added impure flag so we can use the /etc/nixos/hardware-configuration.nix file


