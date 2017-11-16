#!/usr/bin/env bash

if [ ! -d ".git" ]; then
    echo "You currently not standing in the root folder of a git repo. Aborting!"
    exit 2
fi
if [ ! -d "manifests" ]; then
    echo "Couldn't find the manifests folder, is this even a puppet repo? Aborting!"
    exit 2
fi
if [ ! -d "$HOME/code/tools/puppet-git-hooks" ]; then
    echo "Seems like you didn't install the puppet-git-hooks repo? Aborting!"
    exit 2
fi
ln -s $HOME/code/tools/puppet-git-hooks/pre-commit .git/hooks/pre-commit

