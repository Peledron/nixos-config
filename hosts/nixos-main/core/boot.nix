{
  config,
  lib,
  pkgs,
  system,
  inputs,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest; #config.boot.zfs.package.latestCompatibleLinuxPackages; # this will use the latest kernel that is patched with zfs module
    extraModulePackages = with config.boot.kernelPackages; [
      kvmfr # This kernel module implements a basic interface to the IVSHMEM device for LookingGlass when using LookingGlass in VM->VM mode Additionally, in VM->host mode, it can be used to generate a shared memory device on the host machine that supports dmabuf
    ];
    kernelParams = ["splash" "quiet" "loglevel=3" "amd_pstate=active"]; # kernel parameters used at boot, "splash"
    loader = {
      /*
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # limits the amount of entries in boot menu
        editor = false; # disable kernel comandline editing
        memtest86.enable = true; # show an option for memtest
      };
      */
      efi = {
        canTouchEfiVariables = true; # makes it so nixos-rebuild can touch efi-variables (to add boot entries to eufi)
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
        useOSProber = true; # tell grub to look for other os'es (windows for example)
        gfxmodeEfi = "3440x1440"; # the display resolution that grub runs at
        theme = pkgs.nixos-grub2-theme; # default nixos grub theme
        memtest86.enable = true; # show an option for memte
      };
      timeout = 2; # amount of time before default option is chosen
    };
    plymouth = {
      enable = true; # eenable boot spash screen
    };
  };
  #     # for secure boot see: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md and https://nixos.wiki/wiki/Secure_Boot
}
