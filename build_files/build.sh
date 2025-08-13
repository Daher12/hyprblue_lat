#!/bin/bash

set -ouex pipefail

### Install packages

dnf5 install -y blueman nautilus xdg-user-dirs-gtk xdg-user-dirs file-roller kitty gnome-text-editor blueman-nautilus tlp zsh zsh-syntax-highlighting --setopt=install_weak_deps=False 
#dnf5 install -y --setopt=install_weak_deps=False gnome-shell ffmpegthumbnailer gnome-extensions-app libavcodec-freeworld nautilus xdg-user-dirs xdg-user-dirs-gtk 

## Hyprland
dnf5 -y copr enable solopasha/hyprland 
dnf5 -y install hyprland hyprpaper hypridle hyprlock hyprpolkitagent hyprshot brightnessctl  --setopt=install_weak_deps=False

## Tailscale
dnf5 -y config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf5 -y config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/Fedora_Rawhide/shells:zsh-users:zsh-autosuggestions.repo
dnf5 -y install tailscale zsh-autosuggestions firefox


## Nix
mkdir -p /nix && \
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix -o /nix/determinate-nix-installer.sh && \
	chmod a+rx /nix/determinate-nix-installer.sh


