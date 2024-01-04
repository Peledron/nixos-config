# networking options

{ config, lib, pkgs, netport, vlans, ... }:
let
  br_management_name = "br${builtins.toString (builtins.elemAt vlans 0)}mngmnt";
  br_cloudflared_name = "br${builtins.toString (builtins.elemAt vlans 1)}cloudfld";
  br_local_container_name = "br${builtins.toString (builtins.elemAt vlans 2)}cont";
in
{
  
  services.cloudflared = {
    enable = true;
    #tunnel."42c80f70-deb9-49b0-8fbe-606da328921e" = {
      

    #};
  };

  networking = {
    hostName = "nixos-server-hp";
    useNetworkd = true;
    # set firewall settings:
    nftables.enable = true; # enable nftables
    firewall = {
      enable = true; # set to false to disable
      interfaces."${vlan_management_name}" = {
        # define allowed ports:
        allowedTCPPorts = [ 22001 ];
        allowedUDPPorts = [];
        # ---
      };
      #allowedTCPPorts = [];
      #allowedUDPPorts = [];
    };
    # ---
  };

  # we will use systemd networkd for the configuration of the network interface
  # --> see: https://nixos.wiki/wiki/Systemd-networkd
  systemd.network = {
    enable = true; 
    netdevs = {
      "20-${br_management_name}_init" = {
         netdevConfig = {
           Kind = "bridge";
           Name = "${br_management_name}";
         };
          extraConfig = ''
          [Bridge]
          VLANFiltering=true 
        '';
       };
    };

    networks =  let networkConfig = {
      # we put global configuration that is valid for all network interfaces here
      DHCP = "ipv4"; 
      DNSOverTLS = "yes"; 
      DNS = [ "1.1.1.1" "1.0.0.1" ]; 
    }; 
    in {
      "30-eno1_outgoing-port_conf" = {
        matchConfig.Name = "${netport}";
        networkConfig = { 
          Bridge = [
            "${br_management_name}"
            "${br_cloudflared_name}"
            "${br_local_container_name}"
          ]; 
          LinkLocalAddressing = "no"; # disable link-local address autoconfiguration};
        };
        linkConfig.RequiredForOnline = "carrier"; # requiredForOnline tells networkd that a carrier link is needed for network.target
          # --> see https://www.freedesktop.org/software/systemd/man/latest/networkctl.html# for an overview of the possible link states
          # --> see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html#RequiredForOnline= for more info about RequiredForOnline
      };

        systemd.network.networks."30-int-ring" = { 
          matchConfig = { 
            Name = "br-ring";
          };  
          address = [ 
            "10.42.13.1/24"
          ];  
        };  

  # VM Network mon0
  systemd.network.netdevs."40-veth-vlan100-mon0" = { 
    netdevConfig = { 
      Kind = "veth";
      Name = "br-mon0-v100";
    };  
    peerConfig = { 
      Name = "pe-mon0-v100";
    };  
  };  
  systemd.network.networks."45-veth-mon0" = { 
    matchConfig = { 
      Name = "pe-mon0-v100";
    };  
    networkConfig = { Bridge = "br-ring"; };
    linkConfig = { RequiredForOnline = false; };
    extraConfig = ''
      [BridgeVLAN]
      VLAN=100
    '';
  };  
  };
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug"; # enable higher loglevel on networkd (for troubleshooting)
}
