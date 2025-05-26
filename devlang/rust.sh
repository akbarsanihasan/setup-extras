#!/usr/bin/env bash

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

shellrcs=(.zshrc .bashrc)
for shellrc in "${shellrcs[@]}"; do
	if ! [[ -e "$HOME/$shellrc" ]]; then
		touch "$HOME/$shellrc"
	fi
	if ! grep -i "# Rust" "$HOME/$shellrc" &>/dev/null; then
		tee -a "$HOME/$shellrc" <<-EOF
			# Rust
			[ -s "\$HOME/.cargo/env" ] && . "\$HOME/.cargo/env"
		EOF
	fi
done
