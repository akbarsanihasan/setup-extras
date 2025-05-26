#!/usr/bin/env bash

source ./devlang/nodejs.sh
source ./devlang/golang.sh
source ./devlang/php.sh
source ./devlang/rust.sh

current_dir=$PWD

packages=(
	git
	curl
	base-devel
	cmake
	ninja
	gettext
	luarocks
	tree-sitter-cli
)

sudo pacman -S --noconfirm --needed "${packages[@]}"

version=v0.10.4
if ! [[ -d /tmp/neovim ]]; then
	git clone --depth 1 -b "$version" https://github.com/neovim/neovim /tmp/neovim
fi

cd /tmp/neovim
make deps
make CMAKE_BUILD_TYPE=Release \
	CMAKE_PREFIX_PATH=/usr/local \
	-j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"

sudo make install

if ! [[ -d $HOME/.config/nvim ]]; then
	git clone https://github.com/akbarsanihasan/nvimrc.git "$HOME"/.config/nvim
fi

cd "$current_dir"
