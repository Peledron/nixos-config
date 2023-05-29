{ config, lib, pkgs, system, inputs, ... }:   
{
    boot = {
        #kernelPackages = pkgs.linuxKernel.packages.linux_hardened; # kernel to be used --> i get a message saying: "extend" missing so ill ignore it for now ==> fixed by using  pkgs.linuxKernel.**packages**.linux_xanmod_latest instead of  pkgs.linuxKernel.kernels.linux_xanmod_latest (even if it was listed this way in nixos packages)
        kernelParams = [ "loglevel=3" ]; # kernel parameters used at boot
        # loglevel 3 disables annoying message spam
        loader = {
            grub.device = "/dev/sda";
        };
    };
    # for secure boot see: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
}
