#!/usr/bin/env bash

if ! command -v git &>/dev/null; then
	clear
	echo "Failed to download personal belongings, git not found"
	exit 1
fi

if ! command -v flatpak &>/dev/null; then
	clear
	echo -e "Flatpak is not installed"
	exit 1
fi

if ! [[ -d $PWD/.personal ]]; then
	git clone https://github.com/akbarsanihasan/Personal.git "$PWD"/.personal
fi

rm -rf "$HOME"/.config/calibre
ln -sf "$PWD"/.personal/.config/calibre "$HOME"/.config/calibre
rm -rf "$HOME"/Books
ln -sf "$PWD"/.personal/Books "$HOME"/Books
rm -rf "$HOME"/Notes
ln -sf "$PWD"/.personal/Notes "$HOME"/Notes

flatpak install --user --noninteractive --assumeyes com.calibre_ebook.calibre
flatpak override --user --filesystem=home com.calibre_ebook.calibre
flatpak override --user --filesystem=host com.calibre_ebook.calibre
flatpak override --user --filesystem=host-os com.calibre_ebook.calibre
flatpak override --user --filesystem=xdg-config/calibre com.calibre_ebook.calibre

flatpak install --user --noninteractive --assumeyes md.obsidian.Obsidian
flatpak override --user --filesystem=home md.obsidian.Obsidian
flatpak override --user --filesystem=host md.obsidian.Obsidian
flatpak override --user --filesystem=host-os md.obsidian.Obsidian
flatpak override --user --filesystem=xdg-config/calibre md.obsidian.Obsidian

if ! grep -ie "\"library_path\":.*$HOME/Books" "$HOME"/.config/calibre/global.py.json &>/dev/null; then
	sed -i --follow-symlinks "s|\"library_path\": *\"[^\"]*\"|\"library_path\": \"$HOME/Books\"|" "$HOME/.config/calibre/global.py.json"
fi
if ! grep -ie "\"database_path\":.*$HOME/Books/library1.db" "$HOME"/.config/calibre/global.py.json &>/dev/null; then
	sed -i --follow-symlinks "s|\"database_path\": *\"[^\"]*\"|\"database_path\": \"$HOME/Books/library1.db\"|" "$HOME/.config/calibre/global.py.json"
fi
