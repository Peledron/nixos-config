# networking options
{
  config,
  lib,
  pkgs,
  self,
  hostName,
  ...
}: {
  age.secrets.mullvad-wireguard_private-key.file = "${self}/.secrets/global/mullvad-wireguard_private-key.age";
  networking = {
    useNetworkd = true;
    useDHCP = lib.mkDefault true; # set all interfaces to use dhcp by default
    # define hostname and enable networkmanager
    #hostId="1e772256"; # needed for zfs, so it knows which device to mount to, command used: head -c 8 /etc/machine-id
    hostName = "${hostName}"; # Define your hostname
    networkmanager.enable = true; # Easiest to use and most distros use this by default
    # ---

    # set firewall settings:

    firewall = {
      enable = true; # set to false to disable
      # define allowed ports:
      allowedTCPPorts = [
        22001 # ssh port
      ];
      allowedUDPPorts = [
        #51820 # wireguard port
      ];
      # ---
    };
    # ---
    /*
    # set wireguard config
    wg-quick.interfaces = {
      wg0-mullvad = {
        # Device: Exotic Fish
        # --> on mullvad
        address = ["10.64.165.7/32" "fc00:bbbb:bbbb:bb01::1:a506/128"];
        dns = ["100.64.0.23"];
        privateKeyFile = config.age.secrets.mullvad-wireguard_private-key.path;
        # killswitch. doesnt seem to work

        #postUp = ''
        #  ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
        #'';
        #preDown = ''
        #  ${pkgs.iptables}/bin/iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
        #'';

        # ---
        peers = [
          {
            publicKey = "b5A1ela+BVI+AbNXz7SWekZHvdWWpt3rqUKTJj0SqCU=";
            allowedIPs = ["0.0.0.0/0" "::0/0"];
            endpoint = "[2001:ac8:27:92::a03f]:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
    */
  };
}
