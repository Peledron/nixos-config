{ config, lib, pkgs, modulesPath, ... }:
{
  
  imports =[ (modulesPath + "/installer/scan/not-detected.nix") ];
  
  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; # change to amd if that is used insead
  # ---

  # kernel modules:
  boot = {
    initrd = { # modules that are enabled during early load in the initrd (when the kernel is loaded from the efi partition)
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "aesni_intel" "cryptd" ];
      kernelModules =  ["dm-snapshot" ]; 
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
