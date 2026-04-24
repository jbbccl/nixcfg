{
	# Flatpak
	services.flatpak.enable = true;
	# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	# flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	# flatpak install --user flathub com.usebottles.bottles

	# AppImage
	programs.appimage = {
		enable = true;
		binfmt = true;
	};
}