extends Label
class_name SetSpeedDisplay


const Ship = preload("res://scenes/base/Ship.gd")


var player: Ship = null


func _ready():
	PlayerInfo.connect("added", self._on_player_added)
	PlayerInfo.connect("removed", self._on_player_removed)


func _process(delta):
	if not player:
		return
	var set_speed: float = 0.0
	if player.control_data.afterburner:
		set_speed = player.afterburner_speed
	else:
		set_speed = player.control_data.throttle * player.max_speed

	text = "SET: %.2f" % set_speed
	if player.control_data.glide:
		text += "G"


func _on_player_added(ship: Ship):
	player = ship


func _on_player_removed():
	player = null