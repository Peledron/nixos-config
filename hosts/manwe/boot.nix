{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  boot = {
    # [kernel]
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest; #config.boot.zfs.package.latestCompatibleLinuxPackages; # this will use the latest kernel that is patched with zfs module
    extraModulePackages = with config.boot.kernelPackages; [
      #kvmfr # This kernel module implements a basic interface to the IVSHMEM device for LookingGlass when using LookingGlass in VM->VM mode Additionally, in VM->host mode, it can be used to generate a shared memory device on the host machine that supports dmabuf, which allows for the IGPU to be better utilized for rendering the looking glass display
      v4l2loopback # for obs virtual camera support
    ];
    extraModprobeConfig = ''
      options kvm_amd nested=1
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    ''; # nested virtualization and obs-studio virtual camera support

    # [early load]
    kernelParams = ["quiet" "8250.nr_uarts=0" "amd_pstate=guided"];
    # kernel parameters used at boot
    # -> "8250.nr_uarts=0"  disables the serial devices at boot, there seems to be an issue slowing down boot times

    consoleLogLevel = 1; # The kernel console loglevel. All Kernel Messages with a log level smaller than this setting will be printed to the console. severity is 0 as highest and 7 as lowest
    # see https://linuxconfig.org/introduction-to-the-linux-kernel-log-levels

    initrd = {
      # modules that are enabled during early load in the initrd (enables the modules in the kernel image that is loaded from the efi partition)
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"]; # this will load the needed device driver modules ?(if the devices are present) the drivers needed to boot must be present here (so nvme)
      kernelModules = ["aesni_intel" "cryptd"]; # kernelModules will allways be loaded, regardless of devices
      # aesni and cryptd enable the aes accelerated drivers on early boot, so the system boots faster,
      systemd = {
        enable = false; # -> will startup systemd during stage 1 (allows things like plymouth to load early for password entry)
        network.wait-online.enable = false;
      };
    };
    kernelModules = ["kvm-amd"]; # second stage modules
    # --> nixos uses 2 stages to boot, first the kernel is loaded, that populates the nix paths and then the system is loaded

    # [bootloader]
    loader = {
      timeout = 2; # amount of time before default option is chosen
      systemd-boot = {
        # if you want to dual boot you need to copy the windows EFI partition files files to /boot/EFI otherwise systemd boot will not be able to detect them
        enable = true;
        consoleMode = "max";
        configurationLimit = 5; # limits the amount of entries in boot menu
        editor = false; # disable kernel comandline editing
        memtest86.enable = true; # show an option for memtest
      };
      efi = {
        canTouchEfiVariables = true; # makes it so nixos-rebuild can touch efi-variables (to add boot entries to eufi)
        efiSysMountPoint = "/boot";
      };
      /*
      grub = {
        efiSupport = true;
        device = "nodev";
        useOSProber = true; # tell grub to look for other os'es (windows for example)
        configurationLimit = 20; # limit amount of boot options in grub, also limits the amount of kernels kept in /boot (the default of 100 used up all of the 512MB), this ofc depends more on how many kernel versions are switched between rebuilds so...
        gfxmodeEfi = "3440x1440"; # the display resolution that grub runs at
        memtest86.enable = true; # show an option for memtest
      };
      */
    };

    #plymouth.enable = true; # enable boot spash screen
  };
  #     # for secure boot see: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md and https://nixos.wiki/wiki/Secure_Boot
}
