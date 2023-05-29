{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [(modulesPath + "/profiles/qemu-guest.nix")]
    ++ [(modulesPath + "/virtualisation/qemu-guest-agent.nix")] # guest agent for qemu:
  ;
  #[(modulesPath + "/virtualisation/hyperv-guest.nix")] # guest agent for hyperv
  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; # change to amd if that is used insead
  # ---

  # kernel modules:
  #boot.initrd.kernelModules = [ "kvm-amd" ];   # add kernel modules for amdgpu or nvidia_drm, etc..
  boot = {
    initrd = { # modules that are enabled in the initrd (when the kernel is loaded from the efi partition)
      availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
      kernelModules = [ "kvm-intel" ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
  # ---

  # nvidia:
  /*
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  
  # if you need specific version (ie from unstable for stable branches)
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiapackages.stable;
  */
  # ----

  # virtualisation guest tools:
  # guest agent for spice:
  environment.systemPackages = with pkgs; [
    # xorg.xf86videoqxl # qxl video driver for xorg
    spice-vdagent # for clipboard sharing with host
  ];
  #services.xserver.videoDrivers = [ "qxl" ]; # enable qxl video driver, warning do not enable it fucks up the entire vm
  services.spice-vdagentd.enable = true;
  programs.spice-vdagent.enable = true;
  # ----

  # power settings:
  powerManagement.cpuFreqGovernor = "performance";
}
