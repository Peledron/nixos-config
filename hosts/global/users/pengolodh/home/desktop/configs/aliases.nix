{dotfiles, config,...}:
{   # im going to keep this in a dotfile repo via stow, having this declerative does not make sense...
    home.file.".aliases" = {
        enable = true;
        text = ''
        # [ system]
            # [information]
                alias hw='sudo hwinfo --short' # Hardware Info
                alias iotop="sudo iotop"
            # [package management]
                alias update="sudo nix flake --upgrade; sudo nixos-rebuild switch --flake $HOME/nixos-config #$hostname; flatpak --user upgrade"
                # |zypper|
                alias "install "="nix-env -iA nixos."
                alias remove="nix-env -e"
                alias search="nix-env -qa"
                alias refresh="sudo apt update"
                # |flatpak|
                alias finstall="flatpak --user install"
                alias fremove="flatpak --user remove"
                alias flist="flatpak --user list"
                alias fsearch="flatpak search"
            # [system management]
                    alias reboot="sudo reboot"
                    alias shutdown="sudo shutdown now
                # [systemd]
                    # |basics|
                    alias ssys="sudo systemctl"
                    alias sstatus="sudo systemctl status"
                    alias srestart="sudo systemctl restart"
                    alias sinstall="sudo systemctl enable --now"
                    alias senable="sudo systemctl enable"
                    alias sdisable="sudo systemctl disable"
                    alias stimers="sudo systemctl list-timers"
                    alias sreload="sudo systemctl daemon-reload"
                    # |journal|
                    alias journal="sudo journalctl -xb"
                    alias sfailed="sudo systemctl --failed"
                    alias jfailed="sudo journalctl -xb -p 3"
                    alias jservice="sudo journalctl -xeu"
                # [sudo]
                    alias s="sudo"
                    alias se="sudoedit"
                    alias su="sudo -i"
                    alias s-cp="sudo rsync -ah --inplace --no-whole-file --info=progress2"
                    alias s-cpo="sudo cp"
                # [virsh]
                    alias vstart="sudo virsh start"
                    alias vstop="sudo virsh shutdown"
                    alias vlist="sudo virsh list"

            # [user]
                # [editing]
                    alias e="kate"
                    alias envedit="micro $HOME/.profile"
                    alias aliasedit="kate $HOME/.aliases"
                    alias zshedit="kate $HOME/.zshrc"
                    alias fishedit="kate $HOME/.config/fish/config.fish"
                    #alias hypredit="kate $HOME/.config/hypr/hyprland.conf"
                # [cli]
                    # |file|
                    alias cat='bat --style="changes,header"'
                    alias grep='grep --color=auto'
                    alias fgrep='fgrep --color=auto'
                    alias egrep='egrep --color=auto'
                    alias cp="rsync -ah --inplace --no-whole-file --info=progress2" # from https://stackoverflow.com/a/39397805
                    alias cpo="cp" # o stands fr overwrite
                    alias wget='wget -c '
                    # |tar|
                    alias tarnow='tar -acf '
                    alias untar='tar -zxvf '
                    # |navigation|
                    alias ls="exa -la --group-directories-first --sort modified"
                    alias l.="exa -a | egrep '^\.'" # show only dotfiles
                    alias dir='dir --color=auto'
                    alias vdir='vdir --color=auto'
                    alias tree='exa -laT -L 3 --group-directories-first --sort modified --octal-permissions --no-permissions --no-time --no-filesize' # tree listing
                    #alias tree='tree -a -L 3 -I .git'   # replaced by exa lt
                    alias ..='cd ..'
                    alias ...='cd ../..'
                    alias ....='cd ../../..'
                    alias .....='cd ../../../..'
                    alias ......='cd ../../../../..'
                    # |processes|
                    alias psmem='ps auxf | sort -nr -k 4' # shows the processes listed by memory usage
                    alias psmem10='ps auxf | sort -nr -k 4 | head -10' # shows the top 10 processes

                # [wm actions]
                    #alias waybar-reload="pkill -USR2 waybar"
                    #alias hypr-reload="hyprctl reload"
        '';
    };

}
