# system packages, accessible by all users, sys-packages holds system specific tools
{
  config,
  lib,
  pkgs,
  ...
}: {
  # see ../users/usr.nix for user specific packages/settings
  # add packages here:
  environment.systemPackages = with pkgs; [
    # arion (docker-compose support)
    #arion
    #docker-client

    # filesystem related
    # [btrfs]
    btrfs-progs
    compsize # shows btrfs subvolume compressions
    btdu # sampling disk usage profiler for btrfs (like ncdu)
    snapper # automatic filesystem snapshots, see sys-services for config
    # btrfs-heatmap # cool tools that visualizes btrfs disk usage distribution
  ];
}
