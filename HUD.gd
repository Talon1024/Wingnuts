extends Control

const ShipControl = preload("res://Pilot.gd").ShipControl
onready var Player = get_parent().find_node("Player")

func _process(delta):
	var setSpeed = 0
	if Player.controlData[ShipControl.AFTERBURNER]:
		setSpeed = Player.afterburnerSpeed
	else:
		setSpeed = Player.controlData[ShipControl.THROTTLE] * Player.maxSpeed
	$SetDisplay.text = "SET: %.4f" % setSpeed
	if Player.controlData[ShipControl.GLIDE]:
		$SetDisplay.text += "G"
	$KpsDisplay.text = "KPS: %.4f" % Player.velocity.length()