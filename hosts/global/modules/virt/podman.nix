{
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation = {
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
  environment.systemPackages = with pkgs; [
    podman-compose
    distrobox
  ];
}