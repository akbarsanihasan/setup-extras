#!/usr/bin/env bash

source ./Shared/add_path

if command -v pacman &>/dev/null; then
	sudo pacman -S --noconfirm --needed curl
fi

if command -v apt &>/dev/null; then
	sudo apt-get update
	sudo apt-get install -y curl
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
	sh -s -- -y --no-modify-path --no-update-default-toolchain

[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
rustup default stable

if [[ "$(command -v fnm)" == "$HOME/.cargo/bin/cargo" ]] && command -v "$HOME"/.cargo/bin/cargo; then
	add_path <<-EOF
		# Rust
		[ -s "\$HOME/.cargo/env" ] && . "\$HOME/.cargo/env"
	EOF
fi
