#!/usr/bin/env bash

clear

sudo pacman -S --noconfirm --needed flatpak

flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak override --user --allow=bluetooth

flatpak override --user --device=dri
flatpak override --user --device=shm
flatpak override --user --device=all

flatpak override --user --socket=x11
flatpak override --user --socket=wayland
flatpak override --user --socket=pulseaudio
flatpak override --user --socket=session-bus
flatpak override --user --socket=system-bus

flatpak override --user --filesystem=home
flatpak override --user --filesystem=host
flatpak override --user --filesystem=host-os
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
flatpak override --user --filesystem=xdg-config/Kvantum:ro
flatpak override --user --filesystem=xdg-data/themes:ro
flatpak override --user --filesystem=xdg-data/fonts:ro

flatpak override --user --env=QT_QPA_PLATFORM="wayland;xcb"
flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=auto
