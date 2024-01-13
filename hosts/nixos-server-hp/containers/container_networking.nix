{ config, lib, pkgs, system, inputs, netport, vlans, ... }:   
let
  vlan_local_container_name = "vlan${builtins.toString (builtins.elemAt vlans 2)}cont";
  br_local_container_name = "br0cont";
in
{
  # enable ip forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1; 
  #boot.kernel.sysctl."net.ipv6.ip_forward" = 1;
  # setup container networks
  networking = {
    bridges."${br_local_container_name}".interfaces = [ "${vlan_local_container_name}" ];
    interfaces."${br_local_container_name}".useDHCP = true;
  /*
    nat = {
      enable = true;
      internalInterfaces = ["ve-+" "vb-+"];
      externalInterface = "${vlan_local_container_name}";
      # Lazy IPv6 connectivity for the container
      #enableIPv6 = true;
      forwardPorts = [
        {
          sourcePort = 80;
          proto = "tcp";
          destination = "${config.containers.monitor.localAddress}:80";
        }
      ];
    };
    nftables.ruleset = ''
        table ip nat {
          chain PREROUTING {
            type nat hook prerouting priority dstnat; policy accept;
            iifname "${vlan_local_container_name}" tcp dport 80 dnat to ${config.containers.monitor.localAddress}:80
          }
        }
    '';
    */
    firewall = {
      interfaces."${vlan_local_container_name }" = {
        # define allowed ports:
        allowedTCPPorts = [  
          80 # grafana monitor container ingress
        ];
        allowedUDPPorts = [];
        # ---
      };
    };
  };
}
