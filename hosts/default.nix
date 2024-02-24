# declare the hosts for the flake, default.nix will always be used when importing a directory
{
  lib,
  self,
  inputs,
  ...
}: let
  # package modules
  system = "x86_64-linux"; # System architecture
  lib = inputs.nixpkgs.lib;

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
    overlays = [
      inputs.nur.overlay # overlay nixpkgs with nur, meant that you add nur packages to the nixpkgs module (I think)
    ];
  };

  nur-no-pkgs = import inputs.nur {
    # so we can import overlapping modules
    nurpkgs = import inputs.nixpkgs {inherit system;};
  };

  # aditional functionality
  home-manager = inputs.homeMan.nixosModules.home-manager;
  impermanence = inputs.impermanence.nixosModules.impermanence;
  disko = inputs.disko.nixosModules.disko;
  sops = inputs.sops-nix.nixosModules.sops;
  nix-index-db = inputs.nix-index-database.hmModules.nix-index; # -> note that this is a Homemanager module

  # DE related inputs
  plasma-manager = inputs.plasmaMan.homeManagerModules.plasma-manager;

  hyprland-coremod = inputs.hyprland.nixosModules.default;
  hyprland-homemod = inputs.hyprland.homeManagerModules.default;

  # paths
  # -> main
  hostdir = "${self}/hosts";
  global-confdir = "${hostdir}/global/config";
  global-usrdir = "${hostdir}/global/users";
  global-desktopdir = "${global-confdir}/desktop";

  global-coreconf = "${global-confdir}/conf.nix";
  global-desktopconf = "${global-confdir}/desktop/system/conf.nix";

  # -> Desktop environments
  desktop_envdir = "${global-desktopdir}/environments";

  ## => hyprland
  hyprland-coreconf = "${desktop_envdir}/hyprland.nix";
  hyprland-homeconf = "${desktop_envdir}/hyprland/home.nix";

  ## => sway
  sway-coreconf = "${desktop_envdir}/sway.nix";
  sway-homeconf = "${desktop_envdir}/sway/home.nix";

  ## => gnome
  gnome-coreconf = "${desktop_envdir}/gnome.nix";

  ## => kde
  kde-coreconf = "${desktop_envdir}/kde.nix";
  kde-homeconf = "${desktop_envdir}/kde/home.nix";

  ## => xfce
  xfce-coreconf = "${desktop_envdir}/xfce.nix";

  # user specific modules
  # -> pengolodh
  pengolodh-coreconf = "${global-usrdir}/pengolodh/usr.nix";
  pengolodh_desktop-homeconf = "${global-usrdir}/pengolodh/home/desktop/home.nix";
  pengolodh_server-homeconf = "${global-usrdir}/pengolodh/home/server/home.nix";
