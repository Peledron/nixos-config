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

  global-inputs = [
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
  ];
  impermanence-inputs = [
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

  desktop_envdir = mkPath desktopPath "environments";

  desktop-inputs = [
    inputs.homeMan.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  # Desktop environment paths
  mkDesktopPath = de: mkPath desktop_envdir de;
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

  makeModules = {
    isImpermanent ? false,
    desktopEnv ? null,
    extraModules ? [],
  }: let
    modules = lib.flatten [
      global-inputs
      (lib.optionals isImpermanent impermanence-inputs)
      global-coreconf
      # if desktopEnv value is not null (aka its kde, gnome or something) inport desktop related inputs and global config
      (lib.optionals (desktopEnv != null) desktop-inputs)
      (lib.optionals (desktopEnv != null) global-desktopconf)

      # check if desktop env has a value, and if it does check if the core-mod and conf files exist, if they do import them
      (lib.optionals (desktopEnv != null && desktopConfigs.${desktopEnv}.coremod != null) desktopConfigs.${desktopEnv}.coremod)
      (lib.optionals (desktopEnv != null && desktopConfigs.${desktopEnv}.coreconf != null) desktopConfigs.${desktopEnv}.coreconf)

      # Extra modules to import
      extraModules
    ]; # lib.flatten makes sure that there are no nested lists https://noogle.dev/f/lib/lists/flatten
  in
    modules; # return the modules as a list

  # the following imports global/users/default.nix
  userConfigModules = import "${self}/global/users" {inherit lib self;};

  # make a new function with the following variable inputs
  mkUserConfig = {
    mainUser,
    desktopEnv, # what desktop environment, null by default
    extraHomeModules,
  }: let
    # a list of additional module imports
    baseUserConfig = userConfigModules.mkUserConfig mainUser; # the base user config, for nixos itself, username is from the variable username passed to the function
    homeManagerConfig = {
      # home manager config for the user
      inputs.homeMan.nixosModules.home-manager = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs self system;};
          users.${mainUser} = {
            imports =
              # define global inputs for all users
              [
                inputs.nix-index-database.hmModules.nix-index
                (userConfigModules.getUserHomePath mainUser "global/home.nix")
              ]
              ++ (
                # create an if function that sees if the isDesktop variable is set to true (default) or false
                if desktopEnv != null
                then
                  [(userConfigModules.getUserHomePath mainUser "desktop/home.nix")]
                  # import home mod and home conf if they exist (see desktopConfigs above)
                  ++ [(lib.optional (desktopConfigs.${desktopEnv}.homemod != null) desktopConfigs.${desktopEnv}.homemod)]
                  ++ [(lib.optional (desktopConfigs.${desktopEnv}.homeconf != null) desktopConfigs.${desktopEnv}.homeconf)]
                else [(userConfigModules.getUserHomePath mainUser "server/home.nix")]
              )
              ++ extraHomeModules; # add the extra modules in the []
            home.stateVersion = "23.11";
          };
        };
      };
    };
  in
    baseUserConfig // homeManagerConfig; # combine the base user config and the home manager config, // stands for merge

  # Function to create a NixOS configuration for a host
  mkHostConfig = {
    hostName,
    isImpermanent ? false,
    mainUser ? "pengolodh",
    desktopEnv ? null,
    extraConfig ? {},
    extraHomeModules ? [],
  }:
  # Create a NixOS system configuration
    lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        inherit inputs self hostName; # inherit the variables
      };
      modules =
        # makemodules adds a list of all modules that are globally enabled, some are only imported depending on the inputs of mkhostconfig
        makeModules {
          # pass desktopENV and ispermament to the makemodules function
          inherit isImpermanent;
          inherit desktopEnv;

          # Additional modules specific to this host
          extraModules = lib.flatten [
            [extraConfig]
            # Import the host-specific configuration
            "${hostPath}/${hostName}"
          ];
        }
        ++ [
          mkUserConfig
          {
            # pass variables to mkUserConfig function
            inherit mainUser;
            inherit desktopEnv;
            inherit extraHomeModules;
          }
        ];
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
      config = {
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
  };

  nixos-laptop-asus = mkHostConfig {
    hostName = "nixos-laptop-asus";
    isImpermanent = true;
    desktopEnv = "kde";

    extraConfig = {
      imports = [nixos-hardware.asus-zephyrus-ga402];
    };
  };

  nixos-server-hp = mkHostConfig {
    hostName = "nixos-server-hp";
    isImpermanent = true;

    extraConfig = {
      config = {
        disks = [
          "/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193"
          "/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193-part1"
        ];
        netport = "eno1";
        vlans = [112 113 114];
      };
    };
  };
}
