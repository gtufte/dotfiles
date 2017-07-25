#!/usr/bin/env sh

WORKDIR=$(pwd)
HOMEDIR=$(cd && pwd)

usage () {
    printf "\t      __ _ _            \n"
    printf "\t     / _(_) | ___  ___  \n"
    printf "\t    | |_| | |/ _ \/ __| \n"
    printf "\t _  |  _| | |  __/\__ \ \n"
    printf "\t(_) |_| |_|_|\___||___/ \n"

    printf "\nThe following arguments is accepted:\n"
    printf "\tinstall_desktop:........Install/update all desktop relevant dotfiles.\n"
    printf "\tinstall_server:.........Install/update all server relevant dotfiles.\n"
    printf "\tvim:....................Install/update vim.\n"
    printf "\tfish:...................Install/update fish.\n"
    printf "\tterminator:.............Install/update terminator.\n\n"
}
install_desktop () {
    vim
    fish desktop
    terminator
}
install_server () {
    vim
    fish server
}
vim () {

    mkdir -p vim/vim
    if [ -e $HOMEDIR/.vim ] && [ ! -L $HOMEDIR/.vim ]; then
        mv -v $HOMEDIR/.vim $HOMEDIR/.vim.backup
        ln -s $WORKDIR/vim/vim $HOMEDIR/.vim
    elif [ ! -L $HOMEDIR/.vim ]; then
        ln -s $WORKDIR/vim/vim $HOMEDIR/.vim
    fi

    if [ -e $HOMEDIR/.vimrc ] && [ ! -L $HOMEDIR/.vimrc ]; then
        mv $HOMEDIR/.vimrc $HOMEDIR/.vimrc.backup
        ln -s $WORKDIR/vim/vimrc $HOMEDIR/.vimrc
    elif [ ! -L $HOMEDIR/.vimrc ]; then
        ln -s $WORKDIR/vim/vimrc $HOMEDIR/.vimrc
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
    if [ ! -L $HOMEDIR/.config/fish ]; then
        # If the fish config directory exists
        if [ -e $HOMEDIR/.config/fish ]; then
            # If there exists a fish history, copy into new environment
            if [ -f $HOMEDIR/.config/fish/fish_history ]; then
                cp $HOMEDIR/.config/fish/fish_history $WORKDIR/fish/$1/fish_history
            fi
            # Move the current fish directory
            mv $HOMEDIR/.config/fish $HOMEDIR/.config/old_fish_config
        fi
        # Create the .config directory if it doesn't exist
        if [ ! -e $HOMEDIR/.config ]; then
            mkdir -p $HOMEDIR/.config
        fi
        # Create a symlink from dotfiles to fish config directory
        ln -s $WORKDIR/fish/$1 $HOMEDIR/.config/fish
    fi
}
terminator () {
    if [ ! -d $HOMEDIR/.config/terminator ]; then
        mkdir -p $HOMEDIR/.config/terminator
    fi
    if [ -e $HOMEDIR/.config/terminator/config ] && [ ! -L $HOMEDIR/.config/terminator/config ]; then
        mv $HOMEDIR/.config/terminator/config $HOMEDIR/.config/terminator/config.backup
        ln -s $WORKDIR/terminator/config $HOMEDIR/.config/terminator/config
    elif [ ! -L $HOMEDIR/.config/terminator/config ]; then
        ln -s $WORKDIR/terminator/config $HOMEDIR/.config/terminator/config
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
if [ "$1" = "install_desktop" ]; then
    install_desktop
    exit 0
elif [ "$1" = "install_server" ]; then
    install_server
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
