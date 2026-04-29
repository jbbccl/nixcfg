FROM docker.io/kalilinux/kali-last-release:latest

ARG USERNAME=a
ARG USER_UID=1000
ARG USER_GID=1000

USER root
WORKDIR /home/${USERNAME}

RUN <<EOF
	set -e

	sed -i "s@http://http.kali.org/kali@http://mirrors.tuna.tsinghua.edu.cn/kali@g" /etc/apt/sources.list
	apt update && apt install -y --reinstall ca-certificates
	update-ca-certificates
	sed -i "s@http://@https://@g" /etc/apt/sources.list
	apt update
	apt upgrade -y

	apt install -y \
		zsh zsh-autosuggestions zsh-syntax-highlighting zsh-common \
		dbus dbus-x11 dbus-daemon dbus-user-session \
		dconf-cli dconf-service dconf-gsettings-backend \
		locales \
		sudo

	echo "emulate sh -c '. /etc/profile'" > /etc/zsh/zprofile

	groupadd --gid ${USER_GID} ${USERNAME} || true
	useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/zsh
	usermod -aG video,sudo,audio ${USERNAME}
	echo "${USERNAME}:kali" | chpasswd
	echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}
	chmod 440 /etc/sudoers.d/${USERNAME}

	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
	echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
	locale-gen
	echo 'LANG=zh_CN.UTF-8' > /etc/locale.conf

	mkdir /etc/dconf/db/local.d/
	touch /etc/dconf/db/local.d/empty
	dconf update

	apt install -y \
		kitty fuzzel \
		libnspr4 libnss3 libegl1-mesa-dev libwayland-egl1 \
		libgtk-3-common libgtk-4-common

	apt clean
EOF

COPY entrypoint.sh /entrypoint.sh
COPY environment /etc/environment
COPY toolkit-profile.sh /etc/profile.d/toolkit.sh

ENTRYPOINT ["/entrypoint.sh"]
