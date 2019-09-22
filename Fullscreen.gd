extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("win_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
