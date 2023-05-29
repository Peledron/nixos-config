#!/usr/bin/env bash
#==============================#
# variables:
# => swapsize in MB
swapsize=4086
# => set mountdir to whatever you want
mountdir=/mnt
# => define the drive (is sometimes vda)
drive=/dev/sda
# => partition labels 
efilabel=EFI-NIXOS # should be uppercase for compat reasons
rootlabel=crypted-main-nixos # change to whatever you want
# => name that luks will map $rootlabel to after it is opened
luksmap=nixos-main

#==============================#
# setup:
umount -l /dev/mapper/$luksmap
umount -l $mountdir
cryptsetup luksClose /dev/mapper/$luksmap
# clean previous run if it exists
sleep 1
mkdir -p $mountdir
# makes sure mountpoint exists
#==============================#
# formatting:
# note that all commands are run as root
# if you are using a fresh drive do do the following, otherwise skip to encrypted btrfs root part (just make sure you have an efi partition)
# change sdX to your drive
# --> sfdisk will read the printf command line by line (\n) each line represents a new parition (exept the first)
# ,550M,L means a 550M LINUX_NATIVE partition
printf "label: gpt\n,550M,U\n,%s,L\n,%s,L" | sfdisk $drive
# change $drive to your drive
# --> this **FORMATS(!)** the drive as gpt and gives it 2 partitions, sdX1 will be a 550MB efi partition (for boot) and sdX2 will be your btrfs root partion (see fdisk for more options), if you are using a GUI tool to make your partitions, remember to flag your efi partition as esp (and make it a fat partion)
mkfs.fat -F 32 ${drive}1
# format efi as fat32
# now we will make the encrypted btrfs root:
# => format your partition as luks2 via cryptsetup:
cryptsetup -y -v --type luks2 luksFormat ${drive}2
# give it a strong passwd
fatlabel ${drive}1 $efilabel
cryptsetup config ${drive}2 --label $rootlabel
# give labels to partions so they can be consistent across the all devices
# unlock and map the encrypted partition to something
cryptsetup luksOpen ${drive}2 $luksmap
# you can map it to anything, however, "nixos-main" is used in this repo (change nixos-main to mapped name in ../core/filesystems.nix)
# it is recommended to use "dd if=/dev/zero of=/dev/mapper/nixos-main" to overwrite all blockdata with 0s if you are really serious about data security, will not do this here as the process takes hours depending on the drive used (and wears out your ssd)
# use "pv -tpreb /dev/zero | dd of=/dev/mapper/nixos-main bs=128M" to monitor the process if you do use the dd command
sleep 2
mkfs.btrfs /dev/mapper/$luksmap
# this creates the btrfs partition on top of the luks2 partition
sleep 2
#==============================#
# subvolume creation + mounting:
# create the subvolumes
mount /dev/mapper/$luksmap $mountdir
# you only really need a root, nix and home subvolume, but I will use the standard layout from [opensuse](https://en$mountdiropensuse$mountdirorg/SDB:BTRFS) and add a @nix to it
btrfs subvolume create $mountdir/@
btrfs subvolume create $mountdir/@nix
btrfs subvolume create $mountdir/@home
# btrfs subvolume create $mountdir/@var
# btrfs subvolume create $mountdir/@tmp
# btrfs subvolume create $mountdir/@opt
# btrfs subvolume create $mountdir/@srv
# btrfs subvolume create $mountdir/@usr-local
btrfs subvolume create $mountdir/@swap
# optional, see below\
sleep 2
# unmount $mountdir, create the subvol locations and mount the subvols with compress=zstd (so all installed data will be compressed)
umount -l $mountdir
mount -o compress=zstd,subvol=@ /dev/mapper/$luksmap $mountdir
mkdir -p $mountdir/{nix,home,var,tmp,opt,srv,usr/local,swap}
ls $mountdir
mount -o compress=zstd,subvol=@nix,noatime /dev/mapper/$luksmap $mountdir/nix
mount -o compress=zstd,subvol=@home /dev/mapper/$luksmap $mountdir/home
mount -o compress=zstd,subvol=@var,noatime /dev/mapper/$luksmap $mountdir/var
mount -o compress=zstd,subvol=@tmp,noatime,commit=120 /dev/mapper/$luksmap $mountdir/tmp
# commit=120 reduces writes to drive, you may want to enable it on /var depending on how often you write logs or if you are using an sd-card as root or something (though logging to ram would be better for that, see [log2ram](https://github.com/azlux/log2ram))
mount -o compress=zstd,subvol=@opt,noatime /dev/mapper/$luksmap $mountdir/opt
mount -o compress=zstd,subvol=@srv /dev/mapper/$luksmap $mountdir/srv
mount -o compress=zstd,subvol=@usr-local /dev/mapper/$luksmap $mountdir/usr/local
mount -o subvol=@swap /dev/mapper/$luksmap $mountdir/swap 
# optional, see below
sleep 1
# make the boot location and mount it (I recommend using /boot for better compatibility)
mkdir $mountdir/boot
mount ${drive}1 $mountdir/boot
lsblk
sleep 2
#==============================#
# swapfile creation:
# optionally use a swapfile:
btrfs filesystem mkswapfile --size ${swapsize} swapfile



