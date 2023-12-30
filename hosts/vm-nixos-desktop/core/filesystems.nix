# drive config
{ config, lib, pkgs, disko, disks, ... }:
{
  # set encrypted volume to be mounted as nixos-main at boot
  #boot.initrd.luks.devices."nixos-main".device = "/dev/disk/by-label/crypted-main-nixos";
  # -> encryption does not really make sense inside the vm, it is best to encrypt the qcow2 image itself or the drive it resides on, maybe for thin-provisioning?

  # btrfs subvolumes: @, @var, @tmp, @srv, @opt, @nix, @home, @usr-local
  # --> see https://nixos.wiki/wiki/Btrfs for a full guide
  # --> note that the only subvolumes we really need are root (@ in this case), nix (@nix, where the nix store and other nix functions are, arguably more important then @root) and home (@home)
  # --> you should keep snapshots of @ and @nix and (depending on preference) @home

  # as this is vm we will use disko to format the disk, this would take definition with UUID for a system with multible os's (like nixos-laptop-asus for example)
  disko.devices = lib.mkForce {
    disk = {
      root = {
        type = "disk";
        device = builtins.elemAt disks 0; # this selects the first entry in the disks array that we defined in ${self}/default.nix
        content = {
          type = "gpt"; # set the partition table

          partitions = {

            # partitions will be declared here:
            NIXOS_EFI = {
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

            NIXOS_MAIN = {
              # see https://github.com/nix-community/disko/blob/master/example/luks-btrfs-subvolumes.nix for luks implementation
              size = "100%"; # use 100% of remaining diskspace in ${diskname}
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partitions
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # "home/pengolodh" {}; # Sub(sub)volume doesn't need a mountpoint as its parent is mounted

                  # impermanence
                   "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/persist/libvirt" = {
                      mountpoint = "/var/lib/libvirt"; # im going to do this entire folder, this is put into a different subvol so I can disable compression and set the commit to a higher value, to increase performance
                      mountOptions = [ "noatime" "commit=120" ];
                  };
                  "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # ---

                  "/swap" = {
                    mountpoint = "/.swapvol"; # make it hidden cuz it has no use not being so
                    swap = {
                      swapfile.size = "4G";
                      # you can declare multible swapfiles, idk why you would do that...
                    };
                  };
                };
                postCreateHook = "mount /dev/disk/by-partlabel/disk-root-NIXOS_MAIN /mnt ; btrfs subvolume snapshot -r /mnt/root /mnt/root-blank; umount /mnt";
              };
            };
            # declare more partitons here:

          };
        };
      };
      # use more disks here:

    };
  };
  fileSystems = {
    "/persist".neededForBoot = true;
  };

  # we are using btrfs so we can enable the scrub service here, as it is filesystem dependant
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ]; # if home is on a separate drive or not a subvolume of another location then you can add it to the list (unlike above where /nix and /home are nested subvolumes under / you only need to scrub / -> scrub is per drive or whole partition)
  };
  # ---
}
