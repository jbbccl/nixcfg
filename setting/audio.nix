{ ... }:{
  # services.pulseaudio.enable = false;  # 禁用PulseAudio（使用PipeWire替代）
	security.rtkit.enable = true;  # 启用RTKit实时内核支持（用于音频权限）
	services.pipewire = {
		enable = true;  # 启用PipeWire多媒体框架
		alsa.enable = true;  # 启用PipeWire的ALSA兼容层
		alsa.support32Bit = true;  # 支持32位ALSA应用
		pulse.enable = true;  # 启用PulseAudio兼容层
	};
}
