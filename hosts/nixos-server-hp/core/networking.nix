# networking options

{ config, lib, pkgs, netport, ... }:
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
    firewall = {
      enable = true; # set to false to disable
      interfaces."vlan112@${netport}" = {
        # define allowed ports:
        allowedTCPPorts = [ 22001 ];
        allowedUDPPorts = [];
        # ---
      };

     
    };
    # ---
  };

  # we will use systemd networkd for the configuration of the network interface
  # --> see: https://nixos.wiki/wiki/Systemd-networkd
  systemd.network = {
    netdevs = {
      # we specify the vlans and their names
      "20-vlan112-nixos-server_init" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan112";
        };
        vlanConfig.Id = 112;
      };
      "20-vlan113-nixos-server_cloudflared_init" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan113";
        };
        vlanConfig.Id = 113;
      };
      "20-vlan114-nixos-server_local-containers_init" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan114";
        };
        vlanConfig.Id = 114;
      };
    };

    networks =  let networkConfig = {
      # we put global configuration that is valid for all network interfaces here
      DHCP = "yes"; DNSOverTLS = "yes"; DNS = [ "1.1.1.1" "1.0.0.1" ]; 
    }; in {
      "30-eno1_outgoing-port_conf" = {
        matchConfig.Name = "${netport}";
        # tag vlan on this link
        vlan = [
          "vlan112"
          "vlan113"
          "vlan114"
        ];
        networkConfig.LinkLocalAddressing = "no"; # disable link-local address autoconfiguration
        linkConfig.RequiredForOnline = "carrier"; # requiredForOnline tells networkd that a carrier link is needed for network.target, "carrier" in this case means that the vlans need to be online for network.target to complete
          # --> see https://www.freedesktop.org/software/systemd/man/latest/networkctl.html# for an overview of the possible link states
          # --> see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html#RequiredForOnline= for more info about RequiredForOnline
      };

      "40-vlan112-nixos-server_conf" = {
        matchConfig.Name = "vlan112";
        # add relevant configuration here
        inherit networkConfig; # we tell it to use the networkconfig variable we specified
        linkConfig.RequiredForOnline = "yes"; # needed for network.target to be reached
      };
      "40-vlan113-nixos-server_cloudflared_conf" = {
        matchConfig.Name = "vlan113";
        # add relevant configuration here
        inherit networkConfig; 
        linkConfig.RequiredForOnline = "yes"; # needed for network.target to be reached
      };
      "40-vlan114-nixos-server_local-containers_conf" = {
        matchConfig.Name = "vlan114";
        # add relevant configuration here
        inherit networkConfig; 
        linkConfig.RequiredForOnline = "yes"; # needed for network.target to be reached
      };
    };
  };
}
