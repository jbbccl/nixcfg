#!/usr/bin/env bash
# =============================================
# Waybar 麦克风模块脚本
# 真麦克风 → 显示音量/静音
# Monitor/Dummy 等虚拟源 → 只显示 
# =============================================

# 获取默认音频输入源信息
if ! src_info=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null); then
    echo '{"text":" ","tooltip":"No source available"}'
    exit 0
fi

# 如果是 Monitor（虚拟源），直接显示静音图标
if echo "$src_info" | grep -qi 'media.class.*Monitor'; then
    echo '{"text":" ","tooltip":"Monitor source (no real mic)"}'
    exit 0
fi

# 获取音量信息
if ! vol=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null); then
    echo '{"text":" ","tooltip":"Failed to get volume"}'
    exit 0
fi

# 提取百分比
pct=$(echo "$vol" | awk '{printf "%.0f", $2 * 100}')

if echo "$vol" | grep -qi MUTED; then
    echo "{\"text\":\" \",\"tooltip\":\"麦克风已静音\"}"
else
    echo "{\"text\":\" ${pct}%\",\"tooltip\":\"麦克风: ${pct}%\"}"
fi