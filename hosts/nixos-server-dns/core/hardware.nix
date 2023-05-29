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

  # graphics:
  # --> video accel (see https://nixos.wiki/wiki/Accelerated_Video_Playback)
  /*
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      #intel-media-driver # LIBVA_DRIVER_NAME=iHD --> broadwell+ (>=5th gen), laptop uses hd graphics (<= 4th gen)
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium) 
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.variables = { LIBVA_DRIVER_NAME = "i965"; };
  */
}
