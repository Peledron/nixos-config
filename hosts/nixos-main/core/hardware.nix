{ config, lib, pkgs, modulesPath, ... }:
{
  
  imports =[ (modulesPath + "/installer/scan/not-detected.nix") ];
  
  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; 
  # ---

  # kernel modules:
  boot = {
    initrd = { # modules that are enabled during early load in the initrd (when the kernel is loaded from the efi partition)
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "aesni_intel" "cryptd" ]; # aesni and cryptd enable the aes accelerated drivers on early boot, so the system boots faster
      kernelModules =  ["dm-snapshot" ]; 
      # systemd.enable = true; # -> will startup systemd during stage 1 (allows things like plymouth to load early for password entry), boots slightly slower?
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
