#!/usr/bin/env bash

clear

if ! command -v docker &>/dev/null; then
	echo -e "Docker is not installed"
	exit 1
fi

if ! command -v distrobox &>/dev/null; then
	curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install |
		sh -s -- --prefix "$HOME"/.local
fi
