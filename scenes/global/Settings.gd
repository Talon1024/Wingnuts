extends Node

enum BloomLevel {
	BLOOM_OFF,
	BLOOM_LIGHT,
	BLOOM_MEDIUM,
	BLOOM_HEAVY,
}

enum WindowType {
	WINDOW_FULLSCREEN,
	WINDOW_WINDOW,
	WINDOW_BORDERLESS,
}

var resolution: Vector2 = DisplayServer.screen_get_size()
# var window_type: int = WindowType.WINDOW_FULLSCREEN
# var bloom_level: int = BloomLevel.BLOOM_HEAVY
var tonemap: int = Environment.TONE_MAPPER_ACES # Environment.ToneMapper
var ssao: bool = true
var shadows: bool = true
var fov: int = 100

signal fov_changed
