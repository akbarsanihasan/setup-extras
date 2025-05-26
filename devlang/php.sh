#!/usr/bin/env bash

source ./Shared/add_path

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

if [[ "$(command -v php)" == "/usr/local/php/bin/php" ]] && command -v /usr/local/php/bin/php; then
	add_path <<-EOF
		# PHP
		export PATH="/usr/local/php/bin:\$PATH"
		export PHP_INI_SCAN_DIR="/usr/local/php:\$PHP_INI_SCAN_DIR"
	EOF
fi
