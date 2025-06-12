#!/usr/bin/env bash

if ! command -v git &>/dev/null; then
	clear
	echo "Failed to download personal belogings, git not found"
	exit 1
fi

git clone https://github.com/akbarsanihasan/Personal.git "$PWD"/.personal

rm -rf "$HOME"/.config/calibre

rm -rf "$HOME"/Books
ln -sf "$PWD"/.personal/Books "$HOME"/Books
rm -rf "$HOME"/Notes
ln -sf "$PWD"/.personal/Notes "$HOME"/Notes
