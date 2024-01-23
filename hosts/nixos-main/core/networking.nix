# networking options

{ config, lib, pkgs, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true; # set all interfaces to use dhcp by default
    # define hostname and enable networkmanager
    #hostId="1e772256"; # needed for zfs, so it knows which device to mount to, command used: head -c 8 /etc/machine-id
    hostName = "nixos-main"; # Define your hostname
    wireless.enable = true;
    networkmanager.enable = true;  # Easiest to use and most distros use this by default
    # ---

    
    # set firewall settings:

    firewall = {
      enable = true; # set to false to disable
      # define allowed ports:
      allowedTCPPorts = [
        22001 # ssh port
      ];
      allowedUDPPorts = [
        #51820 # wireguard port
      ];
      # ---
    };
    # ---

    # set wireguard config
    /*
    wg-quick.interfaces = {
      wg0 = {
        address = [ "172.16.0.6/32" ];
        dns = [ "1.1.1.1" ];
        privateKeyFile = "/root/wireguard-keys/wg_asus-nixos.key";

        peers = [
          {
            publicKey = "TiW1dNArzZIudtHrtIYXHtogDNRZY4lGjfeNw1qJ9jk=";
            #presharedKeyFile = "/root/wireguard-keys/preshared_from_peer0_key";
            allowedIPs = [ "0.0.0.0/0"];
            endpoint = ":13231";
            persistentKeepalive = 25;
          }
        ];
      };
    };
    */
  };
}
