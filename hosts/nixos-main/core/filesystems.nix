# drive config

{ config, lib, pkgs, disko, disks, ... }:
{
  # set encrypted volume to be mounted as nixos-main at boot
  boot.initrd.luks.devices."nixos-main".device = "/dev/disk/by-label/cr_nixos-main";
  boot.initrd.luks.devices."nixos-persist".device = "/dev/disk/by-label/cr_nixos-persist";
  boot.initrd.luks.devices."home".device = "/dev/disk/by-label/cr_home";
  
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
            size = "60G";
            content = {
              type = "luks";
              name = "cr_nixos-main";
              settings.allowDiscards = true;
              passwordFile = "/tmp/nixos-main.key"; # if you want this to be a password use echo -n "password" > /tmp/nixos-main.key , the -n is very important as it removes the trailing newline
              content = {
                type = "filesystem";
                format = "xfs"; 
                mountpoint = "/nix";
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
          cr_nixos-persist = {
            size = "100%";
            content = {
              type = "luks";
              name = "cr_nixos-persist";
              settings.allowDiscards = true;
              settings.keyFile = "/tmp/nixos-persist.key"; # generated using openssl-genrsa -out 
              content = {
                type = "filesystem";
                format = "xfs"; 
                mountpoint = "/persist";
              };
            };
          };
        
        };
      };
    };
    disk.home = {
      device = builtins.elemAt disks 1;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          cr_home = {
            size = "100%";
            content = {
              type = "luks";
              name = "cr_home";
              settings.allowDiscards = true;
              settings.keyFile = "/tmp/data-home.key"; 
              content = {
                type = "filesystem";
                format = "btrfs"; 
                extraArgs = [ "-f" ]; # force create the partition
                subvolumes = {
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/home/pengolodh" = {}; # /home is mounted, so home/user does not need to be (it acts as a folder, I assume that the compression will still be applied to the sub-subvolume)
                };
              };
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
