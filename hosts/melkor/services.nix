# important system services
{...}: {
  services.auto-cpufreq.enable = false;
  powerManagement.enable = false;
  virtualisation.docker.enable = false; # disable docker as I do not need it on a desktop machine
}
