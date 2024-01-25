# packages that are globally installed by all hosts
{ config, lib, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        home-manager
        # ---
        # basic tools
            # [system]
            wget
            curl
            rsync
            htop
            tldr
            tree
            killall
            pciutils
            usbutils
            # [shell]
            fish
            bat # cat replacement with syntax highlighting, etc
            eza # colorfull ls, easier to read
            # [editor]
            neovim
            # [dotfiles management] # I should define all config in nix but...
            stow
            # [git+related]
            git
            git-crypt
            sops
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
