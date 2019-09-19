extends Control

const ShipControl = preload("res://Pilot.gd").ShipControl
onready var Player = get_parent().find_node("Player")

func _process(delta):
	$SetDisplay.text = "SET: %.4f" % (Player.controlData[ShipControl.THROTTLE] * Player.maxSpeed)
	if Player.controlData[ShipControl.GLIDE]:
		$SetDisplay.text += "G"
	$KpsDisplay.text = "KPS: %.4f" % Player.velocity.length()