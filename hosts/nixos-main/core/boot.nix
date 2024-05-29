{
  config,
  lib,
  pkgs,
  system,
  inputs,
  ...
}: {
  boot = {
    # [kernel]
    kernelPackages = pkgs.unstable.linuxKernel.packages.linux_xanmod_latest; #config.boot.zfs.package.latestCompatibleLinuxPackages; # this will use the latest kernel that is patched with zfs module
    extraModulePackages = with config.boot.kernelPackages; [
      kvmfr # This kernel module implements a basic interface to the IVSHMEM device for LookingGlass when using LookingGlass in VM->VM mode Additionally, in VM->host mode, it can be used to generate a shared memory device on the host machine that supports dmabuf
      v4l2loopback # for obs virtual camera support
    ];
    extraModprobeConfig = ''
      options kvm_amd nested=1
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    ''; # nested virtualization and obs-studio virtual camera support

    # [early load]
    kernelParams = ["splash" "quiet" "loglevel=3" "amd_pstate=active" "amdgpu.si_support=1" "amdgpu.ppfeaturemask=0xffffffff"];
    # kernel parameters used at boot,
    # -> amdgpu.si_support=1 and amdgpu.ppfeaturemask=0xffffffff is to enable overclocking support

    initrd = {
      # modules that are enabled during early load in the initrd (enables the modules in the kernel image that is loaded from the efi partition)
      availableKernelModules = ["amdgpu" "nvme" "aesni_intel" "cryptd" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
      # aesni and cryptd enable the aes accelerated drivers on early boot, so the system boots faster, you can also add  "amdgpu" to make that driver initialize earlier during boot

      kernelModules = ["dm-snapshot"];
      systemd.enable = true; # -> will startup systemd during stage 1 (allows things like plymouth to load early for password entry), boots faster
    };
    kernelModules = ["kvm-amd"];

    # [bootloader]
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
        configurationLimit = 20; # limit amount of boot options in grub, also limits the amount of kernels kept in /boot (the default of 100 used up all of the 512MB), this ofc depends more on how many kernel versions are switched between rebuilds so...
        gfxmodeEfi = "3440x1440"; # the display resolution that grub runs at
        theme = pkgs.nixos-grub2-theme; # default nixos grub theme
        memtest86.enable = true; # show an option for memtest
      };
      timeout = 2; # amount of time before default option is chosen
    };
    plymouth = {
      enable = true; # eenable boot spash screen
      themePackages = with pkgs; [
        adi1090x-plymouth-themes # bunch of themes, see https://github.com/adi1090x/plymouth-themes
        nixos-bgrt-plymouth # similar to default, has the nixos snowflake spinning instead of the round thingy
      ];
      theme = "nixos-bgrt";
    };
  };
  #     # for secure boot see: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md and https://nixos.wiki/wiki/Secure_Boot
}
