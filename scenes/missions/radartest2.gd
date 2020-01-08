extends "res://scenes/base/Space.gd"

onready var yaw_display = $DebugInfo/DebugInfoContainer/YawContainer/YawValue
onready var pitch_display = $DebugInfo/DebugInfoContainer/PitchContainer/PitchValue
onready var roll_display = $DebugInfo/DebugInfoContainer/RollContainer/RollValue
onready var enemy_ship = $Ship
const Spherical = preload("res://scenes/util/spherical.gd")

func _process(delta):
	var yprvec = $Ship.transform.xform_inv($Player.translation)
	var yprsph = Spherical.to_spherical(yprvec)
	yaw_display.text = "%.6f" % yprsph.z # Distance
	pitch_display.text = "%.6f" % yprsph.x
	roll_display.text = "%.6f" % (yprsph.y - PI / 2)
