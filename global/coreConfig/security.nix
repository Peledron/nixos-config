{
  config,
  lib,
  pkgs,
  mainUser,
  ...
}: {
  networking.firewall = lib.mkDefault {
    enable = true;
    allowedTCPPorts = config.services.openssh.ports;
  };
  security = lib.mkDefault {
    polkit.enable = true;
    sudo.enable = false; # disable sudo by default
    doas = {
      enable = true;
      wheelNeedsPassword = true;
      /*
      extraRules = [
        # creates a rule for user to persist passwords after prompting a single time (per session)
        {
          users = [ "pengolodh" ];
          keepEnv = true; # Optional, retains environment variables while running commands
          persist = true; # Optional, only require password verification a single time
        }
      ];
      */
      # -> extraRules does not seem to apply in doas.conf so I'll use extraConfig instead
      extraConfig = ''
        permit persist keepenv ${mainUser}
      '';
    };
    # securty wrappers specify ownership,capabilities, etc... of certain files
    wrappers = {
      "mount.cifs" = {
        # mount.cifs seems to behave strangely
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.cifs-utils.out}/bin/mount.cifs";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    doas-sudo-shim # shim that makes it to that sudo and some of its flags are mapped to doas
  ];
}
