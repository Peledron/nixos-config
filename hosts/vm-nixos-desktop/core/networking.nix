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
    /*
    firewall = {
      enable = true; # set to false to disable

      # define allowed ports:
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      # ---
    };
    */
    # ---

  };
}
