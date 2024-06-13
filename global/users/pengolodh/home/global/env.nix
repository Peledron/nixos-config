{
  config,
  lib,
  pkgs,
  system,
  imputs,
  ...
}: {
  home.sessionVariables = rec {
    # custom vars:
    NIXBIN = "/run/current-system/sw/bin";
    NIXLIB = "/run/current-system/sw/lib";
    USRNIXBIN = "/etc/profiles/per-user/$USER/bin";
  };
}
