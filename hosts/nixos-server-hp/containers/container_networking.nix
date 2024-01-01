{ config, lib, pkgs, system, inputs, netport, ... }:   
let 
  net-local-container-interface = "vlan114@${netport}";
  net-cloudflared-interface= "vlan113@${netport}";
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
      externalInterface = "${net-local-container-interface}";
      # Lazy IPv6 connectivity for the container
      #enableIPv6 = true;
    };
    nftables.ruleset = ''
      table ip nat {
        chain prerouting {
          type nat hook prerouting priority 0; policy accept;
        }

        # for all packets to WAN, after routing, replace source address with primary IP of WAN interface
        chain postrouting {
          type nat hook postrouting priority 100; policy accept;
          oifname "${net-local-container-interface}" masquerade
    ''; # modified from https://wiki.gentoo.org/wiki/Nftables/Examples, also see: https://discourse.nixos.org/t/is-it-possible-to-write-custom-rules-to-the-nixos-firewall/27900/4 for a bunch of nixos examples of nftables ruleset

    firewall = {
      # allow nat masquerade on interface
      #extraCommands = ''
        #nftables -t nat -A POSTROUTING -o ${net-local-container-interface} -j MASQUERADE
      #'';
      interfaces."${net-local-container-interface}" = {
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
