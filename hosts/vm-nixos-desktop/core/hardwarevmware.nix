{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  #imports =
  #  [(modulesPath + "/profiles/qemu-guest.nix")]
  #  ++ [(modulesPath + "/virtualisation/qemu-guest-agent.nix")] # guest agent for qemu:
  #;
  #[(modulesPath + "/virtualisation/hyperv-guest.nix")] # guest agent for hyperv
  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  #hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; # change to intel if that is used insead
  # ---

  # kernel modules:
  #boot.initrd.kernelModules = [ "kvm-amd" ];   # add kernel modules for amdgpu or nvidia_drm, etc..
  boot = {
    initrd = {
      # modules that are enabled in the initrd (when the kernel is loaded from the efi partition)
      availableKernelModules = ["ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod"];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];
  };
  # ---

  #enable vmware guest support
  virtualisation.vmware.guest.enable = true;

  # power settings:
  powerManagement.cpuFreqGovernor = "performance";
}
