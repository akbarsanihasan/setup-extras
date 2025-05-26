#!/usr/bin/env bash

source ./Shared/add_path

if command -v pacman &>/dev/null; then
	sudo pacman -S --noconfirm --needed wget tar
fi

if command -v apt &>/dev/null; then
	sudo apt-get update
	sudo apt-get install -y wget tar
fi

version=1.24.1

wget -N -O /tmp/go"$version".linux-amd64.tar.gz https://go.dev/dl/go"$version".linux-amd64.tar.gz

sudo rm -rf /usr/local/go
sudo tar -C /usr/local/ -xzf /tmp/go"$version".linux-amd64.tar.gz

if [[ "$(command -v go)" == "/usr/local/go/bin/go" ]] && command -v /usr/local/go/bin/go; then
	add_path <<-EOF
		# Golang
		export PATH="/usr/local/go/bin:\$PATH"
		export PATH="\$HOME/go/bin:\$PATH"
	EOF
fi
