{
  lib,
  hostName,
  ...
}: {
  networking = {
    useDHCP = lib.mkDefault true;
    hostName = hostName; # Define your hostname
  };
}
