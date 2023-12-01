# packages that are globally installed by all hosts
{ config, lib, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        home-manager
        # ---
        # basic tools
            # [system]
            wget
            htop
            tldr
            tree
            killall
            pciutils
            usbutils
            # [shell]
            fish
            eza
            bat
            
            # [editor]
            neovim
            # [git+related]
            git
            git-crypt
            # [security]
            gnupg
            fail2ban
        # filesystem 
            # [general-util]
            ncdu # shows detailed diskusage
    ];
    # in order to use a program with sudo you should do: program.$program.enable = true;
    # --> nix takes over management of the package, it also imports a configured module for the program
    # (see all using https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=programs)
    programs.fish.vendor.completions.enable = true; # autoload completions provided by other nix packages
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    }; 

}