{
  config,
  lib,
  pkgs,
  system,
  inputs,
  extraConfig,
  ...
}: let
  vlan_local_container_name = "vlan${builtins.toString (builtins.elemAt extraConfig.vlans 2)}cont";
  br_local_container_name = "br0cont";
in {
  # enable ip forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  #boot.kernel.sysctl."net.ipv6.ip_forward" = 1;
  # setup container networks
  # -> we will create a bridge that will link all containers to the the container-vlan, each bridge will get a dhcp IP (that will be reserved in the router)
  # the packets that go onto the bridge will be tagged with the vlan and send out the interface
  systemd.network = {
    netdevs = {
      # Create the bridge interface
      "25-${br_local_container_name}_init" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "${br_local_container_name}";
        };
      };
    };
    networks = let
      networkConfig = {
        # we put global configuration that is valid for all network interfaces here
        #DHCP = "yes";
        DNSOverTLS = "yes";
        DNS = ["1.1.1.2" "1.0.0.2"];
      };
    in {
      "40-${vlan_local_container_name}_conf" = {
        networkConfig.Bridge = "${br_local_container_name}";
      };

      "50-${br_local_container_name}_conf" = {
        matchConfig.Name = "${br_local_container_name}";
        address = [
          "192.168.1.2/24"
          "fd00:3::2/64"
        ];
        routes = [
          {routeConfig.Gateway = "192.168.0.129";}
          {routeConfig.Gateway = "fd00:3::1";}
        ];
        inherit networkConfig;
        #
        linkConfig.RequiredForOnline = "routable"; # carrier if no ipv4 or "routable" with IP addresses configured
        #networkConfig.LinkLocalAddressing = "no"; # set this if you do not want ip addressing
      };
    };
  };
  networking = {
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
      interfaces."${br_local_container_name}" = {
        # define allowed ports:
        allowedTCPPorts = [
          80
          443
          53
        ];
        allowedUDPPorts = [
          53
        ];
        # ---
      };
    };
  };
}
