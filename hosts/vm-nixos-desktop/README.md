# readme


---
## how to use this repo:
### 1-basic nixos environment installation

> 1. start nixos-live env 
> 2. configure boot, encrypted btrfs root/home and (optionally) swapfile:

> > ```bash
> > # note that all commands are run as root
> > # if you are using a fresh drive do do the following, otherwise skip to encrypted btrfs root part (just make sure you have an efi partition)
> > # change sdX to your drive
> > printf "label: gpt\n,550M,U\n,,L\n" | sfdisk /dev/sdX # change sdX to your drive
> > # --> this **FORMATS(!)** the drive as gpt and gives it 2 partitions, sdX1 will be a 550MB efi partition (for boot) and sdX2 will be your btrfs root partion (see fdisk for more options), if you are using a GUI tool to make your partitions, remember to flag your efi partition as esp (and make it a fat partion)
> > mkfs.fat -F 32 /dev/sdX1 # format efi as fat32
> >
> > # now we will make the encrypted btrfs root:
> >
> > # => format your partition as luks2 via cryptsetup:
> > # change sdX2 to your root partition
> > cryptsetup -y -v --type luks2 luksFormat /dev/sdX2
> > # give it a strong passwd
> >
> > # unlock and map that partition to something
> > cryptsetup luksOpen /dev/sdx2 nixos-main
> > # you can map it to anything, however, "nixos-main" is used in this repo (change nixos-main to mapped name in ./system/drive-conf.nix)
> >
> > # it is recommended to use "dd if=/dev/zero of=/dev/mapper/nixos-main" to overwrite all blockdata with 0s if you are really serious about data security, will not do this here as the process takes hours depending on the drive used (and wears out your ssd)
> > # use "pv -tpreb /dev/zero | dd of=/dev/mapper/nixos-main bs=128M" to monitor the process if you do use the dd command
> >
> > mkfs.btrfs /dev/mapper/nixos-main
> > # this creates the btrfs partition on top of the luks2 partition
> >
> > # create the subvolumes
> > mount /dev/mapper/nixos-main /mnt
> > # you only really need a root, nix and home subvolume, but I will use the standard layout from [opensuse](https://en.opensuse.org/SDB:BTRFS) and add a @nix to it
> > btrfs subvolume create /mnt/@
> > btrfs subvolume create /mnt/@nix
> > btrfs subvolume create /mnt/@home
> > btrfs subvolume create /mnt/@var
> > btrfs subvolume create /mnt/@tmp
> > btrfs subvolume create /mnt/@opt
> > btrfs subvolume create /mnt/@srv
> > btrfs subvolume create /mnt/@usr-local
> > btrfs subvolume create /mnt/@swap # optional, see below
> >
> > # unmount /mnt, create the subvol locations and mount the subvols with compress=zstd (so all installed data will be compressed)
> > umount /mnt
> > 
> > mount -o compress=zstd,subvol=@ /dev/mapper/nixos-main /mnt
> > mkdir -p /mnt/{nix,home,var,tmp,opt,srv,usr/local,swap}
> > mount -o compress=zstd,subvol=@nix,noatime /dev/mapper/nixos-main /mnt/nix
> > mount -o compress=zstd,subvol=@home /dev/mapper/nixos-main /mnt/home
> > mount -o compress=zstd,subvol=@var,noatime /dev/mapper/nixos-main /mnt/var
> > mount -o compress=zstd,subvol=@tmp,noatime,commit=120 /dev/mapper/nixos-main /mnt/tmp
> > # commit=120 reduces writes to drive, you may want to enable it on /var depending on how often you write logs or if you are using an sd-card as root or something (though logging to ram would be better for that, see [log2ram](https://github.com/azlux/log2ram))
> > mount -o compress=zstd,subvol=@opt,noatime /dev/mapper/nixos-main /mnt/opt
> > mount -o compress=zstd,subvol=@srv /dev/mapper/nixos-main /mnt/srv
> > mount -o compress=zstd,subvol=@usr-local /dev/mapper/nixos-main /mnt/usr/local
> > mount -o subvol=@swap /dev/mapper/nixos-main /mnt/swap # optional, see below
> >
> > # make the boot location and mount it (I recommend using /boot for better compatibility)
> > mkdir /mnt/boot
> > mount /dev/sdX1 /mnt/boot
> >
> > # optionally use a swapfile:
> > truncate -s 0 /mnt/swap/swapfile
> > # --> create empty swapfile
> > chattr +C /mnt/swap/swapfile
> > btrfs property set /mnt/swap/swapfile compression none
> > # --> disable btrfs compression for the swapfile
> >
> > dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=2048
> > # --> change count value to wanted size of swap (2GB in this case as we are using a vm)
> > chmod 0600 /mnt/swap/swapfile
> > # --> only allow root to acces the swapfile
> > mkswap /mnt/swap/swapfile
> > # --> define swapfile as linux-swap
> > ```

> 3. **nixos-generate-config --root /mnt** # run this to generate the hardware specific settings and prepare /mnt for installation

### 2-clone the repo and install nixos
> 1. install git & clone the repo into your home with:
> > ```bash
> > nix-env -iA nixos.git
> > cd 
> > git clone https://gitlab.com/pengolodh/nixos-config.git 
> > ```
> 2. cleanup generated configuration.nix to avoid problems:
> > ```bash
> > rm /mnt/etc/nixos/configuration.nix
> > ``` 
> 3. go into the repo-directory and **install nixos**:
> > ```bash
> > cd nixos-config
> > nixos-install --flake .#vm-nixos-desktop
> > ```

---
## nix-module layout:
- system specific config is found in ./system
> - ./system/drive-conf.nix holds mount options
> - ./system/desktop.nix is for desktop specific configuration
> - ./system/environment.nix is for systemwide env values
> - ./system/networking.nix is for networking settings (hostname, firewall, proxy, etc..)
> - ./system/packages.nix is for host specific system-wide package installation and for their specific options (exept services, those go into services.nix)
> - ./system/services.nix is for host specific service configuration
> - ./system/hardware-specific is for special hardware specific configuration (ie nvidia), might include packages, kernel modules, etc.
> - ./system/locale.nix is for host specific locate lettings

- user are defined in ./system/usr.nix and individual user configs (via home manager) are defined in their respective folders under ./users (so pengolodh is for my user)

---
## upgrading/installing/removing packages
=> there are 2 ways to install, upgrade or remove packages:
> 1. add/remove them to ./global/users/$USER/pkgs.nix (for user specific programs) or ./hosts/$hostname/system/pkgs.nix
> > -> you can then upgrade using "sudo nix flake update" and then "sudo nixos-rebuild switch --flake ./#$hostname" ==> you need to cd to the $flakedir first
> 2. add/remove them via nix-env (only for non system wide packages):
> > - nix-env -iA $package
> > > --> will install a package
> > - nix-env $package --uninstall
> > > --> will remove a package
> > - nix-env -U $package # (or "*" for every package)
> > > --> will upgrade a/all package(s)
==> you can find packages at https://search.nixos.org/packages

> 3. you can use flatpak to install gui programs like discord if you prefer them better isolated from your filesystem (I also recommend flatseal to manage application permissions)
> > --> flatpak install, flatpak search, flatpak remove, ...

