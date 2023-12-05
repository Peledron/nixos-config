# drive config

{ config, lib, pkgs, ... }:
{
  # set encrypted volume to be mounted as nixos-main at boot
  boot.initrd.luks.devices."nixos-main".device = "/dev/disk/by-label/cr-main-nixos";
  
  # using zfs, following from https://www.reddit.com/r/NixOS/comments/ruyunj/comment/hr4lijv/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button 
  fileSystems = {
    #==================#
    # root:
      "/" =
    { device = "rpool/root";
      fsType = "zfs";
    };
    "/nix" =
    { device = "rpool/nix";
      fsType = "zfs";
    };
    "/var" =
    { device = "rpool/var";
      fsType = "zfs";
    };
    "/tmp" =
    { device = "rpool/tmp";
      fsType = "zfs";
    };
    #==================#
    # home:
    "/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };
    #==================#
    # swap:
    # --> see "add swap" for swap device rules
    #==================#
    # boot:
    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
    };
    
  };
  # ---

  # add swap:
  #swapDevices = [ { device = "/swap/swapfile"; } ];
  # --- 

  # zfs autotrim
  services.zfs.trim.enable = true;
}
