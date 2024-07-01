# networking options
{
  config,
  lib,
  pkgs,
  netport,
  vlans,
  ...
}: let
  vlan_management_name = "vlan${builtins.toString (builtins.elemAt vlans 0)}mngmnt";
  vlan_cloudflared_name = "vlan${builtins.toString (builtins.elemAt vlans 1)}cloudfld";
  vlan_local_container_name = "vlan${builtins.toString (builtins.elemAt vlans 2)}cont";
in {
  services.cloudflared = {
    enable = true;
    #tunnel."42c80f70-deb9-49b0-8fbe-606da328921e" = {

    #};
  };

  networking = {
    hostName = "nixos-server-hp";
    useNetworkd = true;
    /*
    vlans = {
      ${vlan_management_name} = { id= builtins.elemAt vlans 0 ; interface="${netport}"; };
      ${vlan_cloudflared_name} = { id=builtins.elemAt vlans 1; interface="${netport}"; };
      ${vlan_local_container_name} = { id=builtins.elemAt vlans 2; interface="${netport}"; };
    };
    */
    # set firewall settings:
    firewall = {
      enable = true; # set to false to disable

      allowedTCPPorts = [];
      allowedUDPPorts = [];

      interfaces."${vlan_management_name}" = {
        # define allowed ports:
        allowedTCPPorts = [22001 53];
        allowedUDPPorts = [53];
        # ---
      };
    };
    # ---
  };
  services.openssh.listenAddresses = [
    {
      addr = "192.168.0.130";
      port = 22001;
    }
  ]; # mngmt address, unable to let this be dynamically determined as dhcpd encodes its lease file...

  # we will use systemd networkd for the configuration of the network interface
  # --> see: https://nixos.wiki/wiki/Systemd-networkd

  systemd.network = {
    enable = true;
    netdevs = {
      "20-${vlan_management_name}_init" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "${vlan_management_name}";
        };
        vlanConfig.Id = builtins.elemAt vlans 0;
      };
      "20-${vlan_cloudflared_name}_init" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "${vlan_cloudflared_name}";
        };
        vlanConfig.Id = builtins.elemAt vlans 1;
      };
      "20-${vlan_local_container_name}_init" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "${vlan_local_container_name}";
        };
        vlanConfig.Id = builtins.elemAt vlans 2;
      };
    };

    networks = let
      networkConfig = {
        # we put global configuration that is valid for all network interfaces here
        #DHCP = "ipv4";
        DNSOverTLS = "yes";
        DNS = ["1.1.1.2" "1.0.0.2"];
      };
    in {
      "30-${netport}_conf" = {
        matchConfig.Name = "${netport}";
        vlan = [
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
        address = ["192.168.0.130/30"];
        routers = [{routeConfig.Gateway = "192.168.0.129";}];
        inherit networkConfig;
        linkConfig.RequiredForOnline = "yes";
      };
      "40-${vlan_cloudflared_name}_conf" = {
        matchConfig.Name = "${vlan_cloudflared_name}";
        #inherit networkConfig;
        linkConfig.RequiredForOnline = "yes";
      };
      "40-${vlan_local_container_name}_conf" = {
        matchConfig.Name = "${vlan_local_container_name}";
        #inherit networkConfig;
        linkConfig.RequiredForOnline = "enslaved"; # enslaved => the link is required by another link, in this case the container bridges
      };
    };
  };
  # the basic logic of the networs is as follows router -> trunk switch -> laptop interface -> vlans -> bridges -> containers
  # the bridges are in effect a "switch" that are linked to the vlan, the vlan is tags the packets coming from the bridges and sends them out the laptop interface
  # in the case of mgmt this is not needed since we are not going to need more than 1 ip
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug"; # enable higher loglevel on networkd (for troubleshooting)
}
