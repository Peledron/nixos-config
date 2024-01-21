# drive config

{ config, lib, pkgs, disko, disks, ... }:
{
  # set encrypted volume to be mounted as nixos-main at boot
  boot.initrd.luks.devices."nixos-main".device = "/dev/disk/by-label/cr-main-nixos";
  
  # using zfs, following from https://www.reddit.com/r/NixOS/comments/ruyunj/comment/hr4lijv/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button 
  disko.devices = {
    disk.main = {
      device = builtins.elemAt disks 0;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
              name = "NIXOS_EFI";
              size = "512M";
              type = "EF00"; # efi partition type
              content = {
                # here we will tell it the filesystem type and mountpoint
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
          };
          cr_nixos-main = {
            size = "20G";
            content = {
              type = "luks";
              name = "cr_nixos-main";
              settings = {
                  allowDiscards = true;
                  keyFile = "/persist/nix-store.key";
              };
              content = {
                type = "filesystem";
                format = "xfs"; 
                mountpoint = "/nix";
              };
            };
          };
          cr_nixos-persist = {
            size = "40G";
            content = {
              type = "luks";
              name = "cr_nixos-persist";
              settings.allowDiscards = true;
              passwordFile = "/tmp/secret.key";
              content = {
                type = "filesystem";
                format = "xfs"; 
                mountpoint = "/persist";
              };
            };
          };
          cr_swap = {
            size = "16G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
          
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=8G"
        "defaults"
        "mode=755"
      ];
    }; # root will be on a tmpfs, meaning that it is impermament
  };
  # ---

}
