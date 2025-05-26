#!/usr/bin/env bash

if command -v pacman &>/dev/null; then
	sudo pacman -S --noconfirm --needed curl
fi

if command -v apt &>/dev/null; then
	sudo apt-get update
	sudo apt-get install -y curl
fi

curl -fsSL https://php.new/install/linux | bash

sudo rm -rf /usr/local/php
sudo mv "$HOME"/.config/herd-lite/ /usr/local/php
sudo mv /usr/local/php/bin/cacert.pem /usr/local/php
sudo rm -rf /usr/local/php/bin/php.ini

if ! [[ -f /usr/local/php/php.ini ]]; then
	tee /usr/local/php/php.ini <<-EOF
		curl.cainfo=/usr/local/php/bin/cacert.pem
		openssl.cafile=/usr/local/php/bin/cacert.pem
		pcre.jit=0
	EOF
fi

shellrcs=(.zshrc .bashrc)
for shellrc in "${shellrcs[@]}"; do
	if ! [[ -e "$HOME/$shellrc" ]]; then
		touch "$HOME/$shellrc"
	fi
	if ! grep -i "# PHP" "$HOME/$shellrc" &>/dev/null; then
		tee -a "$HOME/$shellrc" <<-EOF
			# PHP
			export PATH="/usr/local/php/bin:\$PATH"
			export PHP_INI_SCAN_DIR="/usr/local/php:\$PHP_INI_SCAN_DIR"
		EOF
	fi
done
