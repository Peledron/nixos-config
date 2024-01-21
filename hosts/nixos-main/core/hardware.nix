{ config, lib, pkgs, modulesPath, ... }:
{
  
  imports =[ (modulesPath + "/installer/scan/not-detected.nix") ];
  
  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; # change to amd if that is used insead
  # ---

  # kernel modules:
  boot = {
    initrd = { # modules that are enabled in the initrd (when the kernel is loaded from the efi partition)
      # qemu guest modules: "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" 
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ]; 
    };
    kernelModules = [ "kvm-amd" ];
  };
  # ---

  # bluetooth:
  hardware.bluetooth = {
    enable = true;
    settings = {
    General = {
        ControllerMode = "bredr";
      };
    };
  };
  # ----
}
