#!/usr/bin/env bash
case "$1" in
    --logout)
        systemctl --user exit
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