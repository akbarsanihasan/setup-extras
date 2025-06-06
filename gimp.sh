#!/usr/bin/env bash

if ! command -v flatpak &>/dev/null; then
	clear
	echo -e "Flatpak is not installed"
	exit 1
fi

if command -v pacman &>/dev/null; then
	sudo pacman --needed --noconfirm libarchive
fi

if command -v apt &>/dev/null; then
	sudo apt-get install -y libarchive-tools
fi

flatpak install --user --noninteractive --assumeyes org.gimp.GIMP

curl -Lo /tmp/photogimp.zip https://github.com/Diolinux/PhotoGIMP/releases/download/3.0/PhotoGIMP-linux.zip
bsdtar -xf /tmp/photogimp.zip -C "$HOME" --strip-components=1
rm -rf ./photogimp.zip
