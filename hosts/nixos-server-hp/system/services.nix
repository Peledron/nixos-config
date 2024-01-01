# important system services

{ config, lib, pkgs, ... }:
{
  # disable autosuspend on lid close so we can use the laptop as a server
  services.logind.lidSwitch = "ignore";
  services.auto-cpufreq.enable = true;
  services.virtualisation.docker.extraOptions  = "--iptables=False"; # disable iptables, manual NATing is needed for docker networking to work (see containers/container_networking.nix)
}
