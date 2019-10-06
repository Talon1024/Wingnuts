extends "res://Pilot.gd"

func handle_key_pair(pos: String, neg: String):
	if Input.is_action_pressed(pos):
		return 1.0
	elif Input.is_action_pressed(neg):
		return -1.0
	else:
		return 0.0

func think(delta, controls: Dictionary) -> Dictionary:
	controls.pitch = handle_key_pair("pitch_down", "pitch_up")
	controls.yaw = handle_key_pair("turn_left", "turn_right")
	controls.roll = handle_key_pair("roll_right", "roll_left")
	if Input.is_action_just_pressed("speed_stop"):
		controls.throttle = 0
	elif Input.is_action_just_pressed("speed_full"):
		controls.throttle = 1
	elif Input.is_action_pressed("speed_increment"):
		#controls.throttle += throttleDeltaPerSec * delta
		controls.throttle += .25 * delta
	elif Input.is_action_pressed("speed_decrement"):
		#controls.throttle -= throttleDeltaPerSec * delta
		controls.throttle -= .25 * delta
	if controls.throttle > 1:
		controls.throttle = 1
	elif controls.throttle < 0:
		controls.throttle = 0
	if Input.is_action_just_pressed("toggle_glide"):
		controls.glide = not controls.glide
	controls.afterburner = Input.is_action_pressed("afterburner")
	controls.fire_gun = Input.is_action_pressed("fire_gun")
	controls.fire_missile = Input.is_action_pressed("fire_missile")
	return controls