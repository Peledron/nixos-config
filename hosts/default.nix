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

  # additional functionality
  nixosHardware = inputs.nixos-hardware.nixosModules; # contains a host of pre-written hardware-configuration.nix files for various laptops and SBCs

  # DE related inputs
  plasmaManager = inputs.plasmaMan.homeManagerModules.plasma-manager;
  hyprlandCoreMod = inputs.hyprland.nixosModules.default;
  hyprlandHomeMod = inputs.hyprland.homeManagerModules.default;

  # base paths
  mkPath = base: path: "${base}/${path}";
  hostPath = mkPath self "hosts";
  globalPath = mkPath self "global";
  desktopPath = mkPath self "desktop";
  userPath = mkPath globalPath "users";

  # global base config
  globalCoreConf = mkPath globalPath "coreConfig";

  # desktop config
  desktopGlobalCoreConf = mkPath desktopPath "coreConf";
  desktopEnvPath = mkPath desktopPath "environments";
  desktopCoreConfPath = mkPath desktopEnvPath "core";
  desktopHomeConfPath = mkPath desktopEnvPath "home";

  globalImports = [
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
    globalCoreConf
  ];
  impermanenceImports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.persist-retro.nixosModules.persist-retro
  ];
  desktopImports = [
    inputs.stylix.nixosModules.stylix
    desktopGlobalCoreConf
  ];

  # Desktop environment paths, these 2 functions take in de as input variable and add that variable to the end of the paths, to reduce redundant mkPath functions
  mkDesktopCoreConf = de: mkPath desktopCoreConfPath de;
  mkDestopHomeConf = de: mkPath desktopHomeConfPath de;

  desktopConfigs = {
    hyprland = {
      coreConf = mkDesktopCoreConf "hyprland.nix";
      homeConf = mkDestopHomeConf "hyprland/home.nix";
      coreMod = hyprlandCoreMod;
      homeMod = hyprlandHomeMod;
    };
    kde = {
      coreConf = mkDesktopCoreConf "kde.nix";
      homeConf = mkDestopHomeConf "kde/home.nix";
      homeMod = plasmaManager;
    };
    gnome = {coreConf = mkDesktopCoreConf "gnome.nix";};
    sway = {
      coreConf = mkDesktopCoreConf "sway.nix";
      homeConf = mkDestopHomeConf "sway/home.nix";
    };
    xfce = {coreConf = mkDesktopCoreConf "xfce.nix";};
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
        ++ (lib.optional (desktopEnvConfig ? coreMod && desktopEnvConfig.coreMod != null) desktopEnvConfig.coreMod)
        ++ (lib.optional (desktopEnvConfig ? coreConf && desktopEnvConfig.coreConf != null) desktopEnvConfig.coreConf);

  # make a new function with the following variable inputs
  mkUserConfig = {
    mainUser,
    desktopEnv, # what desktop environment, null by default
    extraHomeModules,
    ... # this allows other parameters to enter the function (like self and such)
  }: let
    # args captures all the inputs in a single variable
    userDir = "${userPath}/${mainUser}";
    userHomeDir = "${userDir}/home";
    baseUserConfig = ["${userDir}/usr.nix"]; # the base user config, for nixos itself, username is from the variable username passed to the function
    homeUserConfig = [
      # home manager config for the user
      inputs.homeMan.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs self system mainUser;};
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
                  ++ (lib.optional (desktopConfigs.${desktopEnv} ? homeMod && desktopConfigs.${desktopEnv}.homeMod != null) desktopConfigs.${desktopEnv}.homeMod)
                  ++ (lib.optional (desktopConfigs.${desktopEnv} ? homeConf && desktopConfigs.${desktopEnv}.homeConf != null) desktopConfigs.${desktopEnv}.homeConf)
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
            (lib.optional isImpermanent impermanenceImports)
            (lib.optional (desktopEnv != null) (mkCoreDesktopConfig desktopEnv))

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
    isImpermanent = false;
    desktopEnv = "kde";
    extraImports = [nixosHardware.asus-zephyrus-ga402];
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
