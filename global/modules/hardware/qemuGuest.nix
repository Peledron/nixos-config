{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports =
    [(modulesPath + "/installer/scan/not-detected.nix")]
    ++ [(modulesPath + "/profiles/qemu-guest.nix")]
    ++ [(modulesPath + "/virtualisation/qemu-guest-agent.nix")];

  # kernel modules:
  #boot.initrd.kernelModules = [ "kvm-amd" ];   # add kernel modules for amdgpu or nvidia_drm, etc..
  boot = {
    initrd = {
      # modules that are enabled in the initrd (when the kernel is loaded from the efi partition)
      availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
      kernelModules = ["kvm-amd" "aes"];
    };
    kernelModules = [];
    extraModulePackages = [];
  };

  # virtualisation guest tools:
  # guest agent for spice:
  # create the service https://github.com/chewblacka/nixos/blob/main/etc/nixos/configuration.nix
  systemd.user.services.spice-agent = {
    enable = true;
    wantedBy = ["graphical-session.target"];
    serviceConfig = {ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";};
    unitConfig = {
      ConditionVirtualization = "vm";
      Description = "Spice guest session agent";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };
  };

  services.spice-vdagentd.enable = true;

  # ----

  # power settings:
  powerManagement.cpuFreqGovernor = "performance";
}
