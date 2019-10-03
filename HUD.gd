extends Control

const ShipControl = preload("res://Pilot.gd").ShipControl
onready var Player = get_parent().find_node("Player")

func _process(delta):
	var set_speed = 0
	if Player.control_data[ShipControl.AFTERBURNER]:
		set_speed = Player.afterburner_speed
	else:
		set_speed = Player.control_data[ShipControl.THROTTLE] * Player.max_speed

	$SetContainer/SetDisplay.text = "SET: %.4f" % set_speed
	$KpsContainer/KpsDisplay.text = "KPS: %.4f" % Player.velocity.length()

	if Player.control_data[ShipControl.GLIDE]:
		$SetContainer/SetDisplay.text += "G"
		$KpsContainer/KpsDisplay.text += "G"