#!/usr/bin/env bash

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[1;32m'
COLOR_ORANGE='\033[0;33m'
COLOR_YELLOW='\033[1;33m'
COLOR_PURPLE='\033[1;35m'
COLOR_CYAN='\033[1;36m'
COLOR_NONE='\033[0m'

USER=$SUDO_USER

# Install standard packages
declare -a PACKAGE_NAMES=(
  terminator
  curl
  git
  tmux
  vim
  cinnamon
  telnet
  gpgv2
  tlp
)
printf "$COLOR_PURPLE"
printf "\n*** Installing standard packages ***\n\n"
printf "$COLOR_GREEN"
for package in "${PACKAGE_NAMES[@]}"; do
    if [ "$(command -v $package)" == "" ]; then
        apt-get install -y $package
    else
        echo "Package $package already installed"
    fi
done

printf "$COLOR_PURPLE"
printf "\n*** Starting and enabling TLP ***\n\n"
printf "$COLOR_GREEN"
systemctl start tlp
systemctl enable tlp

# Install Docker CE (change != to == when docker is for artful)
printf "$COLOR_PURPLE"
printf "\n*** Installing docker ***\n\n"
printf "$COLOR_GREEN"
if [ "$(command -v docker)" == "" ]; then
    apt-get update
    apt-get install -y \
        linux-image-extra-$(uname -r) \
        linux-image-extra-virtual
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88 | grep "9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88"
    if [ "$?" == "0" ]; then
		add-apt-repository \
		   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		   $(lsb_release -cs) \
		   stable"
		apt-get update
		apt-get install -y docker-ce
        if [ -n "$USER" ]; then
     		usermod -a -G docker $USER
        else
            echo "Username not passed to script, not adding any user to docker group"
        fi
    else
		echo "Incorrect fingerprint for Docker CE. Aborting"
		exit 2
    fi
else
   echo "Docker already installed"
fi

# Install docker-compose
printf "$COLOR_PURPLE"
printf "\n*** Installing docker-compose ***\n\n"
printf "$COLOR_GREEN"
if [ "$(command -v docker-compose)" == "" ]; then
    curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
   echo "Docker-compose already installed"
fi

# Install spotify
printf "$COLOR_PURPLE"
printf "\n*** Installing Spotify ***\n\n"
printf "$COLOR_GREEN"
if [ "$(command -v spotify)" == "" ]; then
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
    echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list
    apt-get update
    apt-get install -y spotify-client
else
    echo "Spotify already installed"
fi

printf "\n$COLOR_NONE"
