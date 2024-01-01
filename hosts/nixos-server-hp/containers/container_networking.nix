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
  virtualisation.docker.extraOptions  = "--iptables=False"; # disable iptables, manual NATing is needed for docker networking to work, see below
  # setup container networks
  networking = {
    nat = {
      enable = true;
      internalInterfaces = ["ve-+" "vb-+"];
      externalInterface = "${vlan_local_container_name}";
      # Lazy IPv6 connectivity for the container
      #enableIPv6 = true;
    };
   
    firewall = {
      # allow nat masquerade on interface
      #extraCommands = ''
        #nftables -t nat -A POSTROUTING -o ${net-local-container-interface} -j MASQUERADE
      #'';
      interfaces."${vlan_local_container_name}@${netport}" = {
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
