{ config, lib, pkgs, system, inputs, ... }:   
{
    # define the persistent filesystems
    # (see scripts/prepare.sh under ephemeral option)
    fileSystems = {
        "/persist" = {
            device = "/dev/mapper/nixos-main";
            fsType = "btrfs";

            options = [ "subvol=persist" "compress=zstd" "noatime" ];
        };
         "/log" = {
            device = "/dev/mapper/nixos-main";
            fsType = "btrfs";

            options = [ "subvol=log" "compress=zstd" "noatime" ];
        };
        "/var/lib/libvirt/images" = {
            device = "/dev/mapper/nixos-main";
            fsType = "btrfs";

            options = ["subvol=persist/vm_default-images" "noatime" "commit=120" ];
        };
    };

    # clear root subvolume on each boot as per https://grahamc.com/blog/erase-your-darlings/ and https://nixos.wiki/wiki/Btrfs
    boot.initrd.postDeviceCommands = lib.mkAfter ''
        mkdir /mnt
        mount -t btrfs /dev/mapper/nixos-main /mnt
        btrfs subvolume delete /mnt/root
        btrfs subvolume snapshot /mnt/root-blank /mnt/root
    '';
    # set persistence to certain configs
    environment.etc = {
        # network connections
        "NetworkManager/system-connections" = {
            source = "/persist/etc/NetworkManager/system-connections/";
        };
        # libvirt
        "libvirt" = {
            source = "/persist/etc/libvirt";
        };
    };

    systemd.tmpfiles.rules = [
        "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
    ]; # -> you can use systemd tempfiles to create symlinks to pernament directories, needed cuz the etc module only allows for files in etc (duh)

    /*networking.wireguard.interfaces.wg0 = {
        generatePrivateKeyFile = true;
        privateKeyFile = "/persist/etc/wireguard/wg0";
    };*/ # uncomment if wireguard is used
    services.openssh = {
        enable = true;
        # sets nix to use the host keys in the given directory
        hostKeys = [
            {
                path = "/persist/ssh/ssh_host_ed25519_key";
                type = "ed25519";
            }
            {
                path = "/persist/ssh/ssh_host_rsa_key";
                type = "rsa";
                bits = 4096;
            }
        ];
  };
}
