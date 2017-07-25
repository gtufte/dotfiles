#!/usr/bin/env sh

PWD=$(pwd)
HOME=$(cd && pwd)

tabs 4

COLOR_BLACK='\033[0;30m'
COLOR_GRAY='\033[1;30m'
COLOR_GRAY_LIGHT='\033[0;37m'
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[1;32m'
COLOR_ORANGE='\033[0;33m'
COLOR_YELLOW='\033[1;33m'
COLOR_BLUE='\033[0;34m'
COLOR_BLUE_LIGHT='\033[1;34m'
COLOR_PURPLE='\033[0;35m'
COLOR_PURPLE_LIGHT='\033[1;35m'
COLOR_CYAN='\033[1;36m'
COLOR_CYAN_LIGHT='\033[1;36m'
COLOR_WHITE='\033[1;37m'
COLOR_NONE='\033[0m'

usage () {
    printf "$COLOR_PURPLE_LIGHT"
    printf "\t\t\t      __ _ _            \n"
    printf "\t\t\t     / _(_) | ___  ___  \n"
    printf "\t\t\t    | |_| | |/ _ \/ __| \n"
    printf "\t\t\t _  |  _| | |  __/\__ \ \n"
    printf "\t\t\t(_) |_| |_|_|\___||___/ \n"
    printf "$COLOR_NONE"

    printf "\n${COLOR_GREEN}Run this script in one of the following examples\n\n"
    printf "\t${COLOR_CYAN}./dotfiles desktop\n"
    printf "\t\t${COLOR_NONE}Vim, fish and terminator will be configured\n"
    printf "\t${COLOR_CYAN}./dotfiles server\n"
    printf "\t\t${COLOR_NONE}Vim and fish will be configured\n"
    printf "\t${COLOR_CYAN}./dotfiles vim\n"
    printf "\t\t${COLOR_NONE}Only vim will be configured\n"
    printf "\t${COLOR_CYAN}./dotfiles fish\n"
    printf "\t\t${COLOR_NONE}Only fish will be configured\n"
    printf "\t${COLOR_CYAN}./dotfiles terminator\n"
    printf "\t\t${COLOR_NONE}Only terminator will be configured\n\n"
}

desktop () {
    vim
    fish desktop
    terminator
}

server () {
    vim
    fish server
}

vim () {

    mkdir -p vim/vim
    if [ -e $HOME/.vim ] && [ ! -L $HOME/.vim ]; then
        mv -v $HOME/.vim $HOME/.vim.backup
        ln -s $PWD/vim/vim $HOME/.vim
    elif [ ! -L $HOME/.vim ]; then
        ln -s $PWD/vim/vim $HOME/.vim
    fi

    if [ -e $HOME/.vimrc ] && [ ! -L $HOME/.vimrc ]; then
        mv $HOME/.vimrc $HOME/.vimrc.backup
        ln -s $PWD/vim/vimrc $HOME/.vimrc
    elif [ ! -L $HOME/.vimrc ]; then
        ln -s $PWD/vim/vimrc $HOME/.vimrc
    fi

    mkdir -p vim/vim/{bundle,autoload}

    if [ ! -f vim/vim/autoload/pathogen.vim ]; then
        printf "Installing vim pathogen\n"
    else
        printf "Updating vim pathogen\n"
    fi
    curl -LSso vim/vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    if [ ! -d vim/vim/bundle/puppet ]; then
        git clone https://github.com/rodjek/vim-puppet.git vim/vim/bundle/puppet
    else
        printf "Updating vim moudule 'puppet'\n"
        git -C vim/vim/bundle/puppet pull
    fi

    if [ ! -d vim/vim/bundle/tabular ];  then
        git clone https://github.com/godlygeek/tabular.git vim/vim/bundle/tabular
    else
        printf "Updating vim module 'tabular'\n"
        git -C vim/vim/bundle/tabular pull
    fi

    if [ ! -d vim/vim/bundle/aftercolors ];  then
        git clone https://github.com/vim-scripts/AfterColors.vim.git vim/vim/bundle/aftercolors
    else
        printf "Updating vim module 'aftercolors'\n"
        git -C vim/vim/bundle/aftercolors pull
    fi

    if [ ! -d vim/vim/bundle/vim-indent-guides ];  then
        git clone https://github.com/nathanaelkane/vim-indent-guides.git vim/vim/bundle/indent-guides
    else
        printf "Updating vim module 'vim-indent-guides'\n"
        git -C vim/vim/bundle/indent-guides pull
    fi
}

fish () {
    # If the fish config directory is not a symlink
    if [ ! -L $HOME/.config/fish ]; then
        # If the fish config directory exists
        if [ -e $HOME/.config/fish ]; then
            # If there exists a fish history, copy into new environment
            if [ -f $HOME/.config/fish/fish_history ]; then
                cp $HOME/.config/fish/fish_history $PWD/fish/$1/fish_history
            fi
            # Move the current fish directory
            mv $HOME/.config/fish $HOME/.config/old_fish_config
        fi
        # Create the .config directory if it doesn't exist
        if [ ! -e $HOME/.config ]; then
            mkdir -p $HOME/.config
        fi
        # Create a symlink from dotfiles to fish config directory
        ln -s $PWD/fish/$1 $HOME/.config/fish
    fi
}
terminator () {
    if [ ! -d $HOME/.config/terminator ]; then
        mkdir -p $HOME/.config/terminator
    fi
    if [ -e $HOME/.config/terminator/config ] && [ ! -L $HOME/.config/terminator/config ]; then
        mv $HOME/.config/terminator/config $HOME/.config/terminator/config.backup
        ln -s $PWD/terminator/config $HOME/.config/terminator/config
    elif [ ! -L $HOME/.config/terminator/config ]; then
        ln -s $PWD/terminator/config $HOME/.config/terminator/config
    fi
}

# Check for correct usage of the script
if [ "$#" -gt 1 ]; then
    printf "\nThis script only accepts one argument!\n"
    usage
    exit 2
elif [ "$#" -eq 0 ]; then
    usage
    exit 0
fi

# Check input string and perform setup
if [ "$1" = "desktop" ]; then
    desktop
    exit 0
elif [ "$1" = "server" ]; then
    server
    exit 0
elif [ "$1" = "vim" ]; then
    vim
    exit 0
elif [ "$1" = "fish" ]; then
    fish
    exit 0
elif [ "$1" = "terminator" ]; then
    terminator
    exit 0
else
    printf "\nThe argument '$1' is not a legal option\n"
    usage
    exit 2
fi
