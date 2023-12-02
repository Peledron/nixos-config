{ config, lib, pkgs, system, inputs, ... }:   
{
    boot = {
        kernelPackages = pkgs.linuxPackages_latest; # pkgs.linuxKernel.packages.linux_xanmod_latest; # kernel to be used --> i get a message saying: "extend" missing so ill ignore it for now ==> fixed by using  pkgs.linuxKernel.**packages**.linux_xanmod_latest instead of  pkgs.linuxKernel.kernels.linux_xanmod_latest (even if it was listed this way in nixos packages)
        kernelParams = [ "quiet" "splash" ]; # kernel parameters used at boot
        loader = {
            systemd-boot = {
                enable = true;
                configurationLimit = 5; # limits the amount of entries in boot menu

            };
            efi.canTouchEfiVariables = true; # makes it so we can edit boot entrie kernel command line
            timeout = 1; # amount of time before default option is chosen
        };
        # clear root subvolume on each boot as per https://grahamc.com/blog/erase-your-darlings/ and https://nixos.wiki/wiki/Btrfs (see scripts/prepare.sh under persistence option)
        initrd.postDeviceCommands = lib.mkAfter ''
            mkdir /mnt
            mount -t btrfs /dev/mapper/enc /mnt
            btrfs subvolume delete /mnt/root
            btrfs subvolume snapshot /mnt/root-blank /mnt/root
        '';
    };
    # for secure boot see: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
}