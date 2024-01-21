# system packages, accessible by all users, sys-packages holds system specific tools

{ config, lib, pkgs, ... }:
{
    # add specific system packages here:
    environment.systemPackages = with pkgs; [
    ];
     # in order to use a program with sudo you should do: program.$program.enable = true;
    # --> nix takes over management of the package, it also imports a configured module for the program
    # (see all using nixos-option programs)
}
