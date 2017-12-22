#!/usr/bin/env bash

RVM_ROOT="$HOME/.rvm"
GEMS=(
  puppet
  puppet-lint
  hiera
  r10k
  rubocop
  yaml-lint
)
if [ -d "$RVM_ROOT" ]; then
    GEM_PATH=$(which gem)
    echo $GEM_PATH | grep "^$RVM_ROOT"
    if [ "$?" = "0" ]; then
        echo "Using $GEM_PATH to install gems"
       for gem in ${GEMS[@]}; do
            $GEM_PATH install $gem
       done
    else
        echo "No gem binary found in your rvm. Get gem!"
        exit 1
    fi
else
    echo "Unable to find $RVM_ROOT Set up RVM before running this script"
    exit 1
fi
