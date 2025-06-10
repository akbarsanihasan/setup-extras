#!/usr/bin/env bash

if ! command -v flatpak &>/dev/null; then
	clear
	echo -e "Flatpak is not installed"
	exit 1
fi

flatpak install --user --noninteractive --assumeyes com.calibre_ebook.calibre
flatpak override --user --filesystem=home com.calibre_ebook.calibre
flatpak override --user --filesystem=host com.calibre_ebook.calibre
flatpak override --user --filesystem=host-os com.calibre_ebook.calibre

if ! grep -ie "\"library_path\":.*$HOME/Books" "$HOME"/.config/calibre/global.py.json; then
	sed -i --follow-symlinks "s|\"library_path\": *\"[^\"]*\"|\"library_path\": \"$HOME/Books\"|" "$HOME/.config/calibre/global.py.json"
fi
if ! grep -ie "\"database_path\":.*$HOME/Books/library1.db" "$HOME"/.config/calibre/global.py.json; then
	sed -i --follow-symlinks "s|\"database_path\": *\"[^\"]*\"|\"database_path\": \"$HOME/Books/library1.db\"|" "$HOME/.config/calibre/global.py.json"
fi
