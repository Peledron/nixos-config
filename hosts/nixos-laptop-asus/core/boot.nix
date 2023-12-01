{ config, lib, pkgs, system, inputs, ... }:   
{
    boot = {
        kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages; # this will use the latest kernel that is patched with zfs module
        kernelParams = [ "quiet" "splash" "zfs.zfs_arc_max=12884901888" "amd_pstate=active" ]; # kernel parameters used at boot, arc size is 12 GB
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
    # for secure boot see: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
}