{ config, lib, pkgs, modulesPath, ... }:
{
  
  imports =[ (modulesPath + "/installer/scan/not-detected.nix") ];
  
  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; # change to amd if that is used insead
  # ---

  # kernel modules:
  boot = {
    initrd = { # modules that are enabled in the initrd (when the kernel is loaded from the efi partition)
      # qemu guest modules: "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" 
      availableKernelModules = [ "ehci_pci" "ahci"  "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ]; 
    };
    kernelModules = [ "kvm-intel" ];
  };
  # ---
  
  # bluetooth:
  #hardware.bluetooth.enable = true;
  # ----
}
