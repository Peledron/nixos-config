# networking options

{ config, lib, pkgs, ... }:
{
  
  services.cloudflared = {
    enable = true;
    #tunnel."42c80f70-deb9-49b0-8fbe-606da328921e" = {
      

    #};
  };
  networking = {
    hostName = "nixos-server-dns";

    # set firewall settings:
    firewall = {
      enable = true; # set to false to disable

      # define allowed ports:
      allowedTCPPorts = [ 22001 ];
      allowedUDPPorts = [];
      # ---
    };
    # ---
  };

  # we will use systemd networkd for the configuration of the network interface
  # --> see: https://nixos.wiki/wiki/Systemd-networkd
  systemd.network={
    netdevs = {
      "20-vlan112-nixos-server_init" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan112-nixos-server";
        };
        vlanConfig.Id = 112;
      };
      "20-vlan112-nixos-server_cloudflared_init" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan113-nixos-server_cloudflared";
        };
        vlanConfig.Id = 113;
      };
    };

    networks = {
      "30-eno1_outgoing-port_conf" = {
        matchConfig.Name = "eno1";
        # tag vlan on this link
        vlan = [
          "vlan112-nixos-server"
          "vlan113-nixos-server_cloudflared"
        ];
        networkConfig.LinkLocalAddressing = "no"; # disable link-local address autoconfiguration
        linkConfig.RequiredForOnline = "carrier"; # requiredForOnline tells networkd that a carrier link is needed for network.target, "carrier" in this case means that the vlans need to be online for network.target to complete
          # --> see https://www.freedesktop.org/software/systemd/man/latest/networkctl.html# for an overview of the possible link states
          # --> see https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html#RequiredForOnline= for more info about RequiredForOnline
      };

      "40-vlan112-nixos-server_conf" = {
        matchConfig.Name = "vlan112-nixos-server";
        # add relevant configuration here
        networkConfig.DHCP = "yes"; # tell interface to acquire a dhcp link
        linkConfig.RequiredForOnline = "yes"; # needed for network.target to be reached
      };
      "40-vlan112-nixos-server_cloudflared_conf" = {
        matchConfig.Name = "vlan113-nixos-server_cloudflared";
        # add relevant configuration here
        networkConfig.DHCP = "yes"; # tell interface to acquire a dhcp link
        linkConfig.RequiredForOnline = "yes"; # needed for network.target to be reached
      };
    };
  };
}
