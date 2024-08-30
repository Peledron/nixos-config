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
    # utils
    # [system]
    powertop
    # [cli]
    helix

    # filesystem related
    # [btrfs]
    btrfs-progs
    compsize # shows btrfs subvolume compressions
    btdu # sampling disk usage profiler for btrfs (like ncdu)
    snapper # automatic filesystem snapshots, see sys-services for config
    # btrfs-heatmap # cool tools that visualizes btrfs disk usage distribution
  ];
  # in order to use a program with sudo you should do: program.$program.enable = true;
  # --> nix takes over management of the package, it also imports a configured module for the program
  # (see all using nixos-option programs)
}
