{
  config,
  lib,
  pkgs,
  system,
  inputs,
  ...
}: {
  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages; # this will use the latest kernel that is patched with zfs module
    kernelParams = ["quiet" "splash" "amd_pstate=active"]; # kernel parameters used at boot, arc size is 12 GB
    initrd = {
      # modules that are enabled in the initrd (when the kernel is loaded from the efi partition)
      # qemu guest modules: "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"
      availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
      kernelModules = [];
    };
    kernelModules = ["kvm-amd"];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # limits the amount of entries in boot menu
      };
      efi.canTouchEfiVariables = true; # makes it so we can edit boot entrie kernel command line
      timeout = 1; # amount of time before default option is chosen
    };
    plymouth.enable = true;
  };
  #     # for secure boot see: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md and https://nixos.wiki/wiki/Secure_Boot
}
