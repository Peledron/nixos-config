# important system services

{ config, lib, pkgs, ... }:
{
  # disable autosuspend on lid close so we can use the laptop as a server
  services.logind.lidSwitch = "ignore";
  services.auto-cpufreq.enable = true;
  #services.logrotate.checkConfig = false; # workaround for a bug

  systemd.services.sshd.after = [ "network-interfaces.target" ]; # sets sshd to boot after network, otherwise it fails at startup due to listenAddress not existing yet
}
