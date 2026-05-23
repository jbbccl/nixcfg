#!/usr/bin/env bash
# 真麦克风 → 显示实际音量/静音状态; 假源(Monitor) → 固定显示
src="$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)"
if echo "$src" | grep -qi 'media.class.*Monitor'; then
	echo '{"text":" ","tooltip":""}'
	exit
fi

vol="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)"
[ -z "$vol" ] && echo '{"text":" ","tooltip":""}' && exit

pct=$(echo "$vol" | awk '{printf "%.0f", $2 * 100}')
if echo "$vol" | grep -qi MUTED; then
	echo "{\"text\":\" \",\"tooltip\":\"Mic muted\"}"
else
	echo "{\"text\":\" ${pct}%\",\"tooltip\":\"Mic: ${pct}%\"}"
fi
