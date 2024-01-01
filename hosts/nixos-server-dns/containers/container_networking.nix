{ config, lib, pkgs, system, inputs, netport, ... }:   
let 
  net-egress-interface = "${netport}";
  net-local-container-interface = "vlan114@${netport}";
  net-cloudflared-interface= "vlan113@${netport}";
in 
{
  # enable ip forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1; 
  boot.kernel.sysctl."net.ipv6.ip_forward" = 1;

  # setup container networks
  networking = {
    nat = {
      enable = true;
      internalInterfaces = ["ve-+" "vb-+"];
      externalInterface = "${net-local-container-interface}";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
    firewall = {
      # allow nat masquerade on interface
      extraCommands = ''
        iptables -t nat -A POSTROUTING -o ${net-local-container-interface} -j MASQUERADE
      '';
      interfaces."${net-local-container-interface}" = {
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
