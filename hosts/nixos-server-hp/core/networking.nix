# networking options

{ config, lib, pkgs, netport, vlans, ... }:
let
  vlan_management_name = "vlan${builtins.toString (builtins.elemAt vlans 0)}mngmnt";
  vlan_cloudflared_name = "vlan${builtins.toString (builtins.elemAt vlans 1)}cloudfld";
  vlan_local_container_name = "vlan${builtins.toString (builtins.elemAt vlans 2)}cont";
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
    /*
    macvlans = {
      ${vlan_management_name} = { id= builtins.elemAt vlans 0 ; interface="${netport}"; };
      ${vlan_cloudflared_name} = { id=builtins.elemAt vlans 1; interface="${netport}"; };
      ${vlan_local_container_name} = { id=builtins.elemAt vlans 2; interface="${netport}"; };
    };
    interfaces = {
      ${vlan_management_name}.useDHCP = true;
      ${vlan_cloudflared_name}.useDHCP = true;
      ${vlan_local_container_name}.useDHCP = true;
    };
    */
    # set firewall settings:
    firewall = {
      enable = true; # set to false to disable
      
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      
      interfaces."${vlan_management_name}" = {
        # define allowed ports:
        allowedTCPPorts = [ 22001 ];
        allowedUDPPorts = [];
          # ---
      };
      
    };
      # ---
  };
  services.openssh.listenAddress = "192.168.0.130"; # mngmt address, unable to let this be dynamically determined as dhcpd encodes its lease file... 
  # we will use systemd networkd for the configuration of the network interface
  # --> see: https://nixos.wiki/wiki/Systemd-networkd
  systemd.network = {
    enable = true; 
    netdevs = {
      "20-${vlan_management_name}_init" = {
        netdevConfig = {
          Kind = "macvlan";
          Name = "${vlan_management_name}";
        };
        vlanConfig.Id = builtins.elemAt vlans 0;
      };
      "20-${vlan_cloudflared_name}_init" = {
        netdevConfig = {
          Kind = "macvlan";
          Name = "${vlan_cloudflared_name}";
        };
        vlanConfig.Id = builtins.elemAt vlans 1;
      };
      "20-${vlan_local_container_name}_init" = {
        netdevConfig = {
          Kind = "macvlan";
          Name = "${vlan_local_container_name}";
        };
        vlanConfig.Id = builtins.elemAt vlans 2;
      };
    };

    networks =  let networkConfig = {
      # we put global configuration that is valid for all network interfaces here
      DHCP = "ipv4"; 
      DNSOverTLS = "yes"; 
      DNS = [ "1.1.1.1" "1.0.0.1" ]; 
    }; 
    in {
      "30-${netport}_conf" = {
        matchConfig.Name = "${netport}";
        macvlan = [
          "${vlan_management_name}"
          "${vlan_cloudflared_name}"
          "${vlan_local_container_name}"
        ];
        networkConfig.LinkLocalAddressing = "no"; # disable link-local address autoconfiguration
        linkConfig.RequiredForOnline = "carrier"; # requiredForOnline tells networkd that a carrier link is needed for network.target
          # --> see https://www.freedesktop.org/software/systemd/man/latest/networkctl.html# for an overview of the possible link states
          # --> see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html#RequiredForOnline= for more info about RequiredForOnline
      };
      "40-${vlan_management_name}_conf" = {
        matchConfig.Name = "${vlan_management_name}";
        inherit networkConfig;
        linkConfig.RequiredForOnline = "yes";
      };
      "40-${vlan_cloudflared_name}_conf" = {
        matchConfig.Name = "${vlan_cloudflared_name}";
        inherit networkConfig;
        linkConfig.RequiredForOnline = "yes";
      };
      "40-${vlan_local_container_name}_conf" = {
        matchConfig.Name = "${vlan_local_container_name}";
        inherit networkConfig;
        linkConfig.RequiredForOnline = "yes";
      };  
    };
  };
  
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug"; # enable higher loglevel on networkd (for troubleshooting)
}
