#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed git github-cli glab

git config --global user.name akbarsanihasan
git config --global user.email akbarsani.dev@gmail.com
git config --global push.autoSetupRemote true
git config --global safe.directory '*'
git config --global helpers.credential store
git config --global init.defaultBranch main
git config --global rerere.enabled true
git config --global column.ui auto
git config --global branch.sort -committerdate
