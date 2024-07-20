# declare the hosts for the flake, default.nix will always be used when importing a directory
{
  lib,
  self,
  inputs,
  ...
}: let
  # package modules
  system = "x86_64-linux"; # System architecture

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

  # additional functional
  global-inputs = [
    inputs.impermanence.nixosModules.impermanence
    inputs.persist-retro.nixosModules.persist-retro
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
  ];

  nixos-hardware = inputs.nixos-hardware.nixosModules;

  home-manager = inputs.homeMan.nixosModules.home-manager;
  nix-index-db = inputs.nix-index-database.hmModules.nix-index;

  # DE related inputs
  plasma-manager = inputs.plasmaMan.homeManagerModules.plasma-manager;
  hyprland-coremod = inputs.hyprland.nixosModules.default;
  hyprland-homemod = inputs.hyprland.homeManagerModules.default;
  stylix = inputs.stylix.nixosModules.stylix;

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
      home-manager.users.${username} = {
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
            else [(userModules.getUserHomePath username "server/home.nix")] # import the server home config if isDesktop is false
          )
          ++ extraImports; # add the extra modules in the []
        home.stateVersion = "23.11";
      };
    };
  in
    baseUserConfig // homeManagerConfig; # combine the base user config and the home manager config, // stands for merge
in {
  #==================#
  # hardware:
  #==================#
  nixos-main = {desktopEnv ? "hyprland"}:
    lib.nixosSystem rec {
      inherit system pkgs;
      specialArgs = {
        inherit inputs self;
      };
      modules =
        global-inputs
        ++ [
          stylix
          (lib.optional (desktopConfigs.${desktopEnv}.coremod != null) desktopConfigs.${desktopEnv}.coremod)

          # core configuration
          global-coreconf
          "${hostPath}/nixos-main"
          {
            _module.args.disks = [
              "/dev/disk/by-id/nvme-SAMSUNG_MZVLW512HMJP-000H1_S36ENX0HA25227"
              "/dev/disk/by-id/nvme-SAMSUNG_MZVLB1T0HALR-00000_S3W6NX0N701285"
              "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S69ENX0TB18294T-part3"
              "/dev/mapper/big--data-data--games"
              "/dev/disk/by-id/ata-TOSHIBA_DT01ACA300_95QGT6KGS-part2"
              "/dev/disk/by-id/ata-ST1000DM003-1ER162_Z4YC0ZWB-part1"
            ];
            _module.args.rocmgpu = "GPU-8beaa8932431d436";
          }

          # desktop configuration
          global-desktopconf
          desktopConfigs.${desktopEnv}.coreconf

          userModules.mkUserConfig
          "pengolodh"

          # Home-manager configuration
          inputs.homeMan.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs self system;};
          }
          (mkUserConfig "pengolodh" {
              isDesktop = true;
              desktopEnv = desktopEnv;
            } [
              /*
              additional modules
              */
            ])
        ];
    };

  nixos-laptop-asus = {desktopEnv ? "kde"}:
    lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        inherit inputs self;
      };
      modules =
        global-inputs
        ++ [
          stylix
          (lib.optional (desktopConfigs.${desktopEnv}.coremod != null) desktopConfigs.${desktopEnv}.coremod)

          global-coreconf
          global-desktopconf
          desktopConfigs.${desktopEnv}.coreconf
          nixos-hardware.asus-zephyrus-ga402

          "${hostPath}/nixos-laptop-asus"
          userModules.mkUserConfig
          "pengolodh"

          # Home-manager configuration
          inputs.homeMan.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs self system;};
          }
          (mkUserConfig "pengolodh" {
            isDesktop = true;
            desktopEnv = desktopEnv;
          } [])
        ];
    };

  nixos-server-hp = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs self;
    };
    modules =
      global-inputs
      ++ [
        global-coreconf

        "${hostPath}/nixos-server-hp"
        {
          _module.args.disks = ["/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193" "/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193-part1"];
          _module.args.netport = "eno1";
          _module.args.vlans = [112 113 114];
        }
        userModules.mkUserConfig
        "pengolodh"
        home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs self system;};
        }
        (mkUserConfig "pengolodh" {isDesktop = false;} [])
      ];
  };
}
