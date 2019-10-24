extends Node


# Classes
const Ship = preload("res://scenes/base/Ship.gd")


# Info
var ship: Ship


signal added
signal removed


func _ready():
	var hud = get_tree().current_scene.get_node("HUD")
	connect("added", hud, "_on_Player_added")
	connect("removed", hud, "_on_Player_removed")
