extends Node3D
# Handles properly adding a ship to a mission.

enum PilotType {
	PILOT_PLAYER,
	PILOT_AI,
	PILOT_TURRET,
	PILOT_CAPSHIP,
}

@export var pilot_type: PilotType
@export var ship_class: PackedScene

func _ready():
	var ship = ship_class.instance()
	ship.connect("weapon_fired", get_parent()._on_Player_weapon_fired)
	get_parent().add_child(ship)
