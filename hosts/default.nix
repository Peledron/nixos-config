{
  lib,
  self,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  overlay-unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      overlay-unstable
    ];
  };

  globalImports = [
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
  ];
  impermanenceImports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.persist-retro.nixosModules.persist-retro
  ];

  # additional functionality
  nixos-hardware = inputs.nixos-hardware.nixosModules; # contains a host of pre-written hardware-configuration.nix files for various laptops and SBCs

  # DE related inputs
  plasma-manager = inputs.plasmaMan.homeManagerModules.plasma-manager;
  hyprland-coremod = inputs.hyprland.nixosModules.default;
  hyprland-homemod = inputs.hyprland.homeManagerModules.default;

  # Path generation functions
  mkPath = base: path: "${base}/${path}";
  hostPath = mkPath self "hosts";
  globalPath = mkPath self "global";
  configPath = mkPath globalPath "config";
  userPath = mkPath globalPath "users";
  desktopPath = mkPath configPath "desktop";

  # Generated paths
  global-coreconf = mkPath configPath "conf.nix";
  global-desktopconf = mkPath configPath "desktop/system/conf.nix";

  desktopEnvPath = mkPath desktopPath "environments";

  desktopImports = [
    inputs.stylix.nixosModules.stylix
  ];

  # Desktop environment paths
  mkDesktopPath = de: mkPath desktopEnvPath de;
  desktopConfigs = {
    hyprland = {
      coreconf = mkDesktopPath "hyprland.nix";
      homeconf = mkDesktopPath "hyprland/home.nix";
      coremod = hyprland-coremod;
      homemod = hyprland-homemod;
    };
    kde = {
      coreconf = mkDesktopPath "kde.nix";
      homeconf = mkDesktopPath "kde/home.nix";
      homemod = plasma-manager;
    };
    gnome = {coreconf = mkDesktopPath "gnome.nix";};
    sway = {
      coreconf = mkDesktopPath "sway.nix";
      homeconf = mkDesktopPath "sway/home.nix";
    };
    xfce = {coreconf = mkDesktopPath "xfce.nix";};
  };

  mkCoreDesktopConfig = desktopEnv:
  # this function allows for error handling of desktop environments, it will check if the value given to the function (aka the name of the desktop env) exists in the desktopConfigs
    if !(desktopConfigs ? ${desktopEnv})
    then builtins.trace "Warning: Unknown desktop environment '${desktopEnv}'" []
    else
      # after that
      let
        desktopEnvConfig = desktopConfigs.${desktopEnv};
      in
        desktopImports
        ++ [
          global-desktopconf
          (lib.optional (desktopEnvConfig ? coremod && desktopEnvConfig.coremod != null) desktopEnvConfig.coremod)
          (lib.optional (desktopEnvConfig ? coreconf && desktopEnvConfig.coreconf != null) desktopEnvConfig.coreconf)
        ];

  # make a new function with the following variable inputs
  mkUserConfig = {
    mainUser,
    desktopEnv, # what desktop environment, null by default
    extraHomeModules,
    ... # this allows other parameters to enter the function (like self and such)
  }: let
    # args captures all the inputs in a single variable
    userDir = "${self}/global/users/${mainUser}";
    userHomeDir = "${userDir}/home";
    baseUserConfig = ["${userDir}/usr.nix"]; # the base user config, for nixos itself, username is from the variable username passed to the function
    homeUserConfig = [
      # home manager config for the user
      inputs.homeMan.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs self system;};
          users.${mainUser} = {
            imports =
              # define global inputs for all users
              [
                inputs.nix-index-database.hmModules.nix-index
                "${userHomeDir}/global/home.nix"
              ]
              ++ (
                # create an if function that sees if the isDesktop variable is set to true (default) or false
                if desktopEnv != null
                then
                  ["${userHomeDir}/desktop/home.nix"]
                  # import home mod and home conf if they exist and are not empty (see desktopConfigs above)
                  ++ (lib.optional (desktopConfigs.${desktopEnv} ? homemod && desktopConfigs.${desktopEnv}.homemod != null) desktopConfigs.${desktopEnv}.homemod)
                  ++ (lib.optional (desktopConfigs.${desktopEnv} ? homeconf && desktopConfigs.${desktopEnv}.homeconf != null) desktopConfigs.${desktopEnv}.homeconf)
                else ["${userHomeDir}/server/home.nix"]
              )
              ++ extraHomeModules; # add the extra modules in the []
            home.stateVersion = "23.11";
          };
        };
      }
    ];
  in
    baseUserConfig ++ (lib.optionals (lib.pathExists userHomeDir) homeUserConfig);
  

  # Function to create a NixOS configuration for a host
  mkHostConfig = {
    hostName,
    isImpermanent ? false,
    mainUser ? "pengolodh",
    desktopEnv ? null,
    extraConfig ? {},
    extraImports ? [],
    extraHomeModules ? [],
    ... # this allows other parameters to enter the function (like self and such)
  }:
    assert builtins.isAttrs extraConfig || builtins.trace "Warning: extraConfig should be an attribute set" true; # ensures that extraconfig is an attribute set
    
      lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs self hostName extraConfig; # inherit the variables
        };
        modules =
          lib.flatten [
            globalImports
            extraImports
            (lib.optionals isImpermanent impermanenceImports)
            (mkCoreDesktopConfig desktopEnv)

            # Import the host-specific configuration
            "${hostPath}/${hostName}"
          ] # lib.flatten makes sure that there are no nested lists https://noogle.dev/f/lib/lists/flatten
          ++ (mkUserConfig
            {
              # pass variables to mkUserConfig function
              inherit mainUser desktopEnv extraHomeModules;
            });
      };
in {
  #==================#
  # hardware:
  #==================#
  nixos-main = mkHostConfig {
    hostName = "nixos-main";
    isImpermanent = true;
    desktopEnv = "hyprland";

    extraConfig = {
      disks = [
        "/dev/disk/by-id/nvme-SAMSUNG_MZVLW512HMJP-000H1_S36ENX0HA25227"
        "/dev/disk/by-id/nvme-SAMSUNG_MZVLB1T0HALR-00000_S3W6NX0N701285"
        "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S69ENX0TB18294T-part3"
        "/dev/mapper/big--data-data--games"
        "/dev/disk/by-id/ata-TOSHIBA_DT01ACA300_95QGT6KGS-part2"
        "/dev/disk/by-id/ata-ST1000DM003-1ER162_Z4YC0ZWB-part1"
      ];
      rocmgpu = "GPU-8beaa8932431d436";
    };
  };

  nixos-laptop-asus = mkHostConfig {
    hostName = "nixos-laptop-asus";
    isImpermanent = true;
    desktopEnv = "kde";
    extraImports = [nixos-hardware.asus-zephyrus-ga402];
    extraConfig = {
    };
  };

  nixos-server-hp = mkHostConfig {
    hostName = "nixos-server-hp";
    isImpermanent = true;

    extraConfig = {
      disks = [
        "/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193"
        "/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193-part1"
      ];
      netport = "eno1";
      vlans = [112 113 114];
    };
  };
}
