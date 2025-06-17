#!/usr/bin/env bash

clear

sudo pacman -S --noconfirm --needed flatpak

flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak override --user --filesystem=xdg-data/themes:ro
flatpak override --user --filesystem=xdg-data/fonts:ro
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
flatpak override --user --filesystem=xdg-config/Kvantum:ro

flatpak override --user --env=QT_QPA_PLATFORM="wayland;xcb"
flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=auto
