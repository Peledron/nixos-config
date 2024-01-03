{ config, lib, pkgs, system, inputs, netport, vlans, ... }:   
let
  vlan_management_name = "vlan${builtins.toString (builtins.elemAt vlans 0)}mngmnt";
  vlan_cloudflared_name = "vlan${builtins.toString (builtins.elemAt vlans 1)}cloudfld";
  vlan_local_container_name = "vlan${builtins.toString (builtins.elemAt vlans 2)}cont";
in
{
  # enable ip forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1; 
  #boot.kernel.sysctl."net.ipv6.ip_forward" = 1;
  # virtualisation.docker.extraOptions  = "--iptables=False"; # disable iptables, manual NATing is needed for docker networking to work, see below
  systemd.network.networks."50-br0_conf" = {
      matchConfig.Name ="br0";
      bridgeConfig = {};
      linkConfig.RequiredForOnline = "carrier";
      # or "routable" with IP addresses configured
      networkConfig = {
        DHCP = "yes";
        DNSOverTLS = "yes"; 
        DNS = [ "1.1.1.1" "1.0.0.1" ]; 
      };
      
  };
  # setup container networks
  networking = {
    /*
    nat = {
    
      enable = true;
      internalInterfaces = ["ve-+" "vb-+"];
      externalInterface = "${vlan_local_container_name}";
      # Lazy IPv6 connectivity for the container
      #enableIPv6 = true;
    };
    nftables.ruleset = ''
      table ip nat {
        chain PREROUTING {
          type nat hook prerouting priority dstnat; policy accept;
          iifname "${vlan_local_container_name}" tcp dport 8080 dnat to 172.24.1.2:80
        }
      }
    '';*/

    firewall = {
      interfaces."${vlan_local_container_name}" = {
        # define allowed ports:
        allowedTCPPorts = [  
          8080 # grafana monitor container ingress
        ];
        allowedUDPPorts = [];
        # ---
      };
    };
 };
}
