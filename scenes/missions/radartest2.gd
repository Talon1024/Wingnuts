extends "res://scenes/base/Space.gd"

onready var yaw_display = $DebugInfo/DebugInfoContainer/YawContainer/YawValue
onready var pitch_display = $DebugInfo/DebugInfoContainer/PitchContainer/PitchValue
onready var roll_display = $DebugInfo/DebugInfoContainer/RollContainer/RollValue
onready var enemy_ship = $Ship
onready var player_ship = $Player
const Spherical = preload("res://scenes/util/spherical.gd")
const Intercept = preload("res://scenes/util/intercept.gd")


func _process(delta):
	var yprvec = enemy_ship.transform.xform_inv(player_ship.translation)
	var yprsph = Spherical.to_spherical(yprvec)
	yaw_display.text = "%.6f" % yprsph.z # Distance
	pitch_display.text = "%.6f" % yprsph.x
	roll_display.text = "%.6f" % (yprsph.y - PI / 2)
	# intercept stuff
	var player_global_velocity = player_ship.global_transform.basis.xform(player_ship.velocity)
	var intercept_time = Intercept.find_lead_time(enemy_ship.translation, player_ship.translation, player_global_velocity * delta, 200.0 * delta)
	if intercept_time > 0:
		$InterceptTarget.translation = player_ship.translation + (player_global_velocity * delta * intercept_time)
