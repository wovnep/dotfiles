#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
END='\e[0m'
temp_dir=$(mktemp -d)

# Check if the paru package is installed
if pacman -Q paru &>/dev/null; then
	echo -e "${GREEN}The 'paru' package is already installed.${END}"
else
	echo -e "${YELLOW}The 'paru' package is not installed.${END}"
	git clone https://aur.archlinux.org/paru-bin.git "${temp_dir}/paru"
	cd "${temp_dir}/paru"
	makepkg -si --noconfirm
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}'paru' package insalled successfully.${END}"
	else
		echo -e "${RED}Failed to install 'paru'${END}"
		exit 1
	fi
fi

echo -e "${GREEN}Installing necessary packages.${END}"
paru -Syu hyprland kitty neovim ranger rofi-wayland swaync waybar zathura zathura-pdf-poppler wlogout hyprpaper nemo chromium pipewire wireplumber polkit-kde-agent qt5-wayland qt6-wayland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk zsh stow fzf ttf-jetbrains-mono-nerd brightnessctl pamixer hyprcursor

if [ $? -eq 0 ]; then
	echo -e "${GREEN}Necessary package insalled successfully.${END}"
else
	echo -e "${RED}Failed to install some packages.${END}"
	exit 1
fi

echo -e "${GREEN}Copying gtk and cursor themes.${END}"
sudo mkdir -p /usr/share/themes/
sudo cp -r ./themes/gtk/* /usr/share/themes/
sudo mkdir -p /usr/share/icons/
sudo cp -r ./themes/cursor/catppuccin_macchiato_mauve_cursors /usr/share/icons/

echo -e "${GREEN}Link config files with Stow.${END}"
stow .

echo -e "${GREEN}Changing default shell to zsh.${END}"
chsh -s $(which zsh)
