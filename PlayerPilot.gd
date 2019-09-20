extends "res://Pilot.gd"

func think(delta, controls: Array):
	if Input.is_action_pressed("pitch_up"):
		controls[ShipControl.PITCH] = -1
	elif Input.is_action_pressed("pitch_down"):
		controls[ShipControl.PITCH] = 1
	else:
		controls[ShipControl.PITCH] = 0
	if Input.is_action_pressed("turn_left"):
		controls[ShipControl.YAW] = 1
	elif Input.is_action_pressed("turn_right"):
		controls[ShipControl.YAW] = -1
	else:
		controls[ShipControl.YAW] = 0
	if Input.is_action_pressed("roll_left"):
		controls[ShipControl.ROLL] = -1
	elif Input.is_action_pressed("roll_right"):
		controls[ShipControl.ROLL] = 1
	else:
		controls[ShipControl.ROLL] = 0
	if Input.is_action_just_pressed("speed_stop"):
		controls[ShipControl.THROTTLE] = 0
	elif Input.is_action_just_pressed("speed_full"):
		controls[ShipControl.THROTTLE] = 1
	elif Input.is_action_pressed("speed_increment"):
		#controls.throttle += throttleDeltaPerSec * delta
		controls[ShipControl.THROTTLE] += .25 * delta
	elif Input.is_action_pressed("speed_decrement"):
		#controls.throttle -= throttleDeltaPerSec * delta
		controls[ShipControl.THROTTLE] -= .25 * delta
	if controls[ShipControl.THROTTLE] > 1:
		controls[ShipControl.THROTTLE] = 1
	elif controls[ShipControl.THROTTLE] < 0:
		controls[ShipControl.THROTTLE] = 0
	if Input.is_action_just_pressed("toggle_glide"):
		controls[ShipControl.GLIDE] = not controls[ShipControl.GLIDE]
	if Input.is_action_pressed("afterburner"):
		controls[ShipControl.AFTERBURNER] = true
	else:
		controls[ShipControl.AFTERBURNER] = false
	return controls