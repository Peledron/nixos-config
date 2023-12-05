# important system services

{ config, lib, pkgs, ... }:
{
  # ssh is enabled globally, you can override  its settings, or disable it here:
  /*
  services.openssh = {
    enable = true;
    settings = {
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false; # Change to false to disable s/key passwords
      permitRootLogin = "no";
    };
    ports = [ 22001 ];
  };
  */
  #---

  # disable auto-cpufreq and powermanagement as this is vm
  # we defined this in core/desktop/system/services.nix as mkdefault (meaning it has a priority of 1000, the default priority in nixos is 100, and mkforce sets it to 50, mkbefore is 500 and mkafter is 1500)
  # => lower priority value means this overrides the default value
  services.auto-cpufreq.enable = false;
  powerManagement.enable = false;

}
