{dotfiles, config,...}:
{
    # .aliases file for zsh, fish, ... aliases
    home.file.".aliases".source = ${dotfiles}/shells/nixos_aliases;

}
