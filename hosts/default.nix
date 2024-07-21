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
    isDesktop ? false,
    desktopEnv ? null,
    extraModules ? [],
  }:
    global-inputs
    ++ global-coreconf
    ++ (lib.optionals isImpermanent impermanence-inputs)
    # check if isDesktop is true, if it is import desktop-inputs
    ++ (lib.optionals isDesktop desktop-inputs)
    ++ (lib.optionals isDesktop global-desktopconf)
    # check if isDesktop is true, desktopEnv has a value and desktopConfigs.${desktopEnv}.core* exist, if so inport those relevant core* files
    ++ (lib.optional (isDesktop && desktopEnv != null && desktopConfigs.${desktopEnv}.coremod != null) desktopConfigs.${desktopEnv}.coremod)
    ++ (lib.optional (isDesktop && desktopEnv != null && desktopConfigs.${desktopEnv}.coreconf != null) desktopConfigs.${desktopEnv}.coreconf)
    # add extra modules (host unique)
    ++ extraModules;
  # Function to create a NixOS configuration for a host

  # the following imports global/users/default.nix
  userModules = import "${self}/global/users" {inherit lib self;};

  # make a new function with the following variable inputs
  mkUserConfig = username: {
    # username
    isDesktop ? true, # isdesktop, set to true by default
    desktopEnv ? null, # what desktop environment, null by default
  }: extraImports: let
    # a list of additional module imports
    baseUserConfig = userModules.mkUserConfig username; # the base user config, for nixos itself, username is from the variable username passed to the function
    homeManagerConfig = {
      # home manager config for the user
      inputs.homeMan.nixosModules.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit inputs self system;};
        users.${username} = {
          imports =
            # define global inputs for all users
            [
              inputs.nix-index-database.hmModules.nix-index
              (userModules.getUserHomePath username "global/home.nix")
            ]
            ++ (
              # create an if function that sees if the isDesktop variable is set to true (default) or false
              if isDesktop
              then
                [(userModules.getUserHomePath username "desktop/home.nix")]
                # import home mod and home conf if they exist (see desktopConfigs above)
                ++ lib.optional (desktopEnv != null && desktopConfigs.${desktopEnv}.homemod != null) desktopConfigs.${desktopEnv}.homemod
                ++ lib.optional (desktopEnv != null && desktopConfigs.${desktopEnv}.homeconf != null) desktopConfigs.${desktopEnv}.homeconf
              else [(userModules.getUserHomePath username "server/home.nix")]
            )
            ++ extraImports; # add the extra modules in the []
          home.stateVersion = "23.11";
        };
      };
    };
  in
    baseUserConfig // homeManagerConfig; # combine the base user config and the home manager config, // stands for merge

  mkHostConfig = {
    hostName,
    impermanence ? false,
    desktopEnv ? null,
    extraConfig ? {},
  }:
  # Create a NixOS system configuration
    lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        inherit inputs self hostName; # Pass additional special arguments to the modules
      };
      modules =
        # Add a module to set up _module.args
        # Apply any extra configuration passed to mkHostConfig
        makeModules {
          # Set up impermanence for all configurations
          isImpermanent = impermanence;
          # Determine if this is a desktop configuration
          isDesktop = desktopEnv != null;
          # Pass the desktop environment setting
          inherit desktopEnv;

          # Additional modules specific to this host
          extraModules = [
            # Convert extraConfig to a function if it's an attrset
            (
              if builtins.isAttrs extraConfig
              then (_: extraConfig)
              else extraConfig
            )
            # Import the host-specific configuration
            "${hostPath}/${hostName}"

            # Create user configuration for "pengolodh"
            (mkUserConfig "pengolodh" {
              isDesktop = desktopEnv != null;
              # Pass the desktop environment setting to the user config
              inherit desktopEnv;
            } []) # Empty list for any additional user-specific modules
          ];
        };
    };
in {
  #==================#
  # hardware:
  #==================#
  nixos-main = mkHostConfig {
    hostName = "nixos-main";
    impermanence = true;
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
    impermanence = true;
    desktopEnv = "kde";

    extraConfig = {
      imports = [nixos-hardware.asus-zephyrus-ga402];
    };
  };

  nixos-server-hp = mkHostConfig {
    hostName = "nixos-server-hp";
    impermanence = true;

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