in {
  #==================#
  # vm-desktop:
  #==================#
  vm-nixos-desktop = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      # inputs
      sops
      disko
      impermanence

      # modules
      global-coreconf
      global-desktopconf
      sway-coreconf

      # -> host module
      "${hostdir}/vm-nixos-desktop"
      {
        _module.args.disks = ["/dev/vda"]; # change this to sda for vmware, you can add more drives in more "", for example "/dev/nvme0n1"
      }

      # -> hardware
      "${hostdir}/vm-nixos-desktop/core/hardwareqemu.nix" # change this to hardwarevmware.nix for vmware

      # -> user modules
      pengolodh-coreconf
      # add more users here:

      #==================#
      # system home-man:
      home-manager
      {
        home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
        home-manager.useUserPackages = true; # packages will be installed per user;
        home-manager.extraSpecialArgs = {};
        home-manager.users.pengolodh = {
          imports =
            [pengolodh_desktop-homeconf]
            ++ [sway-homeconf]; # add more inports via [import module] ++ (import folder) or ++ [(import file)]
        };
        # ---
        # add more users here:
      }
    ];
  };
  # ---

  #==================#
  # vm-server:
  #==================#
  # ---

  #==================#
  # hardware:
  #==================#
  nixos-main = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      # inputs
      sops
      disko
      impermanence
      hyprland-coremod

      # modules
      global-coreconf
      global-desktopconf
      hyprland-coreconf
      #kde-coreconf

      # -> host module
      "${hostdir}/nixos-main"
      {
        _module.args.disks = [
          # system disks
          "/dev/disk/by-id/nvme-SAMSUNG_MZVLW512HMJP-000H1_S36ENX0HA25227" # 512GB root drive
          "/dev/disk/by-id/nvme-SAMSUNG_MZVLB1T0HALR-00000_S3W6NX0N701285" # 1TB home drive
          # existing system partitions
          "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S69ENX0TB18294T-part3" # 2 TB windows root partition
          # existing data partitions
          "/dev/mapper/big--data-data--games" # 4TB linux-game drive (luks on lvm)
          "/dev/disk/by-id/ata-TOSHIBA_DT01ACA300_95QGT6KGS-part2" # 3tb windows-data drive (ntfs)
          "/dev/disk/by-id/ata-ST1000DM003-1ER162_Z4YC0ZWB-part1" #1TB windows-mod drive (ntfs)
        ];
      }

      # -> user modules
      pengolodh-coreconf
      # add more users here:

      #==================#
      # system home-man:
      home-manager
      {
        home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
        home-manager.useUserPackages = true; # packages will be installed per user;
        home-manager.extraSpecialArgs = {inherit inputs self system;};
        home-manager.users.pengolodh = {
          imports =
            [hyprland-homemod]
            ++ [nix-index-db]
            #[plasma-manager]
            ++ [pengolodh_desktop-homeconf]
            ++ [hyprland-homeconf];
          # add more inports via [import module] ++ (import folder) or ++ [(import file)], variables behave like modules
        };
        # ---
        # add more users here:
      }
    ];
  };

  # ---
  nixos-macbook = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      # inputs
      sops
      hyprland-coremod

      # modules
      global-coreconf
      hyprland-coreconf

      # -> host module
      "${hostdir}/nixos-macbook"

      # -> user modules
      pengolodh-coreconf

      #==================#
      # system home-man:
      home-manager
      {
        home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
        home-manager.useUserPackages = true; # packages will be installed per user;
        home-manager.extraSpecialArgs = {
          inherit (inputs);
        };
        home-manager.users.pengolodh = {
          imports =
            #[plasma-manager]  # add plasma-manager to home-man user imports as per https://github.com/pjones/plasma-manager/issues/5
            [hyprland-homemod]
            ++ [hyprland-homeconf]
            # ++ [kde-homeconf]
            ++ [pengolodh_desktop-homeconf]; # add more inports via [import module] ++ (import folder) or ++ [(import file)]
        };
        # ---
        # add more users here:
      }
    ];
  };
  # ---
  nixos-laptop-asus = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      # inputs
      sops
      #hyprland-coremod

      # modules
      global-coreconf
      kde-coreconf

      # -> host module
      "${hostdir}/nixos-laptop-asus"

      # -> user modules
      pengolodh-coreconf

      #==================#
      # system home-man:
      home-manager
      {
        home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
        home-manager.useUserPackages = true; # packages will be installed per user;
        home-manager.extraSpecialArgs = {
          inherit (inputs);
        };
        home-manager.users.pengolodh = {
          imports =
            # [hyprland-homemod]
            [plasma-manager] # add plasma-manager to home-man user imports as per https://github.com/pjones/plasma-manager/issues/5
            ++ [kde-homeconf]
            ++ [pengolodh_desktop-homeconf]; # add more inports via [import module] ++ (import folder) or ++ [(import file)]
        };
        # ---
        # add more users here:
      }
    ];
  };

  #==================#
  # hardware-server:
  #==================#
  nixos-server-hp = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      # inputs
      sops
      disko
      impermanence

      # modules
      global-coreconf

      # -> host module
      "${hostdir}/nixos-server-hp"
      {
        _module.args.disks = ["/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193" "/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193-part1"]; # you can add more drives in more "", for example "/dev/nvme0n1", or you can specifiy partitions
        _module.args.netport = "eno1"; # the physical ethernet port
        _module.args.vlans = [112 113 114]; # the incoming vlan tags
      }

      # -> user modules
      pengolodh-coreconf

      #==================#
      # system home-man:
      home-manager
      {
        home-manager.useGlobalPkgs = true; # sets home-manager to use the nix-package-manager packages instead of its own internal ones
        home-manager.useUserPackages = true; # packages will be installed per user;
        home-manager.extraSpecialArgs = {};
        home-manager.users.pengolodh = {
          imports =
            [nix-index-db]
            ++ [pengolodh_server-homeconf]; # add more inports via [import module] ++ (import folder) or ++ [(import file)]
        };
        # ---
        # add more users here:
      }
    ];
  };
  # ---

  # home-manager can also be done as a standalone:
  # (not really recommended as it recuires more steps)
  /*
  homeConfigurations = {
    pengolodh = home-manager.lib.homeManagerConfiguration {
      inherit system pkgs;
        username = "pengolodh";
        homeDirectory = "/home/pengolodh";
        configuration = {
          imports = [ ./nixos-desktop-pengolodh/pengolodh/home.nix ];
        };
    };
    #  ---
    # add more users here:
  };
  */
}
