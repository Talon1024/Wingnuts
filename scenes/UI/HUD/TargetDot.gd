extends Control


const Ship = preload("res://scenes/base/Ship.gd")


export(Texture) var target_image = preload("res://assets/UI/HUD/target.png")
var player: Ship
var target_position: Vector3
var has_target: bool


func _ready():
	PlayerInfo.connect("added", self, "_on_player_added")
	PlayerInfo.connect("removed", self, "_on_player_removed")


func _draw():
	if has_target:
		var pos = get_viewport().get_camera().unproject_position(target_position)
		draw_texture(target_image, pos)


func _process(delta):
	if player and player.target:
		target_position = player.target.translation
		has_target = true
	else:
		has_target = false
	update()


func _on_player_added(ship: Ship):
	player = ship


func _on_player_removed():
	player = null
