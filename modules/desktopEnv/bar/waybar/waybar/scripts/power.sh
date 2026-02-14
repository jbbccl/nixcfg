#!/usr/bin/env bash
case "$1" in
    --logout)
        # 退出当前会话（针对sway或其他Wayland compositor）
        labwc -e
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