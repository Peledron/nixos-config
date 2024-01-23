{ config, lib, pkgs, system, inputs, impermanence, disko, disks, ... }:
{
    # root partition is hosted on tmpfs, it is cleared by default on reboots (since it resides in memory)

    environment.persistence."/persist" = {
        hideMounts = true; # For added security and less clutter in the system
        directories = [
            "/etc/libvirt" # persist the libvirt configuration directory
            "/etc/NetworkManager/system-connections"
            "/var/log" # perserve the system logs
            "/var/lib/nixos" 
            "/var/lib/systemd/coredump" # perserve the coredump on reboots
            "/var/lib/docker"
            "/var/lib/upower"
            "/var/lib/bluetooth"
            "/var/lib/libvirt"
        ];
        files = [
            "/etc/machine-id"
            "/etc/adjtime"
            # network manager is enabled so we need the following files to be persistent for wifi
            "/var/lib/NetworkManager/secret_key"
            "/var/lib/NetworkManager/seen-bssids"
            "/var/lib/NetworkManager/timestamps"
        ];
    };

    # disable sudo lecture, it is the warning message that displays the first time you use the sudo command
    security.sudo.extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never
    '';
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
    /*networking.wireguard.interfaces.wg0 = {
            generatePrivateKeyFile = true;
            privateKeyFile = "/persist/etc/wireguard/wg0";
    };*/ # uncomment if wireguard is used
}
