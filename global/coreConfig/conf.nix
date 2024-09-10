{
  lib,
  pkgs,
  inputs,
  self,
  mainUser,
  ...
}: {
  hardware.enableRedistributableFirmware = true; # enables the linux-firmware package (and others), needed for a lot of hardware
  system = {
    stateVersion = "23.11"; # initial system state
    autoUpgrade = {
      enable = true;
      flake = self.outPath;
      persistent = true; # continues timer after reboot
      # operation = "boot" # might be good so as to minimize downtime untill needed, default is switch
      dates = "weekly";
      randomizedDelaySec = "45min";
      flags = [
        "--update-input"
        "nixpkgs"
        "-L"
        "--commit-lock-file"
      ];
    };
  };

  nix = {
    channel.enable = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
    # ---
    optimise = {
      automatic = true;
      dates = ["daily"];
    };

    # add other nix settings:
    settings = {
      #enable deduplication on the nix-store:
      # --> is generally safe, note that it will take up a bit of cpu and io recourses so disable it if your pc is too slow to handle it (if you are experience io-delay or high cpu usage)
      auto-optimise-store = true;

      # set users as trusted to run nix commands (@group allows entire group)
      trusted-users = [
        #"@wheel" # for all of wheel
        mainUser
      ];
    };
  };
}
