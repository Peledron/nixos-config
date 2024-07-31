{
  lib,
  self,
  inputs,
  system,
  pkgs,
  ...
}: let
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
  desktopSharedCoreConf = mkPath desktopPath "coreConfig";
  desktopEnvPath = mkPath desktopPath "environments";

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
    desktopSharedCoreConf
  ];


  desktopConfigs = {
    hyprland = {
      coreConf = desktopEnvPath "hyprland/coreConfig.nix";
      homeConf = desktopEnvPath "hyprland/home";
      coreMod = hyprlandCoreMod;
      homeMod = hyprlandHomeMod;
    };
    kde = {
      coreConf = desktopEnvPath "kde/coreConfig.nix";
      homeConf = desktopEnvPath "kde/home";
      homeMod = plasmaManager;
    };
    gnome = {coreConf = desktopEnvPath "gnome/coreConfig.nix";};
    sway = {
      coreConf = desktopEnvPath "sway/coreConfig.nix";
      homeConf = desktopEnvPath "sway/home";
    };
    xfce = {coreConf = desktopEnvPath "xfce/coreConfig.nix";};
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
in {
  # Function to create a NixOS configuration for a host, it is not in let in as the scope is used by other modules (aka ../hosts.nix)
  #functions in the let in are limited to this file and cannot be called by other modules except when inherited
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
          inherit inputs self hostName mainUser extraConfig; # inherit the variables
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
}
