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
    --suspend)
		swaylock -f & sleep 0.3 && systemctl suspend
		;;
	*)
		exit 1
		;;
esac