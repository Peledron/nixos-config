# drive config

{ config, lib, pkgs, disko, disks, ... }:
{
  # using zfs, following from https://www.reddit.com/r/NixOS/comments/ruyunj/comment/hr4lijv/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button 
  disko.devices = {
    disk.Aroot = {
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
              passwordFile = "/nix/keys/nixos-main.passwd"; # if you want this to be a password use echo -n "password" > /tmp/nixos-main.key , the -n is very important as it removes the trailing newline
              # no keyfile will be specified as there will only be a password for this disk
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
              passwordFile = "/nix/keys/nixos-persist.passwd"; # initial encryption key 
              settings= {
                allowDiscards = true;
                keyFile = "/nix/keys/nixos-persist.key"; # generated using openssl-genrsa -out 
              };
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
              passwordFile = "/nix/keys/data-home.passwd";
              settings = { 
                allowDiscards = true;
                keyFile = "/nix/keys/data-home.key"; # path to the disk encryption key (for boot)
              };
              content = {
                type = "btrfs";
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
  fileSystems = {
    "/nix".neededForBoot = true;
    "/persist".neededForBoot = true;
  };
}
