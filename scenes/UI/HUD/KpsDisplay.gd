extends Label
class_name KpsSpeedDisplay


const Ship = preload("res://scenes/base/Ship.gd")


var player: Ship = null


func _ready():
	PlayerInfo.connect("added", self._on_player_added)
	PlayerInfo.connect("removed", self._on_player_removed)


func _process(delta):
	if not player:
		return

	text = "KPS: %.2f" % player.velocity.length()
	if player.control_data.glide:
		text += "G"


func _on_player_added(ship: Ship):
	player = ship


func _on_player_removed():
	player = null