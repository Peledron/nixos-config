# drive config

{ config, lib, pkgs, ... }:
{
  # set encrypted volume to be mounted as nixos-main at boot
  boot.initrd.luks.devices."nixos-main".device = "/dev/disk/by-label/crypted-main-nixos";
  
  # btrfs subvolumes: @, @var, @tmp, @srv, @opt, @nix, @home, @usr-local
  # --> see https://nixos.wiki/wiki/Btrfs for a full guide
  # --> note that the only subvolumes we really need are root (@ in this case), nix (@nix, where the nix store and other nix functions are, arguably more important then @root) and home (@home)
  # --> you should keep snapshots of @ and @nix and (depending on preference) @home
  fileSystems = {
    #==================#
    # root:
    "/" = {
      device = "/dev/mapper/nixos-main";
      fsType = "btrfs";

      options = [ "subvol=root" "compress=zstd" ];
    };
    "/nix" = {
      device = "/dev/mapper/nixos-main";
      fsType = "btrfs";

      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };
    #==================#
    # home:
    "/home" = {
      device = "/dev/mapper/nixos-main";
      fsType = "btrfs";

      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };
    #==================#
    # swap:
    # --> see "add swap" for swap device rules
    "/swap" = {
      device = "/dev/mapper/nixos-main";
      fsType = "btrfs";

      options = [ "subvol=swap" ];
    };
    #==================#
    # boot:
    "/boot" = {
      device = "/dev/disk/by-label/EFI-NIXOS";
      fsType = "vfat";
    };
  };
  # ---

  # add swap:
  swapDevices = [ { device = "/swap/swapfile"; } ];
  # --- 
}
