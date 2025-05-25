#!/usr/bin/env bash

clear

if command -v pacman &>/dev/null; then
	sudo pacman -Sy
	if ! sudo pacman -S --noconfirm podman crun; then
		echo -e "Failed to install podman"
		exit 1
	fi
fi

if command -v apt-get &>/dev/null; then
	sudo apt-get update -y
	if ! sudo apt-get install -y podman crun; then
		echo -e "Failed to install podman"
		exit 1
	fi
fi

if systemct && ! systemctl --user is-active podman; then
	systemctl --user enable podman --now
fi
