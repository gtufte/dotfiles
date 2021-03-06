#!/usr/bin/env sh

PWD=$(pwd)
HOME=$(cd && pwd)

tabs 4

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[1;32m'
COLOR_ORANGE='\033[0;33m'
COLOR_YELLOW='\033[1;33m'
COLOR_PURPLE='\033[1;35m'
COLOR_CYAN='\033[1;36m'
COLOR_NONE='\033[0m'

usage () {
    printf "$COLOR_PURPLE"
    printf "\t\t\t      __ _ _            \n"
    printf "\t\t\t     / _(_) | ___  ___  \n"
    printf "\t\t\t    | |_| | |/ _ \/ __| \n"
    printf "\t\t\t _  |  _| | |  __/\__ \ \n"
    printf "\t\t\t(_) |_| |_|_|\___||___/ \n"
    printf "$COLOR_NONE"

    printf "\n\t${COLOR_CYAN}./dotfiles desktop\n"
    printf "\t\t${COLOR_NONE}vim | bash | terminator | cinnamon | rvm | puppet-git-hooks\n"
    printf "\t${COLOR_CYAN}./dotfiles vim\n"
    printf "\t\t${COLOR_NONE}vim\n"
    printf "\t${COLOR_CYAN}./dotfiles server\n"
    printf "\t\t${COLOR_NONE}vim | bash\n\n"
}

desktop () {
    vim
    bash_setup
    terminator
    cinnamon
    pdk
#    rvm
}
server () {
    vim
    bash_setup
}
vim () {

    mkdir -p vim/vim

    if [ -e $HOME/.vim ] && [ ! -L $HOME/.vim ]; then
        printf "${COLOR_YELLOW}Existing .vim directory found. Backing up current directory.${COLOR_NONE}"
        printf "${COLOR_CYAN}$HOME/.vim moved to $HOME/.vim_old${COLOR_NONE}"
        mv -v $HOME/.vim $HOME/.vim.backup
        ln -s $PWD/vim/vim $HOME/.vim
    elif [ ! -L $HOME/.vim ]; then
        ln -s $PWD/vim/vim $HOME/.vim
    fi

    if [ -e $HOME/.vimrc ] && [ ! -L $HOME/.vimrc ]; then
        printf "${COLOR_YELLOW}Existing .vimrc file found. Backing up file.${COLOR_NONE}"
        printf "${COLOR_CYAN}$HOME/.vimrc moved to $HOME/.vimrc_old${COLOR_NONE}"
        mv $HOME/.vimrc $HOME/.vimrc.backup
        ln -s $PWD/vim/vimrc $HOME/.vimrc
    elif [ ! -L $HOME/.vimrc ]; then
        ln -s $PWD/vim/vimrc $HOME/.vimrc
    fi

    mkdir -p vim/vim/autoload vim/vim/bundle
    if [ ! -f vim/vim/autoload/pathogen.vim ]; then
        printf "${COLOR_CYAN}Installing vim module ${COLOR_PURPLE}pathogen${COLOR_NONE}\n"
    else
        printf "${COLOR_CYAN}Updating vim module ${COLOR_PURPLE}pathogen${COLOR_NONE}\n"
    fi
    curl -LSs https://tpo.pe/pathogen.vim -o vim/vim/autoload/pathogen.vim
    if [ "$?" = 0 ]; then
        printf "DONE!\n"
    else
        printf "${COLOR_RED}Something went wrong when updating vim module ${COLOR_PURPLE}pathogen\n"
    fi

    if [ ! -d vim/vim/bundle/puppet ]; then
        printf "${COLOR_CYAN}Downloading vim module ${COLOR_PURPLE}puppet${COLOR_NONE}\n"
        git clone https://github.com/rodjek/vim-puppet.git vim/vim/bundle/puppet
    else
        printf "${COLOR_CYAN}Updating vim module ${COLOR_PURPLE}puppet${COLOR_NONE}\n"
        git -C vim/vim/bundle/puppet pull
    fi

    if [ ! -d vim/vim/bundle/tabular ];  then
        printf "${COLOR_CYAN}Downloading vim module ${COLOR_PURPLE}tabular${COLOR_NONE}\n"
        git clone https://github.com/godlygeek/tabular.git vim/vim/bundle/tabular
    else
        printf "${COLOR_CYAN}Updating vim module ${COLOR_PURPLE}tabular${COLOR_NONE}\n"
        git -C vim/vim/bundle/tabular pull
    fi

    if [ ! -d vim/vim/bundle/aftercolors ];  then
        printf "${COLOR_CYAN}Downloading vim module ${COLOR_PURPLE}aftercolors${COLOR_NONE}\n"
        git clone https://github.com/vim-scripts/AfterColors.vim.git vim/vim/bundle/aftercolors
    else
        printf "${COLOR_CYAN}Updating vim module ${COLOR_PURPLE}aftercolors${COLOR_NONE}\n"
        git -C vim/vim/bundle/aftercolors pull
    fi

    if [ ! -d vim/vim/bundle/indent-guides ];  then
        printf "${COLOR_CYAN}Downloading vim module ${COLOR_PURPLE}indent-guides${COLOR_NONE}\n"
        git clone https://github.com/nathanaelkane/vim-indent-guides.git vim/vim/bundle/indent-guides
    else
        printf "${COLOR_CYAN}Updating vim module ${COLOR_PURPLE}indent-guides${COLOR_NONE}\n"
        git -C vim/vim/bundle/indent-guides pull
    fi

    # Git wrapper
    if [ ! -d vim/vim/bundle/fugitive ];  then
        printf "${COLOR_CYAN}Downloading vim module ${COLOR_PURPLE}fugitive${COLOR_NONE}\n"
        git clone https://github.com/tpope/vim-fugitive.git vim/vim/bundle/fugitive
    else
        printf "${COLOR_CYAN}Updating vim module ${COLOR_PURPLE}fugitive${COLOR_NONE}\n"
        git -C vim/vim/bundle/fugitive pull
    fi
}
bash_setup () {
    for file in bashrc bash_aliases bash_prompt inputrc; do
        if [ -e "$HOME/.${file}" ] && [ ! -L "$HOME/.${file}" ]; then
            printf "${COLOR_YELLOW}"
            printf "Existing .${file} config found. Backing up config\n"
            printf "${COLOR_NONE}"
            mv -v "$HOME/.${file}" "$HOME/.${file}_old"
            ln -s "$PWD/bash/${file}" "$HOME/.${file}"
        elif [ ! -L "$HOME/.${file}" ]; then
            ln -s "$PWD/bash/${file}" "$HOME/.${file}"
        fi
    done
}
terminator () {
    if [ ! -d $HOME/.config/terminator ]; then
        mkdir -p $HOME/.config/terminator
    fi
    if [ -e $HOME/.config/terminator/config ] && [ ! -L $HOME/.config/terminator/config ]; then
        printf "${COLOR_YELLOW}"
        printf "Existing terminator config found. Backing up config"
        printf "${COLOR_NONE}"
        mv -v $HOME/.config/terminator/config $HOME/.config/terminator/config_old
        ln -s $PWD/terminator/config $HOME/.config/terminator/config
    elif [ ! -L $HOME/.config/terminator/config ]; then
        ln -s $PWD/terminator/config $HOME/.config/terminator/config
    fi
}
cinnamon () {
    dconf load /org/cinnamon/ < $PWD/cinnamon/config
}
pdk () {
    if [ ! -L "$HOME/bin/pdk" ]; then
        ln -s $PWD/bin/pdk $HOME/bin/pdk
    fi
    if [ ! -L "$HOME/bin/Dockerfile.pdk" ]; then
        ln -s $PWD/bin/Dockerfile.pdk $HOME/bin/Dockerfile.pdk
    fi
}
rvm () {
    if [ ! -d "$HOME/.rvm" ]; then
        printf "${COLOR_CYAN}Downloading and installing ${COLOR_PURPLE}rvm${COLOR_NONE}\n"
        gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
        curl -sSL https://get.rvm.io | bash -s stable
    else
        printf "${COLOR_CYAN}Updating ${COLOR_PURPLE}rvm${COLOR_NONE}\n"
        curl -sSL https://get.rvm.io | bash -s stable
    fi
}

# Check for correct usage of the script
if [ "$#" -gt 1 ]; then
    printf "\n${COLOR_RED}This script only accepts one argument!${COLOR_NONE}\n\n"
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
elif [ "$1" = "vim" ]; then
    vim
    exit 0
elif [ "$1" = "server" ]; then
    server
    exit 0
elif [ "$1" = "--help" ]; then
    usage
    exit 0
else
    printf "\n${COLOR_RED}Argument '$1' not recognized!${COLOR_NONE}\n\n"
    usage
    exit 2
fi
