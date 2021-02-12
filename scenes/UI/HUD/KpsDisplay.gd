extends Label
class_name KpsSpeedDisplay


const Ship = preload("res://scenes/base/Ship.gd")


var player: Ship = null


func _ready():
	var me = self as Object
	var added: Callable = Callable(me, "_on_player_added")
	var removed: Callable = Callable(me, "_on_player_removed")
	PlayerInfo.connect("added", added)
	PlayerInfo.connect("removed", removed)


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
