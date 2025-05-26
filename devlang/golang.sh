#!/usr/bin/env bash

if command -v pacman &>/dev/null; then
	sudo pacman -S --noconfirm --needed wget tar
fi

if command -v apt &>/dev/null; then
	sudo apt-get update
	sudo apt-get install -y wget tar
fi

version=1.24.1
download_name=go"$version".linux-amd64.tar.gz

if ! tar -tvf /tmp/"$download_name" &>/dev/null; then
	wget -N -O /tmp/"$download_name" https://go.dev/dl/"$download_name"
fi

sudo rm -rf /usr/local/go
sudo tar -C /usr/local/ -xzf /tmp/"$download_name"

shellrcs=(.zshrc .bashrc)
for shellrc in "${shellrcs[@]}"; do
	if ! [[ -e "$HOME/$shellrc" ]]; then
		touch "$HOME/$shellrc"
	fi
	if ! grep -i "# Golang" "$HOME/$shellrc"; then
		tee -a "$HOME/$shellrc" <<-EOF
			# Golang
			export PATH="/usr/local/go/bin:\$PATH"
			export PATH="\$HOME/go/bin:\$PATH"
		EOF
	fi
done
