{
  config,
  pkgs,
  lib,
  ...
}: {
  services.gns3-server = {
    enable = true;
    settings = {
      server = lib.mkForce {
        host = "127.0.0.1";
        port = 3080;

        # the default paths are set to /var/lib/gns3 so dont forget to enable that in persist
        projects_path = "$HOME/VM/GNS3/projects";
        appliances_path = "$HOME/VM/GNS3/appliances";
        images_path = "$HOME/VM/GNS3/images";
        configs_path = "$HOME/VM/GNS3/configs";
        symbols_path = "$HOME/VM/GNS3/symbols";

        # to fix some error with ubridge not having root access https://github.com/NixOS/nixpkgs/pull/303442#issuecomment-2149843984
        ubridge_path = "${pkgs.ubridge}/bin/ubridge";
      };
    };
    vpcs.enable = true; # enable vpcs support, this is a lightweight "pc" that has ping support for emulating a host
    ubridge.enable = true; # dont forget to add the user to the ubridge and podman groups
    dynamips.enable = true; # dynamips is used to emulate cisco IOS devices
  };

  # more fixes for ubridge https://github.com/NixOS/nixpkgs/pull/303442#issuecomment-2149843984
  users.groups.gns3 = {};
  users.users.gns3 = {
    group = "gns3";
    isSystemUser = true;
  };
  systemd.services.gns3-server.serviceConfig = {
    User = "gns3";
    DynamicUser = pkgs.lib.mkForce false;
    NoNewPrivileges = pkgs.lib.mkForce false;
    RestrictSUIDSGID = pkgs.lib.mkForce false;
    PrivateUsers = pkgs.lib.mkForce false;
    DeviceAllow =
      [
        "/dev/net/tun rw"
        "/dev/net/tap rw"
      ]
      ++ pkgs.lib.optionals config.virtualisation.libvirtd.enable [
        "/dev/kvm"
      ];
  };

  environment.systemPackages = with pkgs; [
    gns3-gui
    wireshark-qt
    virt-viewer
  ];
}
