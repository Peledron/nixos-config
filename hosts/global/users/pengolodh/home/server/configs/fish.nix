{ config, ... }:
{   # see https://nixos.wiki/wiki/Fish
    programs.fish = {
        enable = true; # set fish to be managed by home-manager

    #==================#
    # fish config:
    # --> fish aliases
        shellAliases = {
            # ---
            # package management
            # [nix]
                envinstall="nix-env -iA";
                envremove="nix-env --uninstall";
                envupdate="nix-env -U '*'";
                update="pushd $FLAKEDIR; nix flake update; sudo nixos-rebuild switch  --flake .#$hostname; popd";
                rebuild="sudo nixos-rebuild switch  --flake $FLAKEDIR/#$hostname";
                rollback="sudo nixos-rebuild rollback --flake $FLAKEDIR/#$hostname";

            # ---
            # elevated
                # [sudo]
                s="sudo";
                se="sudoedit";
                su="sudo -i";
                # [systemd]
                ssys="sudo systemctl";
                sstatus="sudo systemctl status";
                sfailed="sudo systemctl --failed";
                sstart="sudo systemctl start";
                stop="sudo systemctl stop";
                srestart="sudo systemctl restart";
                sdisable="sudo systemctl disable";
                senable="sudo systemctl enable --now";
                stimers="sudo systemctl list-timers";
                sreload="sudo systemctl daemon-reload";
                jboot="sudo journalctl -xb";
                # [libvirt]
                vm="sudo virsh";

            # ---
            # user
                # -> editing/navigation
                e = "micro";
                ls = "exa -al --color=always --group-directories-first --icons";
                cat = "bat --style header --style rule --style snip --style changes --style header";
                # -> config editing
                fishedit = "$FLAKEDIR/hosts/global/users/desktop-$USER/configs/fish-alias-scripts/fishedit.sh";

        };
    # --> on intereractive shell launch fish will do the following:
        interactiveShellInit = ''
            begin
                set fish_greeting
                set VIRTUAL_ENV_DISABLE_PROMPT "1"
            end
        '';
    
    };
    # ---

    
}
