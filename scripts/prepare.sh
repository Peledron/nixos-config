#!/usr/bin/env bash
#==============================#
# variables:
# => swapsize in MB
swapsize=4G
# => set mountdir to whatever you want
mountdir=/mnt
# => define the drive (is sometimes vda)
drive=/dev/vda
# => partition labels 
efilabel=EFI-NIXOS # should be uppercase for compat reasons
rootlabel=crypted-main-nixos # change to whatever you want
# => name that luks will map $rootlabel to after it is opened
luksmap=nixos-main

# flags
ephemeral=y # change to y to set persistance on, this clears root on every reboot and regenerates it, the host needs to be configured to support this, see the bottom of https://nixos.wiki/wiki/Btrfs

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
printf "label: gpt\n,550M,U\n,%s,L" | sfdisk $drive
# printf will do the following line by line 
#label: gpt
#n,550M, U -> n means new partition> 550M size > U that the partiton will be of the type EFI System partition 
#n,%s,L ->  n means new partition> variable 1 size (after the printf command you can specify by for example "64G"), if left empty it will fill the drive > L is linux partition type
# -> you can add more partitions by repeating the second line and defining the size in its variable slot 
# ==> see https://man7.org/linux/man-pages/man8/sfdisk.8.html for more info about sfdisk

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
# you only really need a root, nix and home subvolume, you could also use the standard layout from [opensuse](https://en$mountdiropensuse$mountdirorg/SDB:BTRFS) and add a @nix to it
btrfs subvolume create $mountdir/root
btrfs subvolume create $mountdir/nix
btrfs subvolume create $mountdir/home
btrfs subvolume create $mountdir/swap # optional, see below

# ephemeral root
if [ "$ephemeral" = "y" ]; then
    # create additional subvolumes in which data separate from root will be stored so that it will be persistent
    btrfs subvolume create $mountdir/persist # The subvolume for /persist, containing system state which should be persistent across reboots and possibly backed up (etc config that is not able to be done via nixos and such)
    btrfs subvolume create $mountdir/log # The subvolume for /var/log so that logs persist across boots
    btrfs subvolume create $mountdir/persist/vm_default-images # /var/lib/libvirt/images

    # Take an empty *readonly* snapshot of the root subvolume, which can be rollback to on every boot.
    btrfs subvolume snapshot -r $mountdir/root $mountdir/root-blank
fi
sleep 1
btrfs subvolume list $mountdir

# unmount $mountdir, create the subvol locations and mount the subvols with compress=zstd (so all installed data will be compressed)
umount -l $mountdir

mount -o compress=zstd,noatime,subvol=root /dev/mapper/$luksmap $mountdir


# ephemeral root
if [ "$ephemeral" = "y" ]; then
    mkdir -p $mountdir/persist
    mkdir -p $mountdir/var/lib/libvirt/images
    mkdir -p $mountdir/var/log

    mount -o compress=zstd,noatime,subvol=persist /dev/mapper/$luksmap $mountdir/persist
    mount -o compress=zstd,noatime,subvol=log /dev/mapper/$luksmap $mountdir/var/log

    mount -o noatime,commit=120,subvol=persist/vm_default-images /dev/mapper/$luksmap $mountdir/var/lib/libvirt/images

    # create directories in persist to make bluetooth and networking devices save across restarts
    # see https://grahamc.com/blog/erase-your-darlings/ "opting in" to see the needed nix config surrounding these
    # networking
    mkdir -p /persist/etc/{wireguard,libvirt,NetworkManager}
    mkdir -p /persist/etc/NetworkManager/system-connections
    # bluetooth device pairs
    mkdir -p /persist/var/lib/{NetworkManager,bluetooth,docker}

    ls $mountdir
    ls $mountdir/persist
fi

mkdir -p $mountdir/{nix,home,swap}

ls $mountdir
mount -o compress=zstd,noatime,subvol=nix /dev/mapper/$luksmap $mountdir/nix
mount -o compress=zstd,,noatime,subvol=home /dev/mapper/$luksmap $mountdir/home
mount -o subvol=swap /dev/mapper/$luksmap $mountdir/swap # optional, see below
sleep 1
# make the boot location and mount it (I recommend using /boot for better compatibility)
mkdir $mountdir/boot
mount ${drive}1 $mountdir/boot
lsblk
sleep 2
#==============================#
# swapfile creation:
# optionally use a swapfile:
btrfs filesystem mkswapfile --size ${swapsize} --uuid clear $mountdir/swap/swapfile

sleep 1


