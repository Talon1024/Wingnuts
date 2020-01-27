extends "res://scenes/base/Space.gd"

onready var yaw_display = $DebugInfo/DebugInfoContainer/YawContainer/YawValue
onready var pitch_display = $DebugInfo/DebugInfoContainer/PitchContainer/PitchValue
onready var roll_display = $DebugInfo/DebugInfoContainer/RollContainer/RollValue
onready var enemy_ship = $Ship
onready var player_ship = $Player
const Spherical = preload("res://scenes/util/spherical.gd")


func _process(delta):
	var yprvec = enemy_ship.transform.xform_inv(player_ship.translation)
	var yprsph = Spherical.to_spherical(yprvec)
	yaw_display.text = "%.6f" % yprsph.z # Distance
	pitch_display.text = "%.6f" % yprsph.x
	roll_display.text = "%.6f" % (yprsph.y - PI / 2)
	# intercept stuff
	var player_global_velocity = player_ship.global_transform.basis.xform(player_ship.velocity)
	var intercept_time = find_intercept_time(enemy_ship.translation, player_ship.translation, player_global_velocity * delta, 200.0 * delta)
	if intercept_time >= 0:
		$InterceptTarget.translation = player_ship.translation + (player_global_velocity * delta * intercept_time)

# https://officialtwelve.blogspot.com/2015/08/projectile-interception.html
# https://stackoverflow.com/questions/17204513/how-to-find-the-interception-coordinates-of-a-moving-target-in-3d-space
# https://indyandyjones.wordpress.com/2010/04/08/intercepting-a-target-with-projectile/
# Position after a given amount of time = original position + velocity * time

func find_intercept_time(shot_pos: Vector3, target_pos: Vector3, target_vel: Vector3, shot_speed: float) -> float:
	var to_target = target_pos - shot_pos
	var a = target_vel.length_squared() - shot_speed * shot_speed
	var b = 2 * target_vel.dot(to_target)
	var c = to_target.length_squared()
	if (b * b) < (4 * a * c):
		return -1.0
	# var time_a = (-b + sqrt((b * b) - (4 * a * c))) / (2 * a)
	var time_b = (-b - sqrt((b * b) - (4 * a * c))) / (2 * a)
	return time_b
