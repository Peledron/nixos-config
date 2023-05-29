# important system services

{ config, lib, pkgs, ... }:
{
  # disable autosuspend on lid close so we can use the laptop as a server
  services.logind.lidSwitch = "ignore";

  # nice daemon
  # --> need to see if there is an easy way to input large rulesets like https://github.com/CachyOS/ananicy-rules
  services.ananicy = {
    package = pkgs.ananicy-cpp;
    enable = true;
    #extraRules = {}; # for extra rules --> list would be too large to import things like community rulesets, the default ruleset from ananicy is imported
  };
  # ---

  # virtualisation
  virtualisation = {
    #  --> libvirt:
    libvirtd = {
      enable = true;
    };

    #  --> podman:
    docker.enable = false; # disable docker for arion support (as per https://docs.hercules-ci.com/arion/)
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers.backend = "podman";
  };
  # ----

}
