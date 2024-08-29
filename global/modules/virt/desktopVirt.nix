{
  pkgs,
  mainUser,
  ...
}: {
  # virtualisation
  virtualisation = {
    #  --> libvirt:
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm; # limited to x86 system I think
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = with pkgs; [
            (OVMFFull.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
        verbatimConfig = ''
          nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
        '';
      };
    };
    spiceUSBRedirection.enable = true;
  };
  users.users.mainUser.packages = with pkgs; [
    # [cli]
    virt-top # top command but for virtual machine stats
    libguestfs # libguestfs is a tool to access virtual machine disks, idk what the applience does

    # [gui]
    looking-glass-client # best to use this with the kvmfr module for better performance if passing a dedicated gpu and using an igpu on the host
  ];
  programs.virt-manager.enable = true;
  nm-overrides.compatibility.ip-forward.enable = true; # ip forwarding s used by virt-manager
}
