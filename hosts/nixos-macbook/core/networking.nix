# networking options

{ config, lib, pkgs, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true; # set all interfaces to use dhcp by default
    # define hostname and enable networkmanager
    hostName = "nixos-macbook"; # Define your hostname
    networkmanager.enable = true;  # Easiest to use and most distros use this by default
    # ---

    # define interface specific settings like ip addresses
    /*
    interfaces = {
      eno1 = {
        useDHCP = false; # disable DHCP for this interface if we want to use static IP conf
        ip4.addresses [{
          address = "192.168.0.150"; # change to what you want
          prefixLength = 24; # subnetmask
        }];    
      };
      # ---  
    };
    */
    # ---

    # set default gateway
    #defaultGateway = "192.168.0.1"; # does not need to be configured if DHCP is enabled
    # ---
    
    # set dns servers 
    nameservers = [ 
      "1.1.1.1"
      "8.8.8.8"
    ];
    # ---
    
    # set firewall settings:

    firewall = {
      #enable = true; # set to false to disable
      # define allowed ports:
      #allowedTCPPorts = [];
      allowedUDPPorts = [
        51820 # wireguard port
      ];
      # ---
    };
    # ---

    # set wireguard config
    networking.wireguard.interfaces = {
      wg0 = {
        # Determines the IP address and subnet of the client's end of the tunnel interface.
        ips = [ "172.16.0.4/32" ];
        listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

        # Path to the private key file.
        #
        # Note: The private key can also be included inline via the privateKey option,
        # but this makes the private key world-readable; thus, using privateKeyFile is
        # recommended.
        privateKeyFile = "../../../.secrets/wireguard/wg_nixos-macbook.key";

        peers = [
          # For a client configuration, one peer entry for the server will suffice.

          {
            # Public key of the server (not a file path).
            publicKey = "TiW1dNArzZIudtHrtIYXHtogDNRZY4lGjfeNw1qJ9jk=";

            # Forward all the traffic via VPN.
            allowedIPs = [ "0.0.0.0/0" ];
            # Or forward only particular subnets
            #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

            # Set this to the server IP and port.
            endpoint = "78.22.99.166:13231"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            persistentKeepalive = 25;
          }
        ];
      };
  };
}
