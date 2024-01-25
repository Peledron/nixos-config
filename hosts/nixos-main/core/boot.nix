{ config, lib, pkgs, system, inputs, ... }:   
{
    boot = {
        kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest; #config.boot.zfs.package.latestCompatibleLinuxPackages; # this will use the latest kernel that is patched with zfs module
        kernelParams = [ "quiet" "splash" "amd_pstate=guided" ]; # kernel parameters used at boot, arc size is 12 GB
        loader = {
            systemd-boot = {
                enable = true;
                configurationLimit = 5; # limits the amount of entries in boot menu
            };
            efi.canTouchEfiVariables = true; # makes it so we can edit boot entrie kernel command line
            timeout = 1; # amount of time before default option is chosen
        };
        plymouth = {
            enable = true;
        };
    };
#     # for secure boot see: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md and https://nixos.wiki/wiki/Secure_Boot
}
