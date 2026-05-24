#!/usr/bin/env bash
case "$1" in
	--logout)
		uwsm stop
		;;
	--lock)
		swaylock
		;;
	--reboot)
		reboot
		;;
	--shutdown)
		poweroff
		;;
	*)
		exit 1
		;;
esac