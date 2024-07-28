{
  config,
  lib,
  pkgs,
  system,
  inputs,
  disks,
  ...
}: {
  boot = {
    #kernelPackages = pkgs.linuxKernel.packages.linux_hardened; # kernel to be used --> i get a message saying: "extend" missing so ill ignore it for now ==> fixed by using  pkgs.linuxKernel.**packages**.linux_xanmod_latest instead of  pkgs.linuxKernel.kernels.linux_xanmod_latest (even if it was listed this way in nixos packages)
    kernelPackages = pkgs.linuxPackages;
    kernelParams = ["loglevel=3"]; # kernel parameters used at boot
    # loglevel 3 disables annoying message spam
    initrd = {
      # modules that are enabled in the initrd (when the kernel is loaded from the efi partition)
      # qemu guest modules: "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"
      availableKernelModules = ["ehci_pci" "ahci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    loader = {
      grub.device = builtins.elemAt extraConfig.disks 0;
    };
  };
  # for secure boot see: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
}
