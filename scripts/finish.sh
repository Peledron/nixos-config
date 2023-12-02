#!/usr/bin/env bash
# run this script after you login to the new nixos machine
dotfilesdir=$HOME/Data/Dotfiles
giturldotfiles=https://$gituser@gitlab.com/pengolodh/dotfiles.git
# setup Data directory in user dir so that things like kde are not broken due to user.dirs setting
mkdir -p $HOME/Data/{Desktop,Documents,Downloads,Pictures,Videos,Music,Applications,Projects,School}
# git clone Dotfiles
git clone $giturldotfiles $dotfilesdir
