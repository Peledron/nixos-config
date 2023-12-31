{ config, lib, pkgs, system, inputs, ... }:   
let 
  net-egress-interface
in 
{
  # enable ip forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1; 
  boot.kernel.sysctl."net.ipv6.ip_forward" = 1;

  # setup container networks
  networking = {
    nat = {
      enable = true;
      internalInterfaces = ["ve-+" "vb-+"];
      externalInterface = "eno1";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
    firewall = {
      # allow nat masquerade on interface
      extraCommands = ''
        iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
      '';
    };
 };
}
