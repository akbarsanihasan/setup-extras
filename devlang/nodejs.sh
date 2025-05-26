#!/usr/bin/env bash

export NPM_CONFIG_CACHE=$HOME/.node
export NPM_CONFIG_PREFIX=$HOME/.node

if command -v pacman &>/dev/null; then
	sudo pacman -S --noconfirm --needed curl unzip
fi

if command -v apt &>/dev/null; then
	sudo apt-get update
	sudo apt-get install -y curl unzip
fi

if ! command -v fnm &>/dev/null; then
	curl -fsSL https://fnm.vercel.app/install |
		sudo bash -s -- --skip-shell --install-dir /usr/local/bin
fi

eval "$(fnm env --fnm-dir "$HOME"/.node)"
fnm install --lts

shellrcs=(.zshrc .bashrc)
for shellrc in "${shellrcs[@]}"; do
	if ! [[ -e "$HOME/$shellrc" ]]; then
		touch "$HOME/$shellrc"
	fi
	if ! grep -i "# NodeJS" "$HOME/$shellrc" &>/dev/null; then
		tee -a "$HOME/$shellrc" <<-EOF
			# NodeJS
			export NPM_CONFIG_CACHE=\$HOME/.node
			export NPM_CONFIG_PREFIX=\$HOME/.node
			if command -v fnm &>/dev/null; then
			   eval "\$(fnm env --fnm-dir "\$HOME"/.node)"
			fi
		EOF
	fi
done
