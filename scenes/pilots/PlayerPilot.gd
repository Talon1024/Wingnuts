extends "res://scenes/pilots/Pilot.gd"
class_name PilotPlayer, "res://editor/icons/pilot.png"

# Return 1 if an action is pressed, return -1 if another action is pressed,
# or 0 if neither is pressed.
func handle_key_pair(pos: String, neg: String) -> float:
	if Input.is_action_pressed(pos):
		return 1.0
	elif Input.is_action_pressed(neg):
		return -1.0
	else:
		return 0.0

# Handle player's inputs
func think(delta, controls: Dictionary) -> Dictionary:
	controls.pitch = handle_key_pair("pitch_up", "pitch_down")
	controls.yaw = handle_key_pair("turn_left", "turn_right")
	controls.roll = handle_key_pair("roll_left", "roll_right")
	if Input.is_action_just_pressed("speed_stop"):
		controls.throttle = 0
	elif Input.is_action_just_pressed("speed_full"):
		controls.throttle = 1
	elif Input.is_action_pressed("speed_increment"):
		controls.throttle += .25 * delta
	elif Input.is_action_pressed("speed_decrement"):
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