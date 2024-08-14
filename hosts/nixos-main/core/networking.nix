# networking options
{
  lib,
  self,
  hostName,
  ...
}: {
  networking = lib.mkDefault {
    useDHCP = true; # set all interfaces to use dhcp by default
    hostName = "${hostName}"; # Define your hostname
    networkmanager.enable = true; # Easiest to use and most distros use this by default
  };
  systemd.network.wait-online.timeout = 0; # Time to wait for the network to come online, in seconds. Set to 0 to disable, it slows down boot and since this is a desktop machine there is no need for this service (as far as I understand)
}
