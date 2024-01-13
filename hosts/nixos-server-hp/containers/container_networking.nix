{ config, lib, pkgs, system, inputs, netport, vlans, ... }:   
let
  vlan_local_container_name = "vlan${builtins.toString (builtins.elemAt vlans 2)}cont";
  br_contrainer_name = "br0cont";
in
{
  # enable ip forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1; 
  #boot.kernel.sysctl."net.ipv6.ip_forward" = 1;
  # setup container networks
  networking = {
    nat = {
      enable = true;
      internalInterfaces = ["ve-+" "vb-+"];
      externalInterface = "${vlan_local_container_name}";
      # Lazy IPv6 connectivity for the container
      #enableIPv6 = true;
      forwardPorts = [
        {destination = "${config.containers.monitor.localAddress}:8080"; sourcePort = 80;}
      ];
    };
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
